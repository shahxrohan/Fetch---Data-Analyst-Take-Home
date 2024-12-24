-- CTE to calculate the engagement level of users by counting their distinct scanned receipts
select * from  [dbo].[TRANSACTION_TAKEHOME]
WITH UserEngagement AS (
    SELECT 
        t.user_id,
        COUNT(DISTINCT t.receipt_id) AS total_receipts_scanned
    FROM [dbo].[TRANSACTION_TAKEHOME] t
    GROUP BY t.user_id
),

-- Categorize users as 'Power User' or 'Regular User' based on the number of receipts scanned
PowerUsers AS (
    SELECT 
        ue.user_id,
        ue.total_receipts_scanned,
        CASE 
            WHEN ue.total_receipts_scanned >= 10 THEN 'Power User' -- Users who have scanned 10 or more receipts in total
            ELSE 'Regular User'
        END AS user_type
    FROM UserEngagement ue
)

-- Display details of 'Power Users', sorted by their total receipts scanned in descending order
SELECT 
    pu.user_id,
    pu.total_receipts_scanned
FROM PowerUsers pu
WHERE pu.user_type = 'Power User'
ORDER BY pu.total_receipts_scanned DESC;