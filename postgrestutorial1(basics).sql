-- LIMIT

-- Try using LIMIT yourself below by writing a query that displays all the data in the occurred_at, account_id, and channel columns of the web_events table, and limits the output to only the first 15
-- rows.
SELECT occurred_at, account_id, channel 
FROM web_events 
LIMIT 15;

-------------------------------------------------------------------------------
-- ORDER BY

-- Write a query to return the 10 earliest orders in the orders table. Include the id, occurred_at, and total_amt_usd.
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;
-- The ORDER BY statement always comes in a query after the SELECT and FROM statements, but before the LIMIT statement. If you are using the LIMIT statement, it will always appear last. As you learn
-- additional commands, the order of these statements will matter more.

-- Write a query to return the top 5 orders in terms of largest total_amt_usd. Include the id, account_id, and total_amt_usd.
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 5;

-- Write a query to return the lowest 20 orders in terms of smallest total_amt_usd. Include the id, account_id, and total_amt_usd.
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 20;

-- Write a query that displays the order ID, account ID, and total dollar amount for all the orders, sorted first by the account ID (in ascending order), and then by the total dollar amount
-- (in descending order).
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id ASC, total_amt_usd DESC;

-- Now write a query that again displays order ID, account ID, and total dollar amount for each order, but this time sorted first by total dollar amount (in descending order), and then by account ID
-- (in ascending order).
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id ASC;

------------------------------------------------------------------------------------
-- WHERE
/*Using the WHERE statement, we can display subsets of tables based on conditions that must be met. You can also think of the WHERE command as filtering the data.

This video above shows how this can be used, and in the upcoming concepts, you will learn some common operators that are useful with the WHERE' statement.

Common symbols used in WHERE statements include:

> (greater than)

< (less than)

>= (greater than or equal to)

<= (less than or equal to)

= (equal to)

!= (not equal to)
*/
-----------------------------------------------------------------------------------
-- Pull the first 5 rows and all columns from the orders table that have a dollar amount of gloss_amt_usd greater than or equal to 1000.
SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000;

-- Pull the first 10 rows and all columns from the orders table that have a total_amt_usd less than 500.
SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;

/*
--WHERE WITH NON-NUMERIC
The WHERE statement can also be used with non-numeric data. We can use the = and != operators here. You need to be sure to use single quotes (just be careful if you have quotes in the original text)
with the text data, not double quotes.

Commonly when we are using WHERE with non-numeric data fields, we use the LIKE, NOT, or IN operators.
 
*/
-- Filter the accounts table to include the company name, website, and the primary point of contact (primary_poc) just for the Exxon Mobil company in the accounts table.
SELECT name, website, primary_poc
FROM accounts
WHERE name='Exxon Mobil';

-----------------------------------------------------------------------------
-- ARITHMETIC OPERATORS
/*
Creating a new column that is a combination of existing columns is known as a derived column (or "calculated" or "computed" column). Usually you want to give a name, or "alias," to your new column 
using the AS keyword.

This derived column, and its alias, are generally only temporary, existing just for the duration of your query. The next time you run a query and access this table, the new column will not be there.

If you are deriving the new column from existing columns using a mathematical expression, then these familiar mathematical operators will be useful:

* (Multiplication)
+ (Addition)
- (Subtraction)
/ (Division)
*/
-- Using orders table Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order. Limit the results to the first 10 orders, and 
-- include the id and account_id fields.
SELECT id, account_id, standard_amt_usd/standard_qty AS price
FROM orders
LIMIT 10;

-- Write a query that finds the percentage of revenue that comes from poster paper for each order. You will need to use only the columns that end with _usd. (Try to do this without using the total
-- column) Display the id and account_id fields also.
SELECT id, account_id, (poster_amt_usd/total_amt_usd)*100 AS poster_revenue_percentage
FROM orders
LIMIT 10;

SELECT id, account_id, 
   poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd) AS post_per
FROM orders
LIMIT 10;

---------------------------------------------------------------------------------
-- LOGICAL OPERATORS
/*
1. LIKE -This allows you to perform operations similar to using WHERE and =, but for cases when you might not know exactly what you are looking for.
2. IN -This allows you to perform operations similar to using WHERE and =, but for more than one condition.
3. NOT -This is used with IN and LIKE to select all of the rows NOT LIKE or NOT IN a certain condition.
4. AND & BETWEEN -These allow you to combine operations where all combined conditions must be true.
5. OR -This allows you to combine operations where at least one of the combined conditions must be true.
*/

