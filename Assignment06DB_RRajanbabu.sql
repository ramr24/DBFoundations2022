--*************************************************************************--
-- Title: Assignment06
-- Author: RRajanbabu
-- Desc: This file demonstrates how to use Views
-- Change Log: When,Who,What
-- 2022-08-15, RRajanbabu, Created File
-- 2022-08-16, RRajanbabu, Completed Questions 1-8
-- 2022-08-17, RRajanbabu, Completed Questions 9-10
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment06DB_RRajanbabu')
	 Begin 
	  Alter Database [Assignment06DB_RRajanbabu] set Single_user With Rollback Immediate;
	  Drop Database Assignment06DB_RRajanbabu;
	 End
	Create Database Assignment06DB_RRajanbabu;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment06DB_RRajanbabu;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [mOney] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, UnitsInStock
From Northwind.dbo.Products
UNIOn
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, UnitsInStock + 10 -- Using this is to create a made up value
From Northwind.dbo.Products
UNIOn
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, UnitsInStock + 20 -- Using this is to create a made up value
From Northwind.dbo.Products
Order By 1, 2
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From Categories;
go
Select * From Products;
go
Select * From Employees;
go
Select * From Inventories;
go

/********************************* Questions and Answers *********************************/
print 
'NOTES------------------------------------------------------------------------------------ 
 1) You can use any name you like for you views, but be descriptive and consistent
 2) You can use your working code from assignment 5 for much of this assignment
 3) You must use the BASIC views for each table after they are created in Question 1
------------------------------------------------------------------------------------------'
GO
-- Question 1 (5% pts): How can you create BASIC views to show data from each table in the database. -- COMPLETED
-- NOTES: 1) Do not use a *, list out each column!
--        2) Create one view per table!
--		  3) Use SchemaBinding to protect the views from being orphaned!
-- vCategories Table
-- Attempt 1
-- CREATE VIEW vCategories
-- AS
-- SELECT 
-- 	CategoryID,
-- 	CategoryName
-- FROM Categories;
-- GO
-- Final Answer (SCHEMABINDING)
CREATE VIEW vCategories
WITH SCHEMABINDING
AS
SELECT 
	CategoryID,
	CategoryName
FROM dbo.Categories;
GO

-- vProducts Table
-- Attempt 1
-- CREATE VIEW vProducts
-- AS
-- SELECT
-- 	ProductID,
-- 	ProductName,
-- 	CategoryID,
-- 	UnitPrice
-- FROM Products;
-- GO
-- Final Answer (SCHEMABINDING)
CREATE VIEW vProducts
WITH SCHEMABINDING
AS
SELECT
	ProductID,
	ProductName,
	CategoryID,
	UnitPrice
FROM dbo.Products;
GO

-- vEmployees Table
-- Attempt 1
-- CREATE VIEW vEmployees
-- AS
-- SELECT
-- 	EmployeeID,
-- 	EmployeeFirstName,
-- 	EmployeeLastName,
-- 	ManagerID
-- FROM Employees;
-- GO
-- Final Answer (SCHEMABINDING)
CREATE VIEW vEmployees
WITH SCHEMABINDING
AS
SELECT
	EmployeeID,
	EmployeeFirstName,
	EmployeeLastName,
	ManagerID
FROM dbo.Employees;
GO

-- vInventories Table
-- Attempt 1
-- CREATE VIEW vInventories
-- AS
-- SELECT
-- 	InventoryID,
-- 	InventoryDate,
-- 	EmployeeID,
-- 	ProductID,
-- 	Count
-- FROM Inventories;
-- GO
-- Final Answer (SCHEMABINDING)
CREATE VIEW vInventories
WITH SCHEMABINDING
AS
SELECT
	InventoryID,
	InventoryDate,
	EmployeeID,
	ProductID,
	Count
FROM dbo.Inventories;
GO

