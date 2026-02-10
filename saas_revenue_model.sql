/* =========================================================
   SaaS REVENUE MODELING LAYER
   Purpose: Create monthly revenue intelligence tables
   Database: MS SQL Server
   ========================================================= */


/* =========================================================
   1. CREATE CLEAN ANALYTICS TABLE
   (Never analyze raw data directly)
   ========================================================= */

SELECT
    subscription_id,
    account_id,
    start_date,
    end_date,
    plan_tier,
    seats,
    mrr_amount,
    arr_amount,
    is_trial,
    upgrade_flag,
    downgrade_flag,
    churn_flag,
    billing_frequency,
    auto_renew_flag
INTO subscriptions
FROM raw_subscriptions;



/* =========================================================
   2. SANITY CHECK
   ========================================================= */

SELECT COUNT(*) AS total_rows
FROM subscriptions;



/* =========================================================
   3. MONTHLY NEW MRR (ACQUISITION LAYER)
   ========================================================= */

SELECT
    FORMAT(start_date, 'yyyy-MM') AS month,
    SUM(mrr_amount) AS new_mrr
INTO monthly_new_mrr
FROM subscriptions
GROUP BY FORMAT(start_date, 'yyyy-MM');



/* =========================================================
   4. MONTHLY CHURNED MRR (REVENUE LEAKAGE)
   ========================================================= */

SELECT
    FORMAT(end_date, 'yyyy-MM') AS month,
    SUM(mrr_amount) AS churned_mrr
INTO monthly_churned_mrr
FROM subscriptions
WHERE churn_flag = 1
GROUP BY FORMAT(end_date, 'yyyy-MM');



/* =========================================================
   5. EXPANSION REVENUE (UPGRADES)
   ========================================================= */

SELECT
    FORMAT(start_date, 'yyyy-MM') AS month,
    SUM(
        CASE
            WHEN upgrade_flag = 1 THEN mrr_amount
            ELSE 0
        END
    ) AS expansion_mrr
INTO monthly_expansion_mrr
FROM subscriptions
GROUP BY FORMAT(start_date, 'yyyy-MM');



/* =========================================================
   6. COMBINE MONTHLY REVENUE MOVEMENT
   ========================================================= */

SELECT
    COALESCE(n.month, c.month) AS month,
    ISNULL(n.new_mrr, 0) AS new_mrr,
    ISNULL(c.churned_mrr, 0) AS churned_mrr,
    ISNULL(n.new_mrr, 0) - ISNULL(c.churned_mrr, 0) AS net_mrr_change
INTO v_monthly_mrr
FROM monthly_new_mrr n
FULL OUTER JOIN monthly_churned_mrr c
ON n.month = c.month;



/* =========================================================
   7. CREATE STARTING MRR BASE (RUNNING TOTAL)
   ========================================================= */

SELECT
    month,
    SUM(net_mrr_change) OVER (ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS starting_mrr
INTO monthly_starting_mrr
FROM v_monthly_mrr;



/* =========================================================
   8. BUILD NRR MODEL
   ========================================================= */

SELECT
    s.month,
    s.starting_mrr,
    ISNULL(e.expansion_mrr, 0) AS expansion_mrr,
    ISNULL(c.churned_mrr, 0) AS churned_mrr,
    
    CASE
        WHEN s.starting_mrr = 0 THEN NULL
        ELSE (s.starting_mrr + ISNULL(e.expansion_mrr, 0) - ISNULL(c.churned_mrr, 0)) / s.starting_mrr
    END AS nrr

INTO v_monthly_nrr
FROM monthly_starting_mrr s
LEFT JOIN monthly_expansion_mrr e
    ON s.month = e.month
LEFT JOIN monthly_churned_mrr c
    ON s.month = c.month;



/* =========================================================
   9. FINAL OUTPUT CHECKS
   ========================================================= */

SELECT TOP 20 * FROM v_monthly_mrr ORDER BY month;

SELECT TOP 20 * FROM v_monthly_nrr ORDER BY month;


