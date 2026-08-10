-- BRANCH & DOCTOR PERFORMANCE ANALYSIS

-- 1. HIGHEST-EARNING HOSPITAL BRANCH
SELECT
    d.hospital_branch,
    SUM(t.cost) AS total_sale
FROM doctors AS d
LEFT JOIN appointments AS a
    ON d.doctor_id = a.doctor_id
LEFT JOIN treatments AS t
    ON a.appointment_id = t.appointment_id
GROUP BY d.hospital_branch
ORDER BY total_sale DESC;


-- 1.1 MOST VALUABLE DOCTOR FROM EACH HOSPITAL BRANCH
WITH doctor_rank AS (
    SELECT
        CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
        d.specialization,
        d.hospital_branch,
        COUNT(a.appointment_id) AS total_appointments,
        COUNT(a.appointment_id) / 12.0 AS avg_monthly_appointments,
        SUM(t.cost) AS bill_value,
        DENSE_RANK() OVER (
            PARTITION BY d.hospital_branch
            ORDER BY SUM(t.cost) DESC
        ) AS branch_rank
    FROM doctors AS d
    LEFT JOIN appointments AS a
        ON d.doctor_id = a.doctor_id
    LEFT JOIN treatments AS t
        ON a.appointment_id = t.appointment_id
    GROUP BY d.doctor_id, doctor_name, d.specialization, d.hospital_branch
)
SELECT *
FROM doctor_rank
WHERE branch_rank = 1;


-- 2. TOP 5 DOCTORS BY UNATTENDED APPOINTMENTS
-- Helps identify doctors associated with the highest number of no-show/cancelled appointments.
SELECT
    CONCAT(d.first_name, ' ', d.last_name) AS doctor,
    d.specialization,
    COUNT(a.appointment_id) AS total_appointments,
    SUM(CASE WHEN a.status IN ('No-show', 'Cancelled') THEN 1 ELSE 0 END) AS unattended_appointments
FROM appointments AS a
LEFT JOIN doctors AS d
    ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_id, doctor, d.specialization
ORDER BY unattended_appointments DESC
LIMIT 5;


-- 3. DOCTOR EXPERIENCE VS REVENUE
SELECT
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    d.years_experience,
    SUM(t.cost) AS revenue
FROM doctors AS d
LEFT JOIN appointments AS a
    ON d.doctor_id = a.doctor_id
LEFT JOIN treatments AS t
    ON t.appointment_id = a.appointment_id
GROUP BY d.doctor_id, doctor_name, d.years_experience
ORDER BY revenue DESC;