-- Question 2 (5% pts): How can you set permissions, so that the public group CANNOT select data 
-- from each table, but can select data from each view? -- COMPLETE
-- Final Answer
-- vCategories Table
DENY SELECT ON Categories to PUBLIC;
GRANT SELECT ON vCategories to PUBLIC;
GO
-- vProducts Table
DENY SELECT ON Products to PUBLIC;
GRANT SELECT ON vProducts to PUBLIC;
GO
-- vEmployees Table
DENY SELECT ON Employees to PUBLIC;
GRANT SELECT ON vEmployees to PUBLIC;
GO
-- vInventories Table
DENY SELECT ON Inventories to PUBLIC;
GRANT SELECT ON vInventories to PUBLIC;
GO

-- Question 3 (10% pts): How can you create a view to show a list of Category and Product names, 
-- and the price of each product?
-- Order the result by the Category and Product! -- COMPLETE
-- Attempt 1
-- SELECT * FROM vCategories;
-- GO
-- SELECT * FROM vProducts;
-- GO
-- Attempt 2
-- SELECT 
-- 	CategoryName,
-- 	vProducts.ProductName,
-- 	vProducts.UnitPrice
-- FROM vCategories
-- JOIN vProducts
-- ON vCategories.CategoryID = vProducts.CategoryID;
-- Final Answer
CREATE VIEW vProductsByCategories
AS
SELECT TOP 1000000000
	CategoryName,
	vProducts.ProductName,
	vProducts.UnitPrice
FROM vCategories
JOIN vProducts
ON vCategories.CategoryID = vProducts.CategoryID
ORDER BY 1, 2;
GO

-- Example Answer
-- Here is an example of some rows selected from the view:
-- CategoryName ProductName       UnitPrice
-- Beverages    Chai              18.00
-- Beverages    Chang             19.00
-- Beverages    Chartreuse verte  18.00

-- Question 4 (10% pts): How can you create a view to show a list of Product names 
-- and Inventory Counts on each Inventory Date?
-- Order the results by the Product, Date, and Count! -- COMPLETE
-- Attempt 1
-- SELECT * FROM vProducts;
-- GO
-- SELECT * FROM vInventories;
-- GO
-- Attempt 2
-- SELECT
-- 	ProductName,
-- 	vInventories.InventoryDate,
-- 	vInventories.[Count]
-- FROM vProducts 
-- JOIN vInventories
-- ON vProducts.ProductID = vInventories.ProductID;
-- GO
-- Attempt 3
-- SELECT DISTINCT
-- 	ProductName,
-- 	vInventories.InventoryDate,
-- 	vInventories.[Count]
-- FROM vProducts 
-- JOIN vInventories
-- ON vProducts.ProductID = vInventories.ProductID;
-- GO
-- Final Answer
CREATE VIEW vInventoriesByProductsByDates
AS
SELECT DISTINCT TOP 1000000000
	ProductName,
	vInventories.InventoryDate,
	vInventories.[Count]
FROM vProducts 
JOIN vInventories
ON vProducts.ProductID = vInventories.ProductID
ORDER BY 1, 2, 3;
GO

-- Example Answer
-- Here is an example of some rows selected from the view:
-- ProductName	  InventoryDate	Count
-- Alice Mutton	  2017-01-01	  0
-- Alice Mutton	  2017-02-01	  10
-- Alice Mutton	  2017-03-01	  20
-- Aniseed Syrup	2017-01-01	  13
-- Aniseed Syrup	2017-02-01	  23
-- Aniseed Syrup	2017-03-01	  33

-- Question 5 (10% pts): How can you create a view to show a list of Inventory Dates 
-- and the Employee that took the count?
-- Order the results by the Date and return only one row per date! -- COMPLETE
-- Attempt 1
-- SELECT * FROM vInventories;
-- GO
-- SELECT * FROM vEmployees;
-- GO
-- Attempt 2
-- SELECT
-- 	InventoryDate,
-- 	EmployeeName = vEmployees.EmployeeFirstName + ' ' + vEmployees.EmployeeLastName
-- FROM vInventories
-- JOIN vEmployees
-- ON vInventories.EmployeeID = vEmployees.EmployeeID;
-- GO
-- Final Answer
CREATE VIEW vInventoriesByEmployeesByDates
AS
SELECT DISTINCT TOP 1000000000
	InventoryDate,
	EmployeeName = vEmployees.EmployeeFirstName + ' ' + vEmployees.EmployeeLastName
FROM vInventories
JOIN vEmployees
ON vInventories.EmployeeID = vEmployees.EmployeeID
ORDER BY 1, 2;
GO

