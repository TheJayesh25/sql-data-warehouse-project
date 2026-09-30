/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'silver.crm_cust_info'
-- ====================================================================

-- CHECK FOR Duplicates or Missing Values In Primary key
-- Expectation: No Results
SELECT cst_id, COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- CHECK FOR UNWANTED Spaces in string variables 
-- Expectation: No Results
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Check for DATA Standardization & Consistency in Low Cardinality Columns
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

SELECT cst_gndr, COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_gndr;

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;

SELECT cst_marital_status, COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_marital_status;

-- SELECT * FROM silver.crm_cust_info;


-- ====================================================================
-- Checking 'silver.crm_prd_info'
-- ====================================================================

-- CHECK FOR Duplicates or Missing Values in the Primary Key
-- Expectation: No Results
SELECT prd_id, COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- CHECK FOR UNWANTED Spaces in string variables
-- Expectation: No Results
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- CHECK FOR Nulls OR Negative numbers
-- Expectation: No Results

SELECT * 
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- DATA Standardization & Consistency in Low Cardinality Columns
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

SELECT prd_line, COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_line;

-- CHECK FOR Invalid Date Orders
-- Expectation: No Results
SELECT *
FROM silver.crm_prd_info
WHERE prd_start_dt>prd_end_dt;

SELECT COUNT(*)
FROM silver.crm_prd_info
WHERE prd_start_dt>prd_end_dt;

-- SELECT * FROM silver.crm_prd_info;


-- ====================================================================
-- Checking 'silver.crm_sales_details'
-- ====================================================================

-- CHECK FOR Duplicates or Missing Values in Primary Key, compare columns with corresponding primary key cols of silver.crm_cust_info and silver.crm_prd_info
-- Expectation: No Results
SELECT sls_ord_num, COUNT(sls_ord_num)
FROM silver.crm_sales_details
GROUP BY sls_ord_num
HAVING COUNT(sls_ord_num) > 1 OR sls_ord_num IS NULL;

SELECT *
FROM silver.crm_sales_details
WHERE sls_prd_key NOT IN (
	SELECT prd_key 
	FROM silver.crm_prd_info
)
  
SELECT *
FROM silver.crm_sales_details
WHERE sls_cust_id IN (
	SELECT cst_id
	FROM silver.crm_cust_info
)

-- CHECK FOR UNWANTED Spaces in string variables
-- Expectation: No Results
SELECT sls_ord_num
FROM silver.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);

SELECT COUNT(*)
FROM silver.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);

SELECT sls_prd_key
FROM silver.crm_sales_details
WHERE sls_prd_key != TRIM(sls_prd_key);

SELECT COUNT(*)
FROM silver.crm_sales_details
WHERE sls_prd_key != TRIM(sls_prd_key);

-- SELECT TOP 1 * FROM bronze.crm_prd_info;

-- CHECK FOR Nulls OR Negative numbers
-- Expectation: No Results

SELECT sls_sales, sls_quantity, sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity*sls_price 
	OR sls_sales < 0 OR sls_sales IS NULL
	OR sls_quantity < 0 OR sls_quantity IS NULL
	OR sls_price < 0 OR sls_price IS NULL;

-- CHECK FOR Date related inconsistencies
SELECT * FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
	OR sls_ship_dt > sls_due_dt
	OR sls_order_dt > sls_due_dt;

-- SELECT * FROM silver.crm_sales_details;


-- ====================================================================
-- Checking 'silver.erp_cust_az12'
-- ====================================================================

-- CHECK FOR Duplicates or Missing Values in Primay key
-- Expectation: No Results
SELECT cid, COUNT(*)
FROM silver.erp_cust_az12
GROUP BY cid
HAVING COUNT(*)>1;

-- CHECK FOR Differences in Primay key (cid) of this table and of silver.crm_cust_info (cst_id)
-- Expectation: Finding out required transformations to make the two keys such that they can be used to join the tables

SELECT top 10 cst_id
FROM silver.crm_cust_info;

SELECT top 10 cid
FROM silver.erp_cust_az12;

SELECT *
FROM silver.erp_cust_az12
WHERE cid LIKE 'NAS%'

