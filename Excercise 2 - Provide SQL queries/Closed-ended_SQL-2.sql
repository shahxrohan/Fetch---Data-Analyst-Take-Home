-- Identify eligible users who created their accounts within the last 6 months
WITH UserEligibility AS (
    SELECT 
        id AS user_id, 
        created_date,
        DateDiff(day,created_date,GetDate())AS account_age_days
    FROM [dbo].[USER_TAKEHOME]
    WHERE DateDiff(month,created_date,GetDate()) <= 6

-- Filter transactions to include only those belonging to eligible users
),
EligibleTransactions AS (
    SELECT 
        t.barcode, 
        t.final_sale,
        t.user_id
    FROM [dbo].[TRANSACTION_TAKEHOME] t
    JOIN UserEligibility ue
        ON t.user_id = ue.user_id
),

-- Aggregate total sales for each brand based on eligible transactions
BrandSales AS (
    SELECT 
        p.brand, 
        SUM(cast(et.final_sale as decimal)) AS total_sales
    FROM EligibleTransactions et
    JOIN [PRODUCTS_TAKEHOME] p
        ON et.barcode = p.barcode
    GROUP BY p.brand
)

-- Display top 5 brands by total sales
SELECT top 5
    brand, 
    total_sales
FROM BrandSales
ORDER BY total_sales DESC