-- Example Answer
-- Here is are the rows selected from the view:
-- InventoryDate	EmployeeName
-- 2017-01-01	    Steven Buchanan
-- 2017-02-01	    Robert King
-- 2017-03-01	    Anne Dodsworth

-- Question 6 (10% pts): How can you create a view show a list of Categories, Products, 
-- and the Inventory Date and Count of each product?
-- Order the results by the Category, Product, Date, and Count! -- COMPLETE
-- Attempt 1
-- SELECT * FROM vCategories;
-- GO
-- SELECT * FROM vProducts;
-- GO
-- SELECT * FROM vInventories;
-- GO
-- Attempt 2
-- SELECT
-- 	CategoryName,
-- 	vProducts.ProductName
-- FROM vCategories
-- INNER JOIN vProducts
-- ON vCategories.CategoryID = vProducts.CategoryID;
-- GO
-- Attempt 3
-- SELECT
-- 	CategoryName,
-- 	vProducts.ProductName,
-- 	vInventories.InventoryDate,
-- 	vInventories.Count
-- FROM vCategories
-- INNER JOIN vProducts
-- ON vCategories.CategoryID = vProducts.CategoryID
-- INNER JOIN vInventories
-- ON vProducts.ProductID = vInventories.ProductID;
-- GO
-- Final Answer
CREATE VIEW vInventoriesByProductsByCategories
AS
SELECT TOP 1000000000
	CategoryName,
	vProducts.ProductName,
	vInventories.InventoryDate,
	vInventories.Count
FROM vCategories
INNER JOIN vProducts
ON vCategories.CategoryID = vProducts.CategoryID
INNER JOIN vInventories
ON vProducts.ProductID = vInventories.ProductID
ORDER BY 1, 2, 3, 4;
GO

-- Example Answer
-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count
-- CategoryName	ProductName	InventoryDate	Count
-- Beverages	  Chai	      2017-01-01	  39
-- Beverages	  Chai	      2017-02-01	  49
-- Beverages	  Chai	      2017-03-01	  59
-- Beverages	  Chang	      2017-01-01	  17
-- Beverages	  Chang	      2017-02-01	  27
-- Beverages	  Chang	      2017-03-01	  37


-- Question 7 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the EMPLOYEE who took the count?
-- Order the results by the Inventory Date, Category, Product and Employee! -- COMPLETE
-- Attempt 1
-- SELECT * FROM vCategories;
-- GO
-- SELECT * FROM vProducts;
-- GO
-- SELECT * FROM vInventories;
-- GO
-- SELECT * FROM vEmployees;
-- GO
-- Attempt 2
-- SELECT
-- 	CategoryName,
-- 	vProducts.ProductName,
-- 	vInventories.InventoryDate,
-- 	vInventories.Count
-- FROM vCategories
-- INNER JOIN vProducts
-- ON vCategories.CategoryID = vProducts.CategoryID
-- INNER JOIN vInventories
-- ON vProducts.ProductID = vInventories.ProductID;
-- GO
-- Attempt 3
-- SELECT
-- 	CategoryName,
-- 	vProducts.ProductName,
-- 	vInventories.InventoryDate,
-- 	vInventories.Count,
-- 	EmployeeName = vEmployees.EmployeeFirstName + ' ' + vEmployees.EmployeeLastName
-- FROM vCategories
-- INNER JOIN vProducts
-- ON vCategories.CategoryID = vProducts.CategoryID
-- INNER JOIN vInventories
-- ON vProducts.ProductID = vInventories.ProductID
-- INNER JOIN vEmployees
-- ON vInventories.EmployeeID = vEmployees.EmployeeID
-- GO
-- Final Answer
CREATE VIEW vInventoriesByProductsByEmployees
AS
SELECT TOP 1000000000
	CategoryName,
	vProducts.ProductName,
	vInventories.InventoryDate,
	vInventories.Count,
	EmployeeName = vEmployees.EmployeeFirstName + ' ' + vEmployees.EmployeeLastName
