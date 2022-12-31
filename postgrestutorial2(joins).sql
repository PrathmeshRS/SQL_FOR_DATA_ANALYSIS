-- 1. Try pulling all the data from the accounts table, and all the data from the orders table.
SELECT accounts.*, orders.*
FROM accounts
JOIN orders
ON orders.account_id=accounts.id
LIMIT 20;
-- Notice this result is the same as if you switched the tables in the FROM and JOIN. Additionally, which side of the = a column is listed doesn't matter.

/*
 The SELECT clause indicates which column(s) of data you'd like to see in the output (For Example, orders.* gives us all the columns in orders table in the output). The FROM clause indicates the
 first table from which we're pulling data, and the JOIN indicates the second table. 
 The ON clause specifies the column on which you'd like to merge the two tables together.
The ON statement holds the two columns that get linked across the two tables. This will be the focus in the next concepts.
*/

-- 2. Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.
SELECT orders.standard_qty, orders.gloss_qty, 
       orders.poster_qty,  accounts.website, 
       accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id

-- Query all the information from all the tables
SELECT accounts.*, orders.*, region.*, sales_reps.*, web_events.*
FROM accounts
JOIN orders
ON orders.account_id=accounts.id
JOIN sales_reps
ON accounts.sales_rep_id=sales_reps.id
JOIN region
ON sales_reps.region_id=region.id
JOIN web_events
ON web_events.account_id=accounts.id
LIMIT 20;

/*
PRIMARY KEY: A primary key is a unique column in a particular table. This is the first column in each of our tables. Here, those columns are all called id, but that doesn't necessarily have to be the
              name.
              It is common that the primary key is the first column in our tables in most databases.

FOREIGN KEY: A foreign key is a column in one table that is a primary key in a different table.

*/
-----------------------------------------------------------
-------------------JOIN WITH ALIAS-------------------------
/*
When we JOIN tables together, it is nice to give each table an alias. Frequently an alias is just the first letter of the table name.

FROM tablename AS t1
JOIN tablename2 AS t2

*/

/*
Aliases for Columns in Resulting Table

While aliasing tables is the most common use case. It can also be used to alias the columns selected to have the resulting table reflect a more readable name.

Select t1.column1 aliasname, t2.column2 aliasname2
FROM tablename AS t1
JOIN tablename2 AS t2

*/

-- Provide a table for all web_events associated with account name of Walmart. There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event.
-- Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.
SELECT a.primary_poc, w.occurred_at, w.channel
FROM accounts AS a
JOIN web_events AS w
ON a.id = w.account_id
WHERE a.name='Walmart';

-- Provide a table that provides the region for each sales_rep along with their associated accounts. Your final table should include three columns: the region name, the sales rep name, and the
-- account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name AS region, s.name sales_representive, a.name AS account
FROM accounts AS a
JOIN sales_reps AS s
ON a.sales_rep_id = s.id
JOIN region AS r
ON s.region_id = r.id
ORDER BY a.name;
/*
We can alias a colomun with/without 'AS' keyword. If column names are same in different tables
it's better to alias them in select clause otherwise they get mixed.
In the above example if you don't alias name columns of individual columns the result is just
one column.
*/

-- Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. Your final table should have 3 columns: region name,
-- account name, and unit price. A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.
SELECT r.name AS region, a.name AS account, o.total_amt_usd/(o.total+0.01) AS unit_price
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
JOIN sales_reps AS s
ON s.id = a.sales_rep_id
JOIN region as r
ON s.region_id = r.id;

/*
A LEFT JOIN and RIGHT JOIN do the same thing if we change the tables that are in the FROM and JOIN statements.

A LEFT JOIN will at least return all the rows that are in an INNER JOIN.

JOIN and INNER JOIN are the same.

A LEFT OUTER JOIN is the same as LEFT JOIN
*/

-- Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for the Midwest region. 
-- Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name region_name, s.name as sales_rep_name, a.name as account_name
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
WHERE r.name='Midwest'
ORDER BY a.name;
-- 48 results

-- Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a first name starting with S and in the
-- Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name region_name, s.name as sales_rep_name, a.name as account_name
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
WHERE r.name='Midwest' AND s.name LIKE 'S%'
ORDER BY a.name;
-- 5 results

-- Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a last name starting with K and in the Midwest
-- region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name region_name, s.name as sales_rep_name, a.name as account_name
FROM sales_reps s
LEFT JOIN accounts a
ON a.sales_rep_id = s.id
LEFT JOIN region r
ON s.region_id = r.id
WHERE r.name='Midwest' AND s.name LIKE '%K%' AND STRPOS(s.name, 'K')!=1
ORDER BY a.name;
-- 13 results

-- OR

SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY a.name;

-- Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the 
-- standard order quantity exceeds 100. Your final table should have 3 columns: region name, account name, and unit price. In order to avoid a division by zero error, adding .01 to the denominator
-- here is helpful total_amt_usd/(total+0.01).
LEFT JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps as s
ON s.id = a.sales_rep_id
JOIN region r
ON s.region_id = r.id
WHERE o.standard_qty > 100
ORDER BY a.name;
-- 4509 results

-- Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the
-- standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the smallest unit price
-- first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).
SELECT r.name region_name, a.name account_name,   o.total_amt_usd/(o.total+0.01) AS unit_price
FROM orders as o
LEFT JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps as s
ON s.id = a.sales_rep_id
JOIN region r
ON s.region_id = r.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price;
-- 835 results

-- Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the
-- standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the largest unit price 
-- first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).
SELECT r.name region_name, a.name account_name,   o.total_amt_usd/(o.total+0.01) AS unit_price
FROM orders as o
LEFT JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps as s
ON s.id = a.sales_rep_id
JOIN region r
ON s.region_id = r.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC;
-- 835 results

-- What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the different channels. You can try SELECT DISTINCT to narrow down the 
-- results to only the unique values.
SELECT DISTINCT a.name, w.channel
FROM accounts a
JOIN web_events w
ON a.id=w.account_id
WHERE a.id=1001;
-- 6 results

-- Find all the orders that occurred in 2015. Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.
SELECT o.occurred_at, a.name, o.total, o.total_amt_usd 
FROM orders o
JOIN accounts a
ON a.id=o.account_id
WHERE EXTRACT(YEAR FROM o.occurred_at) = '2015';
-- 1725 results

-- OR

SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM accounts a
JOIN orders o
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY o.occurred_at DESC;
