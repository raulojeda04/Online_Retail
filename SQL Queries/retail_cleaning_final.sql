
			--- STEP 1: JOIN TABLES INTO NEW TABLE ---

WITH combined_retail AS (
SELECT *
FROM retail_2009_2010
UNION ALL 
SELECT
	*
FROM retail_2010_2011
)
SELECT 
	*
INTO
	retail
FROM
	combined_retail


	
			--- STEP 2: MAKE COPY OF RAW DATA ---

SELECT
	*
INTO
	retail_staging
FROM
	retail



			--- STEP 3: INSPECT DATA ---

SELECT
	*
FROM
	retail_staging
-- 1,067,371 rows

	

			--- STEP 4: DUPLICATES ---

-- a. Check for Duplicates

SELECT
    Invoice,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    Price,
    Customer_ID,
    Country,
    COUNT(*) AS DuplicateCount
FROM
    retail_staging -- Replace with your table name
GROUP BY
    InvoiceDate,
	Invoice,
    StockCode,
    Description,
    Quantity,
    Price,
    Customer_ID,
    Country
HAVING
    COUNT(*) > 1
ORDER BY
    DuplicateCount DESC;
-- 32907 rows of unique duplicates


-- b. Remove Duplicates

WITH dupcheck AS (
	SELECT
		*,
		ROW_NUMBER() OVER(
			PARTITION BY 
				Invoice, 
				StockCode, 
				Description,
				Quantity, 
				InvoiceDate, 
				Price, 
				Customer_ID, 
				Country
			ORDER BY 
				InvoiceDate) row_num
	FROM
		retail_staging
) 
DELETE
FROM 
	dupcheck
WHERE 
	row_num > 1
-- 34335 rows affected



			--- STEP 5: VALIDATE DATE FORMAT ---

EXEC sp_help retail_staging



			--- STEP 6: INVALID TRANSACTIONS ---

-- Cancellations/Returns/Invalid Business Logic


-- a. Identify Invalid Rows

SELECT
	*
FROM
	retail_staging
WHERE
	Invoice LIKE 'C%' -- 19104 rows
	OR Quantity <= 0 -- 22496 rows
	OR Price = 0 -- 6014 rows
	OR Price IS NULL -- 5 rows
ORDER BY 
	InvoiceDate
-- 25123 rows


-- b. Create New Table for Invalid Transactions

SELECT
	*
INTO
	invalid_retail_transactions
FROM
	retail_staging
WHERE
	Invoice LIKE 'C%'
	OR Quantity < 0 
	OR Price = 0
	OR Price IS NULL


-- c. Delete Invalid Transactions
DELETE
FROM
	retail_staging
WHERE
	Invoice LIKE 'C%'
	OR Quantity < 0 
	OR Price = 0
	OR Price IS NULL;



			--- STEP 7: REMOVE NON-PRODUCTS ---

-- Some StockCodes are not actually products but operational and financial adjustments so they will be removed


-- a. List All StockCodes for Operational and Financial Adjustments  

SELECT 
	DISTINCT
		StockCode,
		Description
FROM
	retail_staging
ORDER BY
	StockCode DESC;


-- b. Investigate All StockCodes for Operational and Financial Adjustments 

SELECT 
	*
FROM
	retail_staging
WHERE
	StockCode IN ('ADJUST', 'ADJUST2', 'AMAZONFEE', 'B', 'BANK CHARGES', 'C2', 'D', 'DOT', 'M', 'POST', 'S', 'TEST001', 'TEST002') 
ORDER BY 
	Price;
-- 4479 rows of Operational and Financial Adjustments


-- c. Delete Rows

DELETE
FROM
	retail_staging
WHERE
	StockCode IN ('ADJUST', 'ADJUST2', 'AMAZONFEE', 'B', 'BANK CHARGES', 'C2', 'D', 'DOT', 'M', 'POST', 'S', 'TEST001', 'TEST002');


			--- STEP 8: STANDARDIZE DESCRIPTIONS ---

-- a. Investigate Descriptions Column

SELECT
	DISTINCT
		StockCode,
		Description
FROM
	retail_staging
ORDER BY
	Description
-- 5401 descriptions
-- Some of these have the same StockCode but different Descriptions


-- b. Map One Description to One StockCode

SELECT 
	StockCode,
	MAX(Description) CanonicalDescription
FROM
	retail_staging
WHERE
	StockCode IS NOT NULL
	AND Price <> 0
	AND Quantity > 0
	AND Description <> ''
	AND Description IS NOT NULL
GROUP BY
	StockCode
ORDER BY 
	StockCode
-- 4745 Unique Descriptions


-- c. Update Descriptions

WITH StockCodeMap AS (
	SELECT 
		StockCode,
		MAX(Description) CanonicalDescription
	FROM
		retail_staging
	WHERE
		StockCode IS NOT NULL
		AND Price <> 0
		AND Quantity > 0
		AND Description <> ''
		AND Description IS NOT NULL
	GROUP BY
		StockCode
)
UPDATE
	rs
SET
	rs.Description = map.CanonicalDescription
FROM
	retail_staging rs
JOIN
	StockCodeMap map
ON
	rs.StockCode = map.StockCode


-- d. Inspect Results

-- Re-run part a -> Should have 4745 Unique Descriptions now



			--- STEP 9: COUNTRY COLUMN ---

-- a. Investigate Country Column

SELECT
	DISTINCT Country
FROM
	retail_staging
ORDER BY
	Country
-- Found 4 Unusual Entries: EIRE, European Community, RSA, Unspecified
-- Going to update 3 (EIRE, European Community, RSA) to a more identifable entry and delete 1 (Unspecified)