FROM vCategories
INNER JOIN vProducts
ON vCategories.CategoryID = vProducts.CategoryID
INNER JOIN vInventories
ON vProducts.ProductID = vInventories.ProductID
INNER JOIN vEmployees
ON vInventories.EmployeeID = vEmployees.EmployeeID
ORDER BY 3, 1, 2, 5;
GO

-- Example Answer
-- Here is an example of some rows selected from the view:
-- CategoryName	ProductName	        InventoryDate	Count	EmployeeName
-- Beverages	  Chai	              2017-01-01	  39	  Steven Buchanan
-- Beverages	  Chang	              2017-01-01	  17	  Steven Buchanan
-- Beverages	  Chartreuse verte	  2017-01-01	  69	  Steven Buchanan
-- Beverages	  C�te de Blaye	      2017-01-01	  17	  Steven Buchanan
-- Beverages	  Guaran� Fant�stica	2017-01-01	  20	  Steven Buchanan
-- Beverages	  Ipoh Coffee	        2017-01-01	  17	  Steven Buchanan
-- Beverages	  Lakkalik��ri	      2017-01-01	  57	  Steven Buchanan

-- Question 8 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the Employee who took the count
-- for the Products 'Chai' and 'Chang'? -- COMPLETE
-- Attempt 1
-- SELECT * FROM vCategories;
-- GO
-- SELECT * FROM vProducts;
-- GO
-- SELECT * FROM vInventories;
-- GO
-- SELECT * FROM vEmployees;
-- GO
-- Attempt 2
-- SELECT
-- 	CategoryName,
-- 	vProducts.ProductName,
-- 	vInventories.InventoryDate,
-- 	vInventories.Count,
-- 	EmployeeName = vEmployees.EmployeeFirstName + ' ' + vEmployees.EmployeeLastName
-- FROM vCategories
-- INNER JOIN vProducts
-- ON vCategories.CategoryID = vProducts.CategoryID
-- INNER JOIN vInventories
-- ON vProducts.ProductID = vInventories.ProductID
-- INNER JOIN vEmployees
-- ON vInventories.EmployeeID = vEmployees.EmployeeID;
-- GO
-- Final Answer
CREATE VIEW vInventoriesForChaiAndChangByEmployees
AS
SELECT TOP 1000000000
	CategoryName,
	vProducts.ProductName,
	vInventories.InventoryDate,
	vInventories.Count,
	EmployeeName = vEmployees.EmployeeFirstName + ' ' + vEmployees.EmployeeLastName
FROM vCategories
INNER JOIN vProducts
ON vCategories.CategoryID = vProducts.CategoryID
INNER JOIN vInventories
ON vProducts.ProductID = vInventories.ProductID
INNER JOIN vEmployees
ON vInventories.EmployeeID = vEmployees.EmployeeID
WHERE (vProducts.ProductName = 'Chai')
OR (vProducts.ProductName = 'Chang');
GO

-- Example Answer
-- Here are the rows selected from the view:
-- CategoryName	ProductName	InventoryDate	Count	EmployeeName
-- Beverages	  Chai	      2017-01-01	  39	  Steven Buchanan
-- Beverages	  Chang	      2017-01-01	  17	  Steven Buchanan
-- Beverages	  Chai	      2017-02-01	  49	  Robert King
-- Beverages	  Chang	      2017-02-01	  27	  Robert King
-- Beverages	  Chai	      2017-03-01	  59	  Anne Dodsworth
-- Beverages	  Chang	      2017-03-01	  37	  Anne Dodsworth

-- Question 9 (10% pts): How can you create a view to show a list of Employees and the Manager who manages them?
-- Order the results by the Manager's name! -- COMPLETE
-- Attempt 1
-- SELECT * FROM vEmployees;
-- GO
-- Attempt 2
-- SELECT 
-- 	Emp.EmployeeID,
-- 	Employee = Emp.EmployeeFirstName + ' ' + Emp.EmployeeLastName,
-- 	Emp.ManagerID
-- FROM vEmployees AS Emp;
-- GO
-- Attempt 3
-- SELECT
-- 	Mgr.EmployeeID AS ManagerID,
-- 	Manager = Mgr.EmployeeFirstName + ' ' + Mgr.EmployeeLastName,
-- 	Emp.EmployeeID,
-- 	Employee = Emp.EmployeeFirstName + ' ' + Emp.EmployeeLastName
-- FROM vEmployees AS Emp
-- INNER JOIN vEmployees AS Mgr
-- ON Emp.ManagerID = Mgr.EmployeeID;
-- GO
-- Final Answer
CREATE VIEW vEmployeesByManager
AS
SELECT TOP 1000000000
	Manager = Mgr.EmployeeFirstName + ' ' + Mgr.EmployeeLastName,
	Employee = Emp.EmployeeFirstName + ' ' + Emp.EmployeeLastName
