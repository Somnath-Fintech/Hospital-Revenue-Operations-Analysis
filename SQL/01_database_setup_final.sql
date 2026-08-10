-- DATABASE SETUP
-- Creates the core hospital analytics tables and adds primary/foreign key constraints.

DROP TABLE IF EXISTS billing, treatments, appointments, doctors, patients CASCADE;

CREATE TABLE patients (
    patient_id          VARCHAR(5),
    first_name          VARCHAR(10),
    last_name           VARCHAR(10),
    gender              VARCHAR(5),
    date_of_birth       DATE,
    contact_number      VARCHAR(10),
    address             VARCHAR(15),
    registration_date   DATE,
    insurance_provider  VARCHAR(15),
    insurance_number    VARCHAR(10),
    email               VARCHAR(25)
);

CREATE TABLE doctors (
    doctor_id           VARCHAR(4),
    first_name          VARCHAR(10),
    last_name           VARCHAR(10),
    specialization      VARCHAR(20),
    phone_number        VARCHAR(10),
    years_experience    VARCHAR(2),
    hospital_branch     VARCHAR(25),
    email               VARCHAR(40)
);

CREATE TABLE appointments (
    appointment_id      VARCHAR(5),
    patient_id          VARCHAR(5),
    doctor_id           VARCHAR(4),
    appointment_date    DATE,
    appointment_time    TIME,
    reason_for_visit    VARCHAR(25),
    status              VARCHAR(10)
);

CREATE TABLE treatments (
    treatment_id        VARCHAR(4),
    appointment_id      VARCHAR(5),
    treatment_type      VARCHAR(13),
    description         VARCHAR(18),
    cost                NUMERIC,
    treatment_date      DATE
);

CREATE TABLE billing (
    bill_id             VARCHAR(4),
    patient_id          VARCHAR(5),
    treatment_id        VARCHAR(4),
    bill_date           DATE,
    amount              NUMERIC,
    payment_method      VARCHAR(11),
    payment_status      VARCHAR(7)
);

-- PRIMARY KEY CONSTRAINTS
ALTER TABLE patients
ADD PRIMARY KEY (patient_id);

ALTER TABLE doctors
ADD PRIMARY KEY (doctor_id);

ALTER TABLE appointments
ADD PRIMARY KEY (appointment_id);

ALTER TABLE treatments
ADD PRIMARY KEY (treatment_id);

ALTER TABLE billing
ADD PRIMARY KEY (bill_id);

-- FOREIGN KEY CONSTRAINTS
ALTER TABLE appointments
ADD FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
ADD FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id);

ALTER TABLE treatments
ADD FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id);

ALTER TABLE billing
ADD FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
ADD FOREIGN KEY (treatment_id) REFERENCES treatments(treatment_id);

-- DATA VALIDATION
SELECT * FROM appointments;
SELECT * FROM billing;
SELECT * FROM doctors;
SELECT * FROM patients;
SELECT * FROM treatments;

-- FIND DUPLICATE APPOINTMENT RECORDS
SELECT *, COUNT(*) AS repeat_count
FROM appointments
GROUP BY 1, 2, 3, 4, 5, 6, 7
HAVING COUNT(*) > 1;

-- BASIC QUERIES

-- TOTAL MALE AND FEMALE PATIENTS
SELECT
    COUNT(*) AS total_patients,
    SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male_patients,
    SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS female_patients
FROM patients;

-- TOTAL DOCTORS BY SPECIALIZATION
SELECT
    specialization,
    COUNT(*) AS total_doctors
FROM doctors
GROUP BY specialization

UNION ALL

SELECT
    'TOTAL',
    COUNT(*)
FROM doctors;
