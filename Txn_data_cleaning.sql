
/*******************************************************************************
PROJECT: Transaction Success/Failure Analysis
AUTHOR: Aishwarya Srivastava
DESCRIPTION: This script cleans raw transaction data, standardizes formats, 
             handles NULL values, and removes logical duplicates.
*******************************************************************************/

-- ==========================================
-- PHASE 1: ENVIRONMENT SETUP
-- ==========================================

-- Clean up existing tables to ensure a fresh run
DROP TABLE transactions CASCADE CONSTRAINTS;
DROP TABLE transactions_cleaned CASCADE CONSTRAINTS;

-- Create table to hold raw, messy data
CREATE TABLE transactions (
    transaction_id     NUMBER(10) PRIMARY KEY,
    user_id            NUMBER(10),
    amount             NUMBER(15, 2), -- Decimals for financial precision
    payment_method     VARCHAR2(50),
    transaction_status VARCHAR2(50),
    failure_reason     VARCHAR2(255),
    timestamps         VARCHAR2(100)  -- VARCHAR to hold formats (AM/PM vs 24hr)
);

-- ==========================================
-- PHASE 2: DATA CLEANING & TRANSFORMATION 
-- ==========================================
-- 1. Normalization
-- 2. Null Handling
-- 3. Timestamp Conversion (String format -> 24hr Time format)
-- 4. Removing Duplicates
-- 5. Business Logic Corrections

CREATE TABLE transactions_cleaned AS
WITH CleanedData AS (
    SELECT 
        transaction_id,
        user_id,
        ROUND(amount, 2) AS amount,
        
        -- Normalization: Convert to UPPER and remove leading/trailing spaces
        UPPER(TRIM(COALESCE(payment_method, 'UNKNOWN'))) AS payment_method,
        UPPER(TRIM(COALESCE(transaction_status, 'UNKNOWN'))) AS transaction_status,
        failure_reason,
        
        -- TIMESTAMP CONVERSION: Handles 12-hour (AM/PM) and 24-hour inputs
        To_CHAR(
        CASE 
            WHEN timestamps LIKE '%AM%' OR timestamps LIKE '%PM%' 
                 THEN TO_TIMESTAMP(timestamps, 'MM/DD/YYYY HH:MI:SS AM')
            ELSE TO_TIMESTAMP(timestamps, 'MM/DD/YYYY HH24:MI') 
        END,
        'YYYY-MM-DD HH24:MI:SS') --- Universal Compatibility: This format (YYYY-MM-DD) is the ISO standard.
        AS txn_timestamp,
        
        -- Identifies duplicate IDs and sorts based on time
        ROW_NUMBER() OVER (
            PARTITION BY transaction_id 
            ORDER BY timestamps DESC
        ) AS row_rank
    FROM transactions
    WHERE amount > 0 -- Filter: Remove invalid negative or zero amount transactions
)
SELECT 
    transaction_id,
    user_id,
    amount,
    payment_method,
    transaction_status,
    
    -- BUSINESS LOGIC: If status is SUCCESS, failure_reason must be NULL.
    -- If status is FAILED and reason is missing, label as 'Reason unknown'.
    CASE 
        WHEN transaction_status = 'SUCCESS' THEN NULL 
        WHEN transaction_status = 'FAILED' AND failure_reason IS NULL THEN 'Reason unknown'
        ELSE failure_reason 
    END AS failure_reason,
    
    txn_timestamp
FROM CleanedData
WHERE row_rank = 1; -- To Keep only unique, most recent records

-- ==========================================
-- PHASE 3: SANITY CHECKS & VALIDATION
-- ==========================================

-- 1. Verify Unique IDs (Result should be 0)
SELECT transaction_id, COUNT(*) 
FROM transactions_cleaned 
GROUP BY transaction_id 
HAVING COUNT(*) > 1;

-- 2. Verify 24-Hour Timestamp Conversion
SELECT * FROM transactions_cleaned
FETCH FIRST 5 ROWS ONLY;

-- 3. Verify no leading/trailing spaces
SELECT 
    transaction_status,
    '[' || transaction_status || ']' AS debug_view,
    LENGTH(transaction_status) AS status_length
FROM transactions_cleaned
WHERE transaction_status = 'SUCCESS'
FETCH FIRST 1 ROW ONLY;

-- 4. Ensure NO Successes have failure reasons (Result should be 0)
SELECT COUNT(*) AS logic_errors
FROM transactions_cleaned
WHERE transaction_status = 'SUCCESS' 
AND failure_reason IS NOT NULL;

-- 5. Ensure NO Null Payment Methods exist (Result should be 0)
SELECT COUNT(*) AS null_payment_methods
FROM transactions_cleaned
WHERE payment_method IS NULL;


Select * from transactions_cleaned;