FROM vEmployees AS Emp
INNER JOIN vEmployees AS Mgr
ON Emp.ManagerID = Mgr.EmployeeID
ORDER BY 1, 2;
GO

-- Example Answer
-- Here are the rows selected from the view:
-- Manager	        Employee
-- Andrew Fuller	  Andrew Fuller
-- Andrew Fuller	  Janet Leverling
-- Andrew Fuller	  Laura Callahan
-- Andrew Fuller	  Margaret Peacock
-- Andrew Fuller	  Nancy Davolio
-- Andrew Fuller	  Steven Buchanan
-- Steven Buchanan	Anne Dodsworth
-- Steven Buchanan	Michael Suyama
-- Steven Buchanan	Robert King

-- Question 10 (20% pts): How can you create one view to show all the data from all four 
-- BASIC Views? Also show the Employee's Manager Name and order the data by 
-- Category, Product, InventoryID, and Employee. -- COMPLETE
-- Attempt 1
-- SELECT * FROM vCategories;
-- GO
-- SELECT * FROM vProducts;
-- GO
-- SELECT * FROM vInventories;
-- GO
-- SELECT * FROM vEmployees;
-- GO
-- Attempt 2
-- SELECT
-- 	CategoryID,
-- 	CategoryName
-- FROM vCategories;
-- GO
-- Attempt 3
-- SELECT
-- 	CategoryID,
-- 	CategoryName
-- FROM vCategories;
-- GO
-- Attempt 4
-- SELECT
-- 	vCategories.CategoryID,
-- 	CategoryName,
-- 	vProducts.ProductID,
-- 	vProducts.ProductName,
-- 	vProducts.UnitPrice
-- FROM vCategories
-- JOIN vProducts
-- ON vCategories.CategoryID = vProducts.CategoryID;
-- GO
-- Attempt 5
-- SELECT
-- 	vCategories.CategoryID,
-- 	CategoryName,
-- 	vProducts.ProductID,
-- 	vProducts.ProductName,
-- 	vProducts.UnitPrice,
-- 	vInventories.InventoryID,
-- 	vInventories.InventoryDate,
-- 	vInventories.[Count]
-- FROM vCategories
-- JOIN vProducts
-- ON vCategories.CategoryID = vProducts.CategoryID
-- JOIN vInventories
-- ON vProducts.ProductID = vInventories.ProductID;
-- GO
-- Attempt 6
-- SELECT
-- 	vCategories.CategoryID,
-- 	CategoryName,
-- 	vProducts.ProductID,
-- 	vProducts.ProductName,
-- 	vProducts.UnitPrice,
-- 	vInventories.InventoryID,
-- 	vInventories.InventoryDate,
-- 	vInventories.[Count],
-- 	vEmployees.EmployeeID,
-- 	EmployeeName = vEmployees.EmployeeFirstName + ' ' + vEmployees.EmployeeLastName
-- FROM vCategories
-- JOIN vProducts
-- ON vCategories.CategoryID = vProducts.CategoryID
-- JOIN vInventories
-- ON vProducts.ProductID = vInventories.ProductID
-- JOIN vEmployees
-- ON vInventories.EmployeeID = vEmployees.EmployeeID;
-- GO
-- Attempt 7
-- SELECT
-- 	vCategories.CategoryID,
-- 	CategoryName,
-- 	vProducts.ProductID,
-- 	vProducts.ProductName,
-- 	vProducts.UnitPrice,
-- 	vInventories.InventoryID,
-- 	vInventories.InventoryDate,
-- 	vInventories.[Count],
-- 	Emp.EmployeeID,
-- 	Employee = Emp.EmployeeFirstName + ' ' + Emp.EmployeeLastName
-- FROM vCategories
-- JOIN vProducts
-- ON vCategories.CategoryID = vProducts.CategoryID
-- JOIN vInventories
-- ON vProducts.ProductID = vInventories.ProductID
-- JOIN vEmployees AS Emp
-- ON vInventories.EmployeeID = Emp.EmployeeID
-- JOIN vEmployees AS Mgr
-- ON Emp.ManagerID = Mgr.EmployeeID;
-- GO
-- Final Answer
CREATE VIEW vInventoriesByProductsByCategoriesByEmployees
AS
SELECT TOP 1000000000
	vCategories.CategoryID,
	CategoryName,
	vProducts.ProductID,
	vProducts.ProductName,
	vProducts.UnitPrice,
	vInventories.InventoryID,
	vInventories.InventoryDate,
	vInventories.[Count],
	Emp.EmployeeID,
	Employee = Emp.EmployeeFirstName + ' ' + Emp.EmployeeLastName
