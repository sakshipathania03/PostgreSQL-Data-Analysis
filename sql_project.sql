CREATE TABLE Books(
book_id SERIAL PRIMARY KEY,
title VARCHAR(100),
author VARCHAR(100),
genre VARCHAR(50),
published_year INT,
price NUMERIC(10,2),
stock INT
);
CREATE TABLE Customers(
customer_id SERIAL PRIMARY KEY,
name VARCHAR(100),
email VARCHAR(100),
phone VARCHAR(50),
city VARCHAR(50),
country VARCHAR(150)
);
CREATE TABLE Orders(
order_id SERIAL PRIMARY KEY,
customer_id INT REFERENCES Customers(customer_id),
book_id INT REFERENCES Books(book_id),
order_date DATE,
quantity INT,
total_amount NUMERIC(10,2)
);
SELECT*FROM Books;
SELECT*FROM Customers;
SELECT*FROM Orders;
--retrieve all books in a 'Fiction' genre
SELECT*FROM Books
WHERE genre='Fiction';
--find books published after 1950
SELECT*FROM Books
WHERE published_year>1950;
--list all the customers from Canada
SELECT*FROM Customers
WHERE country='Canada';
--show orders palced in november 2023
SELECT*FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';
--retrieve the total stock of books available
SELECT SUM(stock) AS total_stock
FROM Books;
--find the details of the most expensive book
SELECT *
FROM Books
ORDER BY price DESC
LIMIT 1;
--show all customers who ordered more than 1 quantity of books
SELECT*FROM Orders
WHERE quantity>1;
--retrieve all orders where total amount exceeds 20
SELECT*FROM Orders
WHERE total_amount>20;
--list all the genres available in the book table
SELECT DISTINCT genre
FROM Books;
--Find the books with lowest stock
SELECT*FROM Books
ORDER BY stock 
LIMIT 1;
--calculate the total revenue generated from all orders
SELECT SUM(total_amount)
AS revenue
FROM orders;
--Retrive the total number of books sold for each genre
SELECT b.genre,SUM(o.quantity) AS total_books_sold
FROM Orders o
JOIN Books b ON o.book_id=b.book_id
GROUP BY b.genre;
--Fint average price of books in 'Fantasy' genre
SELECT AVG(price) AS average_price
FROM Books
WHERE genre='Fantasy';
--List customers who have placed atleast 2 orders
SELECT customer_id,COUNT(order_id) AS order_count
FROM Orders
GROUP BY customer_id
HAVING COUNT(order_id)>=2;
--Find most frequently ordered book
SELECT book_id,COUNT(order_id) AS order_count
FROM orders
GROUP BY book_id
ORDER BY order_count DESC
LIMIT 1;
--Show the top 3 most expensive books of 'Fantasy' genre 
SELECT* FROM Books
WHERE genre='Fantasy'
ORDER BY price DESC
LIMIT 3;
--Retrieve the total quantity of books sold by each author
SELECT b.author,SUM(o.quantity) AS total_books_sold
FROM orders o JOIN Books b
ON o.book_id=b.book_id
GROUP BY b.author;
--List the cities where customers who spent over $30 are located
SELECT DISTINCT c.city,o.total_amount
FROM Orders o JOIN Customers c
ON o.customer_id=c.customer_id
WHERE o.total_amount>30 ;
--Find the customers who spent most om orders
SELECT c.customer_id,c.name,SUM(total_amount) AS total_spent
FROM Orders o
JOIN Customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id,c.name
ORDER BY total_spent DESC;
--Calculate the stock remaining after fulfilling all orders
SELECT b.book_id,b.title,b.stock,COALESCE(SUM(o.quantity),0) AS order_quantity,b.stock-COALESCE(SUM(o.quantity),0) AS remaining_quantity
FROM Books b
LEFT JOIN Orders o ON b.book_id=o.book_id
GROUP BY b.book_id
ORDER BY b.book_id;
