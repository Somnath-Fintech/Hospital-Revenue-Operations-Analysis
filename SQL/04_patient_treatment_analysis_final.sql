-- PATIENT & TREATMENT ANALYSIS

-- ADD A PLACE COLUMN TO THE PATIENTS TABLE
ALTER TABLE patients
ADD COLUMN place VARCHAR(25);

UPDATE patients
SET place = REGEXP_REPLACE(address, '\d+', '', 'g');


-- ADD AGE AND AGE GROUP COLUMNS
-- Age is calculated as of 31-12-2023.
ALTER TABLE patients
ADD COLUMN age NUMERIC;

UPDATE patients
SET age = EXTRACT(YEAR FROM AGE('2023-12-31', date_of_birth));

ALTER TABLE patients
ADD COLUMN age_group VARCHAR(10);

UPDATE patients
SET age_group =
    FLOOR(age / 10) * 10 || '-' ||
    (FLOOR(age / 10) * 10 + 10);


-- 1. PATIENT LOCATION ANALYSIS
-- Identifies locations with the highest patient volume and billing value.
SELECT
    place,
    COUNT(p.patient_id) AS patient_count,
    ROUND(SUM(amount), 0) AS total_bill_value
FROM patients AS p
LEFT JOIN billing AS b
    ON p.patient_id = b.patient_id
GROUP BY place
ORDER BY total_bill_value DESC;


-- 2. HIGHEST-REVENUE AGE GROUP
SELECT
    age_group,
    ROUND(SUM(amount), 0) AS total_billing
FROM patients AS p
LEFT JOIN billing AS b
    ON p.patient_id = b.patient_id
GROUP BY age_group
ORDER BY total_billing DESC;


-- 2.1 LOWEST-REVENUE AGE GROUP
-- Helps identify age groups with relatively lower billing contribution.
SELECT
    age_group,
    ROUND(SUM(amount), 0) AS total_billing,
    ROUND(
        100.0 * SUM(amount) / NULLIF(SUM(SUM(amount)) OVER (), 0),
        0
    ) AS percent_of_total_billing
FROM patients AS p
LEFT JOIN billing AS b
    ON p.patient_id = b.patient_id
GROUP BY age_group
ORDER BY percent_of_total_billing;


-- 3. TOP 5 TREATMENTS BY TREATMENT COST
WITH treatment_summary AS (
    SELECT
        treatment_type,
        description,
        COUNT(appointment_id) AS total_patients,
        SUM(cost) AS total_cost
    FROM treatments
    GROUP BY treatment_type, description
)
SELECT
    treatment_type,
    description,
    total_patients,
    total_cost,
    DENSE_RANK() OVER (ORDER BY total_cost DESC) AS treatment_rank
FROM treatment_summary
ORDER BY total_cost DESC
LIMIT 5;


-- 4. TREATMENT AND BILLING DELAYS
SELECT
    a.appointment_id,
    a.appointment_date,
    t.treatment_date,
    t.treatment_date - a.appointment_date AS delay_treatment_days,
    b.bill_date,
    b.bill_date - t.treatment_date AS delay_in_billing
FROM appointments AS a
LEFT JOIN treatments AS t
    ON a.appointment_id = t.appointment_id
LEFT JOIN billing AS b
    ON t.treatment_id = b.treatment_id
ORDER BY delay_treatment_days DESC, delay_in_billing DESC;


-- 5. SEASONAL COMPLETED VISITS
-- Uses the same season definitions as the Power BI dashboard:
-- Spring: March-May | Summer: June-August | Monsoon: September-November | Winter: December-February
SELECT
    CASE
        WHEN EXTRACT(MONTH FROM appointment_date) IN (3, 4, 5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM appointment_date) IN (6, 7, 8) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM appointment_date) IN (9, 10, 11) THEN 'Monsoon'
        ELSE 'Winter'
    END AS season,
    COUNT(*) FILTER (WHERE status = 'Completed') AS completed_appointments
FROM appointments
GROUP BY 1
ORDER BY completed_appointments DESC;


-- VERIFY APPOINTMENT DATA
SELECT *
FROM appointments
ORDER BY appointment_id;