FROM vCategories
JOIN vProducts
ON vCategories.CategoryID = vProducts.CategoryID
JOIN vInventories
ON vProducts.ProductID = vInventories.ProductID
JOIN vEmployees AS Emp
ON vInventories.EmployeeID = Emp.EmployeeID
JOIN vEmployees AS Mgr
ON Emp.ManagerID = Mgr.EmployeeID
ORDER BY 1, 3, 6, 9;
GO

-- Example Answer
-- Here is an example of some rows selected from the view:
-- CategoryID	CategoryName	ProductID	ProductName				UnitPrice	InventoryID	InventoryDate	Count	EmployeeID	Employee
-- 1	        Beverages	    1	        Chai	                18.00	    1	        2017-01-01	    39	    5	        Steven Buchanan
-- 1	        Beverages	    1	        Chai	                18.00	    78	        2017-02-01	    49	    7	        Robert King
-- 1	        Beverages	    1	        Chai	                18.00	    155	        2017-03-01	    59	    9	        Anne Dodsworth
-- 1	        Beverages	    2	        Chang	                19.00	    2	        2017-01-01	    17	    5	        Steven Buchanan
-- 1	        Beverages	    2	        Chang	                19.00	    79	        2017-02-01	    27	    7	        Robert King
-- 1	        Beverages	    2	        Chang	                19.00	    156	        2017-03-01	    37	    9	        Anne Dodsworth
-- 1	        Beverages	    24	        Guaran� Fant�stica	   4.50	       24	       2017-01-01	   20	  5	           Steven Buchanan
-- 1	        Beverages	    24	        Guaran� Fant�stica	   4.50	      101	       2017-02-01	   30	  7	           Robert King
-- 1	        Beverages	    24	        Guaran� Fant�stica	   4.50	      178	       2017-03-01	   40	  9	           Anne Dodsworth
-- 1	        Beverages	    34	        Sasquatch Ale	        14.00	    34	        2017-01-01	    111	    5	         Steven Buchanan
-- 1	        Beverages	    34	        Sasquatch Ale	        14.00	    111	        2017-02-01	    121	    7	         Robert King
-- 1	        Beverages	    34	        Sasquatch Ale	        14.00	    188	        2017-03-01	    131	    9	         Anne Dodsworth

-- Test your Views (NOTE: You must change the names to match yours as needed!)
Print 'Note: You will get an error until the views are created!'
SELECT * FROM [dbo].[vCategories]
SELECT * FROM [dbo].[vProducts]
SELECT * FROM [dbo].[vInventories]
SELECT * FROM [dbo].[vEmployees]

SELECT * FROM [dbo].[vProductsByCategories]
SELECT * FROM [dbo].[vInventoriesByProductsByDates]
SELECT * FROM [dbo].[vInventoriesByEmployeesByDates]
SELECT * FROM [dbo].[vInventoriesByProductsByCategories]
SELECT * FROM [dbo].[vInventoriesByProductsByEmployees]
SELECT * FROM [dbo].[vInventoriesForChaiAndChangByEmployees]
SELECT * FROM [dbo].[vEmployeesByManager]
SELECT * FROM [dbo].[vInventoriesByProductsByCategoriesByEmployees]
/***************************************************************************************/