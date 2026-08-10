-- APPOINTMENT & ATTENDANCE ANALYSIS

-- ADD A SHIFT COLUMN TO THE APPOINTMENTS TABLE
ALTER TABLE appointments
ADD COLUMN shift VARCHAR(30);

UPDATE appointments
SET shift = CASE
    WHEN appointment_time BETWEEN '08:00:00' AND '11:59:00' THEN 'Morning_visits'
    WHEN appointment_time BETWEEN '12:00:00' AND '13:59:00' THEN 'Noon_visits'
    WHEN appointment_time BETWEEN '14:00:00' AND '15:59:00' THEN 'Afternoon_visits'
    WHEN appointment_time BETWEEN '16:00:00' AND '17:59:00' THEN 'Evening_visits'
    ELSE 'Night_visits'
END;


-- 1. MONTHLY UNATTENDED APPOINTMENTS AND MONTH-OVER-MONTH CHANGE
/*
Hospital can monitor unattended appointments and take steps to reduce missed visits.
Reducing unattended appointments may improve operational efficiency and revenue capture.
*/
WITH monthly_stats AS (
    SELECT
        DATE_TRUNC('month', appointment_date) AS month_date,
        TO_CHAR(DATE_TRUNC('month', appointment_date), 'MON-YYYY') AS month,
        COUNT(*) AS total_appointments,
        COUNT(*) FILTER (WHERE status = 'Completed') AS completed_appointments,
        COUNT(*) FILTER (WHERE status IN ('No-show', 'Cancelled')) AS unattended_appointments,
        COUNT(*) FILTER (WHERE status = 'Scheduled') AS scheduled_appointments,
        ROUND(
            100.0 * COUNT(*) FILTER (WHERE status IN ('No-show', 'Cancelled'))
            / NULLIF(COUNT(*), 0),
            2
        ) AS percent_absent_appointments
    FROM appointments
    GROUP BY DATE_TRUNC('month', appointment_date)
)
SELECT
    month,
    total_appointments,
    unattended_appointments,
    percent_absent_appointments,
    ROUND(
        100.0 * (
            percent_absent_appointments
            - LAG(percent_absent_appointments) OVER (ORDER BY month_date)
        )
        / NULLIF(LAG(percent_absent_appointments) OVER (ORDER BY month_date), 0),
        2
    ) AS percent_change_from_previous_month
FROM monthly_stats
ORDER BY month_date;


-- 2. APPOINTMENT OUTCOME BY REASON FOR VISIT
-- Shows completed, scheduled and unattended appointments by visit purpose.
SELECT *
FROM (
    SELECT
        reason_for_visit,
        COUNT(appointment_id) AS total_appointments,
        SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed_appointments,
        SUM(CASE WHEN status = 'Scheduled' THEN 1 ELSE 0 END) AS scheduled_appointments,
        SUM(CASE WHEN status IN ('No-show', 'Cancelled') THEN 1 ELSE 0 END) AS unattended_appointments
    FROM appointments
    GROUP BY reason_for_visit

    UNION ALL

    SELECT
        'Total',
        COUNT(appointment_id),
        SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END),
        SUM(CASE WHEN status = 'Scheduled' THEN 1 ELSE 0 END),
        SUM(CASE WHEN status IN ('No-show', 'Cancelled') THEN 1 ELSE 0 END)
    FROM appointments
) AS appointment_summary
ORDER BY
    CASE WHEN reason_for_visit = 'Total' THEN 1 ELSE 0 END,
    unattended_appointments DESC;


-- 2.1 WHICH SHIFT HAS THE MOST CANCELLED APPOINTMENTS?
SELECT
    shift,
    status,
    COUNT(*) AS number_of_appointments
FROM appointments
WHERE status = 'Cancelled'
GROUP BY shift, status
ORDER BY number_of_appointments DESC;


-- 2.2 PATIENTS WITH UNATTENDED APPOINTMENTS
-- Identifies patients with the highest proportion of no-show/cancelled appointments.
SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    COUNT(*) AS total_appointments,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE a.status IN ('No-show', 'Cancelled')
        ) / NULLIF(COUNT(*), 0),
        0
    ) AS absent_appointments_percent
FROM patients AS p
LEFT JOIN appointments AS a
    ON p.patient_id = a.patient_id
GROUP BY p.patient_id, patient_name
ORDER BY absent_appointments_percent DESC;
