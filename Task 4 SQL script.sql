SHOW DATABASES
USE classicmodels
SHOW TABLES 
SELECT*FROM customers
LIMIT 5
SELECT*FROM orders
LIMIT 5

#total order
SELECT COUNT(*) FROM orders
SELECT customerNumber, COUNT(*) AS total_orders
FROM orders
GROUP BY customerNumber
ORDER BY total_orders DESC
LIMIT 10

#total revenue
SELECT productCode, SUM(quantityOrdered*priceEach) AS total_revenue
FROM orderdetails
GROUP BY productCode
ORDER BY total_revenue DESC
LIMIT 10

#top 5 customers by total exp
SELECT c.customerName, SUM(od.quantityOrdered*od.priceEach) as total_exp
FROM customers c
Join orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY c.customerName
ORDER BY total_exp DESC
LIMIT 10

#customers spending above average
SELECT customerName
FROM customers
WHERE customerNumber IN (
  SELECT customerNumber
  FROM orders o
  JOIN orderdetails od ON o.orderNumber = od.orderNumber
  GROUP BY customerNumber
  HAVING SUM(od.quantityOrdered*od.priceEach)>
           (SELECT AVG(total) FROM(
                SELECT SUM(quantityOrdered*priceEach) AS total
                FROM orders o2
                JOIN orderdetails od2 ON o2.orderNumber = od2.orderNumber
                GROUP BY o2.customerNumber
                ) AS customer_totals)
)
LIMIT 10

#top products
CREATE VIEW top_product AS
SELECT productCode, SUM(quantityOrdered) AS total_sold
FROM orderdetails
GROUP BY productCode
HAVING total_sold>1000

SELECT*FROM top_product
LIMIT 10

SELECT p.productName, tp.total_sold
FROM top_product tp
JOIN products p ON tp.productCOde = p.productCode
ORDER BY total_Sold DESC
LIMIT 10