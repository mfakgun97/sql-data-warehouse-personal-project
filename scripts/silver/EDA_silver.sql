SELECT cst_id, COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 and cst_id IS NULL;

-- we will see if there are any duplicates in primary key and if there is we will keep the latest added one 
----------------------------------------------------------------------------------

SELECT *
FROM bronze.crm_cust_info
WHERE cst_id = 29466; 
--this one had 3 so we have to pick only one

-- so will rank these records by date and pick the firt one!
-- we will use window functions
----------------------------------------------------------------------------------

SELECT * , ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
FROM bronze.crm_cust_info
WHERE cst_id = 29466; 

-- what this will do rank these records from latest to earliest

----------------------------------------------------------------------------------

SELECT * FROM(
  SELECT * , ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
  FROM bronze.crm_cust_info
  ) t WHERE flag_last =! 1;

--this query will show all the other dublicates 

----------------------------------------------------------------------------------

SELECT * FROM(
  SELECT * , ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
  FROM bronze.crm_cust_info
  ) t WHERE flag_last = 1 AND cst_id=29466 ;