SELECT *
FROM silver.erp_cust_az12
WHERE cid LIKE '%AW%'

-- CHECK FOR UNWANTED Spaces in string variables
-- Expectation: No Results

-- SELECT cid
-- FROM silver.erp_cust_az12
-- WHERE cid != TRIM(cid);

-- DATA Standardization & Consistency in Low Cardinality Columns
SELECT DISTINCT gen
FROM silver.erp_cust_az12;

SELECT gen, COUNT(*)
FROM silver.erp_cust_az12
GROUP BY gen;

-- Date Related checking to identify out of range dates
-- SELECT *, DATEDIFF(year, bdate, CAST(GETDATE() AS DATE)) AS age
SELECT COUNT(*)
FROM silver.erp_cust_az12
WHERE DATEDIFF(year, bdate, CAST(GETDATE() AS DATE)) > 0;


-- ====================================================================
-- Checking 'silver.erp_loc_a101'
-- ====================================================================

-- CHECK FOR Duplicates or Missing Values in Primary Key
-- Expectation: No Results
SELECT cid, COUNT(*)
FROM silver.erp_loc_a101
GROUP BY cid
HAVING COUNT(*)>1;

-- CHECK FOR Differences in Primay key (cid) of this table and of silver.crm_cust_info (cst_id)
-- Expectation: Finding out required transformations to make the two keys such that they can be used to join the tables

SELECT top 10 cst_key
FROM silver.crm_cust_info;

SELECT top 10 cid
FROM silver.erp_loc_a101;

SELECT *
FROM silver.erp_loc_a101
WHERE cid NOT LIKE 'AW%'

-- CHECK FOR UNWANTED Spaces in string variables
-- Expectation: No Results
SELECT cid
FROM silver.erp_loc_a101
WHERE cid != TRIM(cid);

-- DATA Standardization & Consistency in Low Cardinality Columns
SELECT DISTINCT TRIM(cntry)
FROM silver.erp_loc_a101;

SELECT TRIM(cntry), COUNT(*)
FROM silver.erp_loc_a101
GROUP BY cntry;

-- SELECT * FROM FROM silver.erp_loc_a101;


-- ====================================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- ====================================================================

-- CHECK FOR Duplicates or Missing Values
-- Expectation: No Results
SELECT id, COUNT(*)
FROM silver.erp_px_cat_g1v2
GROUP BY id
HAVING COUNT(*)>1;

-- CHECK FOR Differences in Primay key (id) of this table and of silver.crm_prd_info (cat_id)
-- Expectation: Finding out required transformations to make the two keys such that they can be used to join the tables
SELECT top 10 cat_id
FROM silver.crm_prd_info;

SELECT top 10 id
FROM silver.erp_px_cat_g1v2;

SELECT id
FROM silver.erp_px_cat_g1v2
WHERE id NOT IN (
	SELECT cat_id
	FROM silver.crm_prd_info
);

-- CHECK FOR UNWANTED Spaces in string variables
-- Expectation: No Results
SELECT id
FROM silver.erp_px_cat_g1v2
WHERE id != TRIM(id);

SELECT cat
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat);

SELECT subcat
FROM silver.erp_px_cat_g1v2
WHERE subcat != TRIM(subcat);

SELECT maintenance
FROM silver.erp_px_cat_g1v2
WHERE maintenance != TRIM(maintenance);

-- DATA Standardization & Consistency in Low Cardinality Columns
SELECT DISTINCT cat
FROM silver.erp_px_cat_g1v2;

SELECT cat, COUNT(*)
FROM silver.erp_px_cat_g1v2
GROUP BY cat;

SELECT DISTINCT subcat
FROM silver.erp_px_cat_g1v2;

SELECT subcat, COUNT(*)
FROM silver.erp_px_cat_g1v2
GROUP BY subcat;

SELECT DISTINCT maintenance
FROM silver.erp_px_cat_g1v2;

SELECT maintenance, COUNT(*)
FROM silver.erp_px_cat_g1v2
GROUP BY maintenance;

-- SELECT * FROM FROM silver.erp_px_cat_g1v2;