/*
LIKE OPERATOR
The LIKE operator is extremely useful for working with text. You will use LIKE within a WHERE clause. The LIKE operator is frequently used with %. The % tells us that we might want any number of
characters leading up to a particular set of characters or following a certain set of characters, as we saw with the google syntax above. Remember you will need to use single quotes for the text you
pass to the LIKE operator, because of this lower and uppercase letters are not the same within the string. Searching for 'T' is not the same as searching for 't'. In other SQL environments (outside
the classroom), you can use either single or double quotes.
*/

-- Use the accounts table to find all the companies whose names start with 'C'.
SELECT name
FROM accounts
WHERE name LIKE 'C%';

-- Use the accounts table to find all companies whose names contain the string 'one' somewhere in the name.
SELECT name
FROM accounts
WHERE name LIKE '%one%';

-- Use the accounts table to find all companies whose names end with 's'.
SELECT name
FROM accounts
WHERE name LIKE '%s';

/*
IN OPERATOR
The IN operator is useful for working with both numeric and text columns. This operator allows you to use an =, but for more than one item of that particular column. 
We can check one, two or many column values for which we want to pull data, but all within the same query. 
The OR operator that also allows us to perform these tasks, but the IN operator is a cleaner way to write these queries.
*/

-- Use the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

-- Use the web_events table to find all information regarding individuals who were contacted via the channel of organic or adwords.
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');

/*
NOT OPERATOR
The NOT operator is an extremely useful operator for working with the previous two operators we introduced: IN and LIKE. 
By specifying NOT LIKE or NOT IN, we can grab all of the rows that do not meet a particular criteria.
*/

-- Use the accounts table to find the account name, primary poc, and sales rep id for all stores except Walmart, Target, and Nordstrom.
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

-- Use the web_events table to find all information regarding individuals who were contacted via any method except using organic or adwords methods.
SELECT *
FROM web_events
WHERE channel NOT IN ('organic', 'adwords');

-- Use accounts table to find all the companies whose names do not start with 'C'.
SELECT *
FROM accounts
WHERE name NOT LIKE 'C%';

-- Use accounts table to find all companies whose names do not contain the string 'one' somewhere in the name.
SELECT *
FROM accounts
WHERE name NOT LIKE '%one%';

-- Use accounts table to find all companies whose names do not end with 's'.
SELECT *
FROM accounts
WHERE name NOT LIKE '%s';

/*
AND OPERATOR
The AND operator is used within a WHERE statement to consider more than one logical clause at a time. Each time you link a new statement with an AND, you will need to specify the column you are
interested in looking at. You may link as many statements as you would like to consider at the same time. 
This operator works with all of the operations we have seen so far including arithmetic operators (+, *, -, /).
LIKE, IN, and NOT logic can also be linked together using the AND operator.

BETWEEN OPERATOR
Sometimes we can make a cleaner statement using BETWEEN than we can using AND. Particularly this is true when we are using the same column for different parts of our AND statement.
*/

-- Write a query that returns all the orders where the standard_qty is over 1000, the poster_qty is 0, and the gloss_qty is 0
SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

-- Using the accounts table, find all the companies whose names do not start with 'C' and end with 's'.
SELECT *
FROM accounts
WHERE name NOT LIKE 'C%' AND name NOT LIKE '%s';

-- When you use the BETWEEN operator in SQL, do the results include the values of your endpoints, or not? Figure out the answer to this important question by writing a query that displays the order
-- date and gloss_qty data for all orders where gloss_qty is between 24 and 29.
SELECT occurred_at, gloss_qty 
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29;

-- Use the web_events table to find all information regarding individuals who were contacted via the organic or adwords channels, and started their account at any point in 2016, sorted from newest to
-- oldest.
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND EXTRACT(YEAR FROM occurred_at)='2016'
ORDER BY occurred_at DESC;

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;

/*
OR OPERATOR
Similar to the AND operator, the OR operator can combine multiple statements. Each time you link a new statement with an OR, you will need to specify the column you are interested in looking at. You
may link as many statements as you would like to consider at the same time. This operator works with all of the operations we have seen so far including arithmetic operators (+, *, -, /), LIKE, IN,
NOT, AND, and BETWEEN logic can all be linked together using the OR operator.

When combining multiple of these operations, we frequently might need to use parentheses to assure that logic we want to perform is being executed correctly. 
*/

-- Find list of orders ids where either gloss_qty or poster_qty is greater than 4000. Only include the id field in the resulting table.
SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;

-- Write a query that returns a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000.
SELECT *
FROM orders
WHERE standard_qty = 0 AND (poster_qty > 1000 OR gloss_qty>1000);

-- Find all the company names that start with a 'C' or 'W', and the primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'.
SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE'W%') AND (primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') AND primary_poc NOT LIKE '%eana%'; 
