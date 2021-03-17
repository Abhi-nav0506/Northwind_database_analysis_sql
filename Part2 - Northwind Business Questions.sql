USE northwind;


-- 1. Product list (name, unit price) of ten most expensive products:

SELECT ProductName, UnitPrice FROM products ORDER BY UnitPrice DESC LIMIT 10;



-- 2. Number of units in stock by Category(Category Name) and supplier country :

SELECT SUM(UnitsInStock) AS UnitsInStock, CategoryName, Country AS SupplierCountry   
FROM products
INNER JOIN categories ON products.CategoryID = categories.CategoryID
INNER JOIN suppliers ON products.SupplierID = suppliers.SupplierID
GROUP BY CategoryName, SupplierCountry;



-- 3. Quartely orders for each product for the year 1997 :

SELECT ProductName, COUNT(ProductName) AS TotalOrders, QuarterNo, YEAR(OrderDate) AS 'Year' FROM
(SELECT orders.OrderID, OrderDate, QUARTER(OrderDate) AS QuarterNo, orderdetails.ProductID, ProductName, Quantity 
FROM products
LEFT JOIN orderdetails ON products.ProductID = orderdetails.ProductID
INNER JOIN orders ON orderdetails.OrderID = orders.OrderID
WHERE OrderDate BETWEEN CONVERT('1997-01-01',DATETIME) and CONVERT('1997-12-31',DATETIME)) AS product_97
GROUP BY ProductID, QuarterNo
ORDER BY QuarterNo, ProductID;



-- 4. The name of employees and the city where they live, for employees who have sold to customers in the same city :

SELECT DISTINCT(EmployeeName), EmployeeCITY FROM
(SELECT OrderID,orders.EmployeeID, CONCAT(FirstName,' ',Lastname) AS EmployeeName, employees.City AS EmployeeCITY,  orders.CustomerID, CompanyName, customers.City AS CustomerCITY  
FROM Orders
INNER JOIN customers ON orders.customerID = customers.customerID
INNER JOIN employees ON orders.EmployeeID = employees.EmployeeID) AS employee_cust
WHERE EmployeeCITY = CustomerCITY;



-- 5. The names of employees who are strictly older than any employee who lives in London:

SELECT CONCAT(FirstName,' ',Lastname) AS EmployeeName
FROM employees
WHERE BirthDate < (
    SELECT max(BirthDate) FROM employees
    WHERE City='London'
);