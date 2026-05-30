CREATE DATABASE O2C_Analytics;
USE O2C_Analytics;

-- =========================================
-- DATA IMPORT & PREPARATION
-- =========================================

-- Import Dataset Using MySQL Table Data Import Wizard

RENAME TABLE
`finance factoring  ibm late payment histories`
TO invoices;

-- View Sample Data
SELECT *
FROM invoices
LIMIT 10;

-- =========================================
-- DATA EXPLORATION
-- =========================================

-- Total Number of Invoices
SELECT COUNT(*) AS total_invoices
FROM invoices;

-- Total Invoice Amount
SELECT SUM(`Invoice Amount`) AS total_invoice_value
FROM invoices;

-- Average Days Late
SELECT AVG(`Days Late`) AS avg_days_late
FROM invoices;

-- Total Disputed Invoices
SELECT COUNT(*) AS disputed_invoices
FROM invoices
WHERE Disputed = 'Yes';

-- =========================================
-- PAYMENT & CUSTOMER ANALYSIS
-- =========================================

-- Payment Method Distribution
SELECT `Paperless Bill`,
       COUNT(*) AS total_invoices
FROM invoices
GROUP BY `Paperless Bill`;

-- Countries With Highest Average Payment Delay
SELECT `Country Code`,
       AVG(`Days Late`) AS avg_days_late
FROM invoices
GROUP BY `Country Code`
ORDER BY avg_days_late DESC;

-- Top 10 Customers With Highest Average Payment Delay
SELECT `Customer ID`,
       AVG(`Days Late`) AS avg_days_late
FROM invoices
GROUP BY `Customer ID`
ORDER BY avg_days_late DESC
LIMIT 10;

-- Customer Payment Behavior Classification
SELECT `Customer ID`,
       AVG(`Days Late`) AS avg_days_late,
       CASE
           WHEN AVG(`Days Late`) <= 0 THEN 'On Time'
           WHEN AVG(`Days Late`) <= 10 THEN 'Slightly Late'
           ELSE 'Frequently Late'
       END AS payment_category
FROM invoices
GROUP BY `Customer ID`
ORDER BY avg_days_late DESC;

-- Customers Generating Highest Invoice Value
SELECT `Customer ID`,
       SUM(`Invoice Amount`) AS total_invoice_value
FROM invoices
GROUP BY `Customer ID`
ORDER BY total_invoice_value DESC
LIMIT 10;

-- Customers Who Always Pay Late
SELECT `Customer ID`,
       AVG(`Days Late`) AS avg_days_late
FROM invoices
GROUP BY `Customer ID`
HAVING AVG(`Days Late`) > 0
ORDER BY avg_days_late DESC;

-- =========================================
-- DISPUTE ANALYSIS
-- =========================================

-- Customers With Multiple Disputed Invoices
SELECT `Customer ID`,
       COUNT(*) AS disputed_invoice_count
FROM invoices
WHERE Disputed = 'Yes'
GROUP BY `Customer ID`
ORDER BY disputed_invoice_count DESC;

-- Customers With More Than 2 Disputed Invoices
SELECT `Customer ID`,
       COUNT(*) AS disputed_invoice_count
FROM invoices
WHERE Disputed = 'Yes'
GROUP BY `Customer ID`
HAVING COUNT(*) > 2
ORDER BY disputed_invoice_count DESC;

-- Total Value of Disputed Invoices
SELECT SUM(`Invoice Amount`) AS disputed_invoice_value
FROM invoices
WHERE Disputed = 'Yes';

-- Countries Generating Most Disputes
SELECT `Country Code`,
       COUNT(*) AS dispute_count
FROM invoices
WHERE Disputed = 'Yes'
GROUP BY `Country Code`
ORDER BY dispute_count DESC;

-- =========================================
-- INVOICE AGING & RISK ANALYSIS
-- =========================================

-- Invoice Aging Bucket Analysis
SELECT
    CASE
        WHEN `Days Late` <= 0 THEN 'On Time'
        WHEN `Days Late` BETWEEN 1 AND 30 THEN '1-30 Days Late'
        WHEN `Days Late` BETWEEN 31 AND 60 THEN '31-60 Days Late'
        ELSE '60+ Days Late'
    END AS aging_bucket,
    COUNT(*) AS invoice_count
FROM invoices
GROUP BY aging_bucket
ORDER BY invoice_count DESC;

-- Customer Risk Classification
SELECT `Customer ID`,
       AVG(`Days Late`) AS avg_days_late,
       CASE
           WHEN AVG(`Days Late`) <= 5 THEN 'Low Risk'
           WHEN AVG(`Days Late`) <= 20 THEN 'Medium Risk'
           ELSE 'High Risk'
       END AS risk_category
FROM invoices
GROUP BY `Customer ID`
ORDER BY avg_days_late DESC;

-- =========================================
-- REVENUE & SETTLEMENT ANALYSIS
-- =========================================

-- Top Countries by Invoice Value
SELECT `Country Code`,
       SUM(`Invoice Amount`) AS total_invoice_value
FROM invoices
GROUP BY `Country Code`
ORDER BY total_invoice_value DESC;

-- Top 10 Highest Invoice Amounts
SELECT `Invoice Number`,
       `Customer ID`,
       `Invoice Amount`
FROM invoices
ORDER BY `Invoice Amount` DESC
LIMIT 10;

-- Average Settlement Time by Country
SELECT `Country Code`,
       AVG(`Days-To-Settle`) AS avg_settlement_days
FROM invoices
GROUP BY `Country Code`
ORDER BY avg_settlement_days DESC;

-- High Value Customers With Late Payments
SELECT `Customer ID`,
       SUM(`Invoice Amount`) AS total_invoice_value,
       AVG(`Days Late`) AS avg_days_late
FROM invoices
GROUP BY `Customer ID`
HAVING AVG(`Days Late`) > 0
ORDER BY total_invoice_value DESC;