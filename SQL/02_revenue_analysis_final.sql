-- REVENUE & PAYMENT ANALYSIS

-- 1. TOTAL SALES, DUE AMOUNT, RECEIVED AMOUNT AND BILL COUNTS
-- Provides an overview of hospital billing performance.
WITH status_summary AS (
    SELECT
        payment_status,
        COUNT(*) AS bill_count,
        SUM(amount) AS status_amount
    FROM billing
    GROUP BY payment_status
)
SELECT
    payment_status,
    SUM(bill_count) OVER () AS total_bill_count,
    SUM(status_amount) OVER () AS total_sale,
    SUM(CASE WHEN payment_status IN ('Pending', 'Failed') THEN status_amount ELSE 0 END)
        OVER () AS total_due_failed_and_pending,
    SUM(CASE WHEN payment_status = 'Paid' THEN status_amount ELSE 0 END)
        OVER () AS total_amount_received,
    ROUND(100.0 * status_amount / SUM(status_amount) OVER (), 1) AS percent_of_total_sales,
    bill_count AS status_bill_count
FROM status_summary
ORDER BY payment_status;


-- 1.1 MONTHLY TOTAL SALES AND DUE PERCENTAGE
-- Helps identify months where outstanding payments require more attention.
SELECT
    TO_CHAR(DATE_TRUNC('month', bill_date), 'MON-YYYY') AS month,
    SUM(amount) AS total_sale_amount,
    SUM(CASE WHEN payment_status = 'Paid' THEN amount ELSE 0 END) AS monthly_bill_paid,
    SUM(CASE WHEN payment_status = 'Pending' THEN amount ELSE 0 END) AS pending_amount,
    SUM(CASE WHEN payment_status = 'Failed' THEN amount ELSE 0 END) AS failed_amount,
    ROUND(
        100.0 * SUM(CASE WHEN payment_status <> 'Paid' THEN amount ELSE 0 END)
        / NULLIF(SUM(amount), 0),
        2
    ) AS percent_of_dues
FROM billing
GROUP BY DATE_TRUNC('month', bill_date)
ORDER BY DATE_TRUNC('month', bill_date);


-- 2. PAYMENT METHODS WITH THE HIGHEST PENDING/FAILED AMOUNTS
-- Helps identify payment methods associated with higher outstanding amounts.
SELECT
    payment_method,
    COUNT(*) AS total_bill_count,
    COUNT(*) FILTER (WHERE payment_status IN ('Pending', 'Failed')) AS due_bill_count,
    ROUND(SUM(amount) FILTER (WHERE payment_status IN ('Pending', 'Failed')), 0) AS unpaid_bill_value
FROM billing
GROUP BY payment_method
ORDER BY unpaid_bill_value DESC;


-- 3. INSURANCE PROVIDER PAYMENT PERFORMANCE
-- Identifies providers with the highest and lowest paid percentages.
WITH provider_summary AS (
    SELECT
        p.insurance_provider,
        SUM(b.amount) AS total_bill_value,
        SUM(CASE WHEN b.payment_status = 'Paid' THEN b.amount ELSE 0 END) AS paid_bill_value,
        SUM(CASE WHEN b.payment_status IN ('Failed', 'Pending') THEN b.amount ELSE 0 END) AS due_bill_value
    FROM patients AS p
    LEFT JOIN billing AS b
        ON p.patient_id = b.patient_id
    GROUP BY p.insurance_provider
)
SELECT
    insurance_provider,
    total_bill_value,
    paid_bill_value,
    due_bill_value,
    ROUND(100.0 * paid_bill_value / NULLIF(total_bill_value, 0), 2) AS paid_percent
FROM provider_summary
ORDER BY paid_percent DESC;


-- 4. TREATMENT COST VS BILLING AMOUNT
-- Checks whether treatment cost and billed amount differ.
SELECT
    a.appointment_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    ROUND(SUM(t.cost), 0) AS treatment_cost,
    ROUND(SUM(b.amount), 0) AS billing_amount,
    ROUND(SUM(t.cost) - SUM(b.amount), 0) AS difference
FROM appointments AS a
LEFT JOIN patients AS p
    ON a.patient_id = p.patient_id
LEFT JOIN treatments AS t
    ON a.appointment_id = t.appointment_id
LEFT JOIN billing AS b
    ON t.treatment_id = b.treatment_id
GROUP BY a.appointment_id, patient_name
HAVING ROUND(SUM(t.cost) - SUM(b.amount), 0) <> 0;
