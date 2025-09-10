-- 1. Create Database
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- 2. Create Tables

-- Customers Table
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    address VARCHAR(150),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    join_date DATE
);

-- Categories Table
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50)
);

-- Products Table
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    price DECIMAL(10,2),
    stock INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- Orders Table
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status ENUM('Pending','Shipped','Delivered','Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Order Details Table (Many-to-Many: Orders ↔ Products)
CREATE TABLE OrderDetails (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Payments Table
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    amount DECIMAL(10,2),
    payment_date DATE,
    payment_method ENUM('Credit Card','Debit Card','UPI','Net Banking','Cash'),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- 3. Insert Sample Data

-- Customers
INSERT INTO Customers (first_name, last_name, email, phone, address, city, state, country, join_date) VALUES
('John','Doe','john.doe@email.com','9876543210','123 Main St','Delhi','Delhi','India','2022-01-15'),
('Sarah','Sharma','sarah.sharma@email.com','9123456789','456 Park Ave','Mumbai','Maharashtra','India','2021-12-20'),
('Amit','Patel','amit.patel@email.com','9988776655','789 Hill Rd','Ahmedabad','Gujarat','India','2023-02-10');

-- Categories
INSERT INTO Categories (category_name) VALUES
('Electronics'),('Clothing'),('Books'),('Home & Kitchen');

-- Products
INSERT INTO Products (product_name, category_id, price, stock) VALUES
('Smartphone', 1, 15000.00, 50),
('Laptop', 1, 55000.00, 20),
('T-Shirt', 2, 800.00, 100),
('Novel', 3, 500.00, 200),
('Mixer Grinder', 4, 3000.00, 30);

-- Orders
INSERT INTO Orders (customer_id, order_date, status) VALUES
(1, '2023-03-01', 'Delivered'),
(2, '2023-03-05', 'Shipped'),
(3, '2023-03-06', 'Pending');

-- Order Details
INSERT INTO OrderDetails (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 15000.00),
(1, 3, 2, 1600.00),
(2, 2, 1, 55000.00),
(2, 4, 3, 1500.00),
(3, 5, 1, 3000.00);

-- Payments
INSERT INTO Payments (order_id, amount, payment_date, payment_method) VALUES
(1, 16600.00, '2023-03-01', 'Credit Card'),
(2, 56500.00, '2023-03-05', 'UPI');

-- 4. Example Queries

-- Total Revenue
SELECT SUM(amount) AS total_revenue FROM Payments;

-- Best Selling Product
SELECT p.product_name, SUM(od.quantity) AS total_sold
FROM OrderDetails od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.product_id
ORDER BY total_sold DESC
LIMIT 1;

-- Orders per Customer
SELECT c.first_name, c.last_name, COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- Revenue by Category
SELECT cat.category_name, SUM(od.price * od.quantity) AS revenue
FROM OrderDetails od
JOIN Products p ON od.product_id = p.product_id
JOIN Categories cat ON p.category_id = cat.category_id
GROUP BY cat.category_id
ORDER BY revenue DESC;

-- Customers with Pending Orders
SELECT c.first_name, c.last_name, o.order_id, o.status
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.status = 'Pending';
