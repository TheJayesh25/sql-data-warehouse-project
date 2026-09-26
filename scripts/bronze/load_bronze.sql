/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @total_start_time DATETIME, @total_end_time DATETIME;
	BEGIN TRY
		SET @total_start_time = GETDATE();
		PRINT '===========================';
		PRINT 'Loading Bronze Layer';
		PRINT '===========================';

		PRINT '---------------------------';
		PRINT 'Loading CRM TABLES';
		PRINT '---------------------------';

		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		SET @start_time = GETDATE();
		PRINT '>> Inserting Table: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\jps25\OneDrive\Desktop\Documents\sql_dwh\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		SET @end_time = GETDATE();
		PRINT '';
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '';

		PRINT '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		SET @start_time = GETDATE();
		PRINT '>> Inserting Table: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\jps25\OneDrive\Desktop\Documents\sql_dwh\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		SET @end_time = GETDATE();
		PRINT '';
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '';

		PRINT '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		SET @start_time = GETDATE();
		PRINT '>> Inserting Table: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\jps25\OneDrive\Desktop\Documents\sql_dwh\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		SET @end_time = GETDATE();
		PRINT '';
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '';

		PRINT '---------------------------';
		PRINT 'Loading ERP TABLES';
		PRINT '---------------------------';

		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		SET @start_time = GETDATE();
		PRINT '>> Inserting Table: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\jps25\OneDrive\Desktop\Documents\sql_dwh\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		SET @end_time = GETDATE();
		PRINT '';
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '';

		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		SET @start_time = GETDATE();
		PRINT '>> Inserting Table: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\jps25\OneDrive\Desktop\Documents\sql_dwh\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		SET @end_time = GETDATE();
		PRINT '';
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '';

		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		SET @start_time = GETDATE();
		PRINT '>> Inserting Table: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\jps25\OneDrive\Desktop\Documents\sql_dwh\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		SET @end_time = GETDATE();
		PRINT '';
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '';
		SET @total_end_time = GETDATE();
		PRINT '==================================';
		PRINT 'Loading Bronze Layer is Completed';
		PRINT '>> Total Load Duration: ' + CAST(DATEDIFF(second, @total_start_time, @total_end_time) AS NVARCHAR) + ' seconds';
		PRINT '==================================';
	END TRY
	BEGIN CATCH
		PRINT '=============================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
		PRINT 'ERROR MESSAGE' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR MESSAGE' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT '=============================================';
	END CATCH
END



/* Test scripts to check and validate if data has been loaded correctly
SELECT *
FROM bronze.crm_cust_info;

SELECT COUNT(*)
FROM bronze.crm_cust_info;

SELECT *
FROM bronze.crm_prd_info;

SELECT COUNT(*)
FROM bronze.crm_prd_info;

SELECT *
FROM bronze.crm_sales_details;

SELECT COUNT(*)
FROM bronze.crm_sales_details;

SELECT *
FROM bronze.erp_cust_az12;

SELECT COUNT(*)
FROM bronze.erp_cust_az12;

SELECT *
FROM bronze.erp_loc_a101;

SELECT COUNT(*)
FROM bronze.erp_loc_a101;

SELECT *
FROM bronze.erp_px_cat_g1v2;

SELECT COUNT(*)
FROM bronze.erp_px_cat_g1v2;
*/
