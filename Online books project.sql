--create book tble
--Create books Tables

DROP TABLE IF EXISTS book CASCADE;
;

CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Book_Name VARCHAR(255),
    Author VARCHAR(255),
    Genre VARCHAR(100),
    Year INT,
    Price NUMERIC(10,2),
    Stock INT
);



select *from books;


--Create customers table

create table customer2(
     customer_ID SERIAL PRIMARY KEY,
	 name VARCHAR(100),
	 email VARCHAR(100),
	 Phone VARCHAR(15),
	 City VARCHAR(50),
	 country VARCHAR(150)
);


DELETE FROM Customer
WHERE Customer_ID = 2;

INSERT INTO Customer2 (Customer_ID, name, email)
VALUES (84, 'Test User', 'test@gmail.com');

--Create order tables

create table Order1(
     Order_ID SERIAL PRIMARY KEY,
	 Customer_ID INT REFERENCES Customer(Customer_ID),
	 Book_ID INT REFERENCES Books(Book_ID),
	 Order_date DATE,
	 Quantity INT,
	 Total_Amount NUMERIC(10,2)
);


SELECT customer_id FROM Customer;
SELECT book_id FROM Books;





select*from book;
select*from customer2;
select*from Order1;


---Import data into books table

COPY books
FROM 'C:/Books.csv' 
DELIMITER ',' 
CSV HEADER;


select * from books;




---Import data into customers table
copy Customer2
FROM 'C:/Customers.csv' 
DELIMITER ',' 
CSV HEADER;


select * from customer2;



---Import data into Order table

copy Order1
FROM 'C:/Orders.csv'
DELIMITER ','
CSV HEADER;

select * from Order1;






--BASIC QUENSTION:




--1) Retrieve all books in the "Fiction" genre:

select * from books
where Genre='Fiction';


--2) Find books published after the year 1950:

select * from books
where Published_year > 1950;


--3) List all customers from the Canada:

select * from customer2
where country='Canada';


--4) Show orders placed in november 2023;

select * from Order1
where order_date BETWEEN '2023-11-01' AND '2023-11-30';


--5) Retrieve the total stock of books available:

select SUM(stock) AS Total_Stock
from books;

--6)Find thedetails of the most expensive book:

select * from books order by Price DESC LIMIT 1;


--7) Show all customers who ordered more than 1 quantity of a book:
select * from Order1
where quantity>1;


--8) Retrieve all orders where the total amount exceed $20:
select * from Order1
where total_amount>20;

--9)List all genre available in the the table:

select DISTINCT genre from books;



--10) Find the books with the lowest stock:
select * from books order by stock LIMIT 1;

--11) Calculate the total revenue generated from all orders:

select SUM(total_amount) as revenue
from orders;





--ADVANCE QUESTION:

--1) Retrieve the totals number of books sold for each genre:

select* from Order1;


select b.genre, sum(o.Quantity) AS total_books_sold
from orders o
join books b on o.book_id=b.book_id
group by b.genre;


--2) Find the average price of books in the "Fantasy" genre:

select AVG(price) AS Average_price
from books
where genre= 'Fantasy';


-- 3)List customers who have places at least 2 orders:

select o.customer_id, c.name, count(Order_id) AS ORDER_COUNT
from orders o
join  customer c ON o.customer_id=c.customer_id
group by o.customer_id, c.name
having count(Order_id) >=2;  ---HAVING: Groups को filter करता है, मतलब aggregation (जैसे COUNT) बनने के बाद condition check करता है।



-- 4) Find the most frequently ordered book:

select o.book_id, b.book_name, count(o.order_id) AS ORDER_COUNT
from order1 o
join books b on o.book_id=b.book_id
group by o.book_id, b.book_name
order by order_count DESC LIMIT 1;


-- 5) Show the top 3 most expensive books of 'Fantasy' genre:

select * from books
where genre ='Fantasy'
ORDER BY price DESC LIMIT 3;



-- 7) Retrieve the total quantity of books sold by each author:

select b.author, sum(o.quantity) AS Total_books_sold
from ORDER1 o
JOIN books b ON o.book_id=b.book_id
group by b.author;


-- 8) List the cities where customers who spent over $30 are located:
select distinct c.city, total_amount
from order1 o
join customer c on o.customer_id=c.customer_id
where o.total_amount>30;


-- 9) Find the customers who spent the most on orders:
select c.customer_id, c.name, SUM(total_amount) AS Total_spent
from order1 o
join customer c on o.customer_id=c.customer_id
group by c.customer_id, c.name
order by total_spent desc limit 1 ;



-- 10) Calculate the stock remaining after fulfilling all orders:

select b.book_id, b.book_name, b.stock, coalesce(sum(quantity),0) AS Order_quantity,
 b.stock - COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
from books b
left join orders o on b.book_id=o.book_id
group by b.book_id order by b.book_id;                       
