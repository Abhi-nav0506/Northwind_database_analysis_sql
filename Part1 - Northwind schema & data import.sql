CREATE SCHEMA northwind;
USE northwind;
CREATE TABLE Categories (CategoryID INT(11) PRIMARY KEY, CategoryName VARCHAR(15), Description MEDIUMTEXT);

-- Populating data into 'categories' table
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Northwind_database_csv/categories.csv'
INTO TABLE categories
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


CREATE TABLE Suppliers (SupplierID INT(11) PRIMARY KEY, CompanyName VARCHAR(40), ContactName VARCHAR(30), ContactTitle VARCHAR(30),
                        Address VARCHAR(60), City VARCHAR(15), Region VARCHAR(15), PostalCode VARCHAR(10), 
                        Country VARCHAR(15), Phone VARCHAR(24), Fax VARCHAR(24), HomePage MEDIUMTEXT);

-- Populating data into 'suppliers' table
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Northwind_database_csv/suppliers.csv'
INTO TABLE suppliers
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

CREATE TABLE CustomerDemographics (CustomerTypeID VARCHAR(10) PRIMARY KEY, CusotmerDesc MEDIUMTEXT);

CREATE TABLE Customers (CustomerID VARCHAR(5) PRIMARY KEY, CompanyName VARCHAR(40), ContactName VARCHAR(30), ContactTitle VARCHAR(30),
                       Address VARCHAR(60), City VARCHAR (15), Region VARCHAR(15), PostalCode VARCHAR(10), Country VARCHAR(15),
                       Phone VARCHAR(24), Fax VARCHAR(24));

-- Populating data into 'customers' table
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Northwind_database_csv/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

CREATE TABLE CustomerCustomerDemo (CustomerID VARCHAR(5), CustomerTypeID VARCHAR(10), 
				   PRIMARY KEY (CustomerID, CustomerTypeID), 
                                   FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
				   FOREIGN KEY (CustomerTypeID) REFERENCES CustomerDemographics(CustomerTypeID));

CREATE TABLE Shippers (ShipperID INT(11) PRIMARY KEY, CompanyName VARCHAR(40), Phone VARCHAR(24));

-- Populating data into 'shippers' table
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Northwind_database_csv/shippers.csv'
INTO TABLE shippers
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

CREATE TABLE Products (ProductID INT(11) PRIMARY KEY, ProductName VARCHAR(50), SupplierID INT(11), CategoryID INT(11),
                       QuantityPerUnit VARCHAR(30), UnitPrice DECIMAL(10,4), UnitsInStock SMALLINT(2), UnitsOnOrder SMALLINT(2),
                       ReorderLevel SMALLINT(2), Discontinued INT(1), 
		       FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
                       FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID));

-- Populating data into 'products' table
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Northwind_database_csv/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


CREATE TABLE Region (RegionID INT(11) PRIMARY KEY, RegionDescription VARCHAR(50));

-- Populating data into 'region' table
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Northwind_database_csv/regions.csv'
INTO TABLE region
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

CREATE TABLE Territories (TerritoryID VARCHAR(20) PRIMARY KEY, TerritoryDescription VARCHAR(50), RegionID INT(11),
  	                  FOREIGN KEY (RegionID) REFERENCES Region(RegionID));

-- Populating data into 'territories' table
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Northwind_database_csv/territories.csv'
INTO TABLE territories
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

CREATE TABLE Employees (EmployeeID INT(11) PRIMARY KEY, LastName VARCHAR(20), FirstName VARCHAR(20), Title VARCHAR(30), 
                        TitleOfCourtsey VARCHAR(25), BirthDate DATETIME, HireDate DATETIME, Address VARCHAR(60),
                        City VARCHAR(15), Region VARCHAR(15), PostalCode VARCHAR(10), Country VARCHAR(15), HomePhone VARCHAR(24),
                        Extension VARCHAR(4), Notes MEDIUMTEXT, ReportsTo INT(11) NULL, PhotoPath VARCHAR(255), Salary FLOAT);

-- Populating data into 'employees' table
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Northwind_database_csv/employees.csv'
INTO TABLE employees
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(EmployeeID,LastName,FirstName,Title,TitleOfCourtsey,BirthDate,HireDate,Address,City,Region,PostalCode,Country,
HomePhone,Extension,Notes,@ReportsTo,PhotoPath,Salary)
SET ReportsTo = NULLIF(@ReportsTo, 'NULL');

ALTER TABLE employees ADD CONSTRAINT fk FOREIGN KEY (ReportsTo) REFERENCES employees(EmployeeID);


CREATE TABLE EmployeeTerritories (EmployeeID INT(11), TerritoryID VARCHAR(20), 
                                  PRIMARY KEY (EmployeeID, TerritoryID),
                                  FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
                                  FOREIGN KEY (TerritoryID) REFERENCES Territories(TerritoryID));

-- Populating data into 'employeeterritories' table
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Northwind_database_csv/employee-territories.csv'
INTO TABLE employeeterritories
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


CREATE TABLE Orders (OrderID INT(11) PRIMARY KEY, CustomerID VARCHAR(5), EmployeeID INT(11), OrderDate DATETIME,
                     RequiredDate DATETIME, ShippedDate DATETIME NULL, ShipVia INT(11), Freight DECIMAL(10,4), ShipName VARCHAR(40),
                     ShipAddress VARCHAR(60), ShipCity VARCHAR(15), ShipRegion VARCHAR(15), ShipPostalCode VARCHAR(10),
                     ShipCountry VARCHAR(15),
		     FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
                     FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
		     FOREIGN KEY (ShipVia) REFERENCES Shippers(ShipperID));

-- Populating data into 'orders' table
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Northwind_database_csv/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,@ShippedDate,ShipVia,Freight,ShipName,ShipAddress,ShipCity,
ShipRegion,ShipPostalCode,ShipCountry)
SET ShippedDate = NULLIF(@ShippedDate, 'NULL');

CREATE TABLE OrderDetails (OrderID INT(11), ProductID INT(11), UnitPrice DECIMAL(10,4), Quantity SMALLINT(2), Discount DOUBLE(8,0),
			   PRIMARY KEY(OrderID, ProductID),
			   FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
			   FOREIGN KEY (ProductID) REFERENCES Products(ProductID));

-- Populating data into 'orderdetails' table
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Northwind_database_csv/order-details.csv'
INTO TABLE orderdetails
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;