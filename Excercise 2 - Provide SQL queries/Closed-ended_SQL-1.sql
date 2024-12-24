-- Calculate the age of each user in years, derived from their birth_date, and filter only users who are at least 21 years old
WITH UserAge AS (
    SELECT 
        id AS user_id, 
        DATEDIFF(hour, birth_date, GETDATE()) / 8766 AS age -- Convert hours difference to approximate years
    FROM [dbo].[USER_TAKEHOME]
),

-- Filter transactions to include only those associated with users aged 21 or older
FilteredTransactions AS (
    SELECT 
        t.receipt_id, 
        t.barcode,
        u.age 
    FROM [dbo].[TRANSACTION_TAKEHOME] t 
    JOIN UserAge u
        ON t.user_id = u.user_id 
    WHERE u.age >= 21 
),

-- Count the distinct receipts scanned for each brand
BrandCounts AS (
    SELECT 
        p.brand, -- Brand name of the product
        COUNT(DISTINCT ft.receipt_id) AS receipts_scanned 
    FROM FilteredTransactions ft 
    JOIN [PRODUCTS_TAKEHOME] p
        ON ft.barcode = p.barcode 
    GROUP BY p.brand

-- Display top 5 brands by the number of distinct receipts scanned
SELECT TOP 5
    brand, 
    receipts_scanned
FROM BrandCounts
ORDER BY receipts_scanned DESC