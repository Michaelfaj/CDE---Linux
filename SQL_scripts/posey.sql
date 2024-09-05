use posey;

/* Find a list of order IDs where either gloss_qty or poster_qty is greater than 4000. 
Only include the id field in the resulting table */
SELECT id 
FROM orders
WHERE gloss_qty	> 40 OR poster_qty > 40;


/* Write a query that returns a list of orders where the standard_qty is 
zero and either the gloss_qty or poster_qty is over 1000. */

SELECT id 
FROM orders 
WHERE standard_qty < 0 AND (gloss_qty > 100 OR poster_qty > 100);


/*  Find all the company names that start with a 'C' or 'W', 
and where the primary contact contains 'ana' or 'Ana', but does not contain 'eana'. */

SELECT name
FROM accounts
WHERE (name like "C%" OR name like "W%") AND primary_poc like "%Ana%" OR primary_poc like "%ana%"
	  AND primary_poc NOT like "%eana%";
      
/* Provide a table that shows the region for each sales rep along with their associated accounts. 
Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) by account name. */

SELECT s.name salesrep_name, r.name region, a.name account_name 
FROM sales_reps s
JOIN region r ON s.region_id = r.id
JOIN accounts a ON a.sales_rep_id = s.id;