-- b. Update

UPDATE
	retail_staging
SET
	Country = CASE
		WHEN Country = 'EIRE' THEN 'Ireland'
		WHEN Country = 'European Community' THEN 'European Union'
		WHEN Country = 'RSA' THEN 'Republic of South Africa'
		ELSE Country
END

-- c. Delete

DELETE
FROM 
	retail_staging
WHERE
	Country = 'Unspecified'



			--- STEP 10: ADD NEW COLUMNS ---

-- a. Add New Columns

ALTER TABLE
	retail_staging
ADD 
	Revenue Decimal(18,2),
	InvoiceYear INT,
	InvoiceMonth INT,
	InvoiceDay INT,
	InvoiceHour INT,
	DayName VARCHAR(10)
-- Added 6 new columns to our table


-- b. Fill New Columns 
UPDATE
	retail_staging
SET
	Revenue = Quantity * Price,
	InvoiceYear = DATEPART(YEAR, InvoiceDate),
	InvoiceMonth = DATEPART(MONTH, InvoiceDate),
	InvoiceDay =  DATEPART(DAY, InvoiceDate),
	InvoiceHour = DATEPART(hour, InvoiceDate),
	DayName = DATENAME(weekday, InvoiceDate)


-- c. Inspect Results

SELECT
	*
FROM
	retail_staging



			--- STEP 11: OUTLIERS - PERCENTILE BASED APPROACH ---

-- a. Find the 99.99th Percentile Value for Price

-- The 99th and 99.95th Percentile Pvalue were too low so the Percentile was adjusted to 99.99
SELECT
    PERCENTILE_CONT(0.9999) WITHIN GROUP (ORDER BY Price) OVER() AS P9995_Value
FROM
    retail_staging;
-- P9995_Value = 145


-- b. Investigate P9995_Value  
SELECT
	DISTINCT StockCode, Description, Price
FROM
	retail_staging
WHERE
	Price > 145
ORDER BY 
	Price DESC;
-- 12 DISTINCT rows in the Top 0.01% with 7 Distinct StockCodes 
-- StockCodes: 22502, 22655, 22656, 22826, 22827, 22828, 84016


-- c. Investigate StockCodes

SELECT
	*
FROM
	retail_staging
WHERE 
	StockCode IN ('22502', '22655', '22656', '22826', '22827', '22828', '84016')
ORDER BY
	StockCode, Price DESC
-- StockCode = '22502': 2 Price Anomalies
-- StockCode = '84016': 11 Price Anomalies
-- Rest of the StockCodes are the Highest Priced Items


-- d. Delete Anomalies 

DELETE 
FROM
	retail_staging
WHERE
	StockCode IN ('84016', '22502')
	AND Price > 20



			--- STEP 12: Descriptions Column ---

-- There are some inconsistencies in the Description column that will be addressed

-- a. Capitalization

UPDATE
	retail_staging
SET
	Description = UPPER(Description)


-- b. Starting with Special Character

-- The first 3 Products start with a special character (*) that need to be removed
UPDATE 
	retail_staging
SET
	Description = CASE
		WHEN Description = '*Boombox Ipod Classic' THEN 'BOOMBOX IPOD CLASSIC'
		WHEN Description = '*USB Office Glitter Lamp' THEN 'USB OFFICE GLITTER LAMP'
		WHEN Description = '*USB Office Mirror Ball' THEN 'USB OFFICE MIRROR BALL'
		ELSE Description
END



			--- STEP 13: CREATE NEW TABLES ---
			
-- Going to make 2 separte tables: retail_customer_analysis & retail_customer_analysis
SELECT
	*
INTO 
	retail_customer_analysis
FROM
	retail_staging
-- Will be used for Customer Segmentation Analysis


SELECT
	*
INTO 
	retail_product_analysis
FROM
	retail_staging
-- Will be used for General Sales Analysis



			--- STEP 14: NULLS ---

-- For Customer Analysis, need to be able to group order by customers so will need to remove any rows in Customer_ID with NULLS
-- For Product Analysis, can replace NULLS with a place holder (0) since the purchaser is not important in this analysis

-- a. Identify Number of NULLS in Customer_ID Column

SELECT
	*
FROM
	retail_customer_analysis
WHERE
	Customer_ID IS NULL
ORDER BY 
	InvoiceDate
-- 226838 rows of NULLS in Customer_ID column


-- b. Map CustomerIDs with Invoices

SELECT
	Invoice,
	MAX(Customer_ID) UniqueID
FROM
	retail_customer_analysis
WHERE
	Customer_ID IS NOT NULL	
GROUP BY
	Invoice
ORDER BY
	Invoice


-- c. Update NULL CustomerIDs
WITH IDMap AS (
	SELECT
		Invoice,
		MAX(Customer_ID) UniqueID
	FROM
		retail_staging
	WHERE
		Customer_ID IS NOT NULL
	GROUP BY
		Invoice
)
UPDATE
	rs
SET
	rs.Customer_ID = id.UniqueID
FROM
	retail_staging rs
JOIN
	IDMap id
ON
	rs.Invoice = id.Invoice
WHERE
	rs.Customer_ID IS NULL
-- 0 rows affected -> Dont have any matching Invoices for empty Customer IDs 


-- d. Delete NULLS from retail_customer_analysis table

DELETE
FROM
	retail_customer_analysis
WHERE
	Customer_ID IS NULL
-- 226838 rows affected


-- e. Replace NULLs in retail_product_analysis

UPDATE
	retail_product_analysis
SET
	Customer_ID = CASE 
		WHEN Customer_ID IS NULL THEN 0
		ELSE Customer_ID
END


