# Hospital Revenue & Operations Analysis

**SQL + Power BI | Healthcare Analytics**

## Project Overview

This project analyses hospital revenue, payment performance, appointment behaviour, branch performance, doctor performance, and patient/treatment patterns using SQL and Power BI.

The goal was to turn relational hospital data into a set of business-focused analyses and an interactive **5-page Power BI dashboard**.

---

## Business Questions

The analysis focuses on questions such as:

- How much revenue was generated, collected, and left outstanding?
- Which branches generated the highest revenue?
- Which payment methods contributed the most outstanding revenue?
- How large is the unattended appointment problem?
- Which appointment reasons and shifts show higher cancellation/unattendance?
- Which doctors and branches perform best?
- Which treatments and age groups generate the most revenue?
- Which patient locations contribute the most billing value?
- How do completed visits vary by season?

---

## Tools & Technologies

- **PostgreSQL / SQL** — data exploration, transformation and analysis
- **Power BI** — interactive dashboard and data visualization
- **DAX** — calculated measures and calculated columns
- **ERD / Relational Data Modeling** — understanding table relationships

---

## Database Structure

The database contains five main tables:

- `patients`
- `doctors`
- `appointments`
- `treatments`
- `billing`

The relationships connect patients to appointments and billing, doctors to appointments, appointments to treatments, and treatments to billing.

### Entity Relationship Diagram

![Database ERD](Dashboard/ERD.png)

---

## SQL Analysis

The SQL analysis covers:

1. Patient and doctor summaries
2. Revenue, payment status and outstanding amount analysis
3. Monthly revenue and due-percentage analysis
4. Payment-method performance
5. Monthly unattended appointment trends
6. Treatment revenue analysis
7. Age-group revenue analysis
8. Insurance-provider payment performance
9. Patient-location analysis
10. Appointment outcomes by reason for visit
11. Doctor-level unattended appointment analysis
12. Shift-wise cancellation analysis
13. Treatment-cost vs billing-amount checks
14. Treatment and billing delays
15. Seasonal completed-visit analysis
16. Branch revenue analysis
17. Doctor performance by branch
18. Experience vs revenue analysis
19. Duplicate-record checks

See the [`SQL`](SQL/) folder for the query files.

---

## Power BI Dashboard

The final dashboard contains five analytical pages.

### 1. Hospital Revenue & Operations

- Total Revenue
- Paid Revenue
- Due Revenue
- Due Percentage
- Total Appointments
- Completed Appointments
- Unattended Appointments
- Unattended Percentage
- Appointment Status
- Monthly Revenue Trend
- Revenue by Branch

### 2. Hospital Financial Analysis

- Monthly Revenue vs Due Revenue
- Quarterly analysis using slicer/bookmark interactions
- Revenue by Branch
- Due Revenue by Branch
- Due Revenue by Payment Method
- Key financial insights

### 3. Patients & Appointments Analysis

- Monthly Appointments vs Unattended %
- Shift-wise Cancelled Appointments
- Appointment Outcome by Reason for Visit
- Top Doctors by Unattended Appointments
- Appointment and patient KPIs

### 4. Branch & Doctor Performance

- Branch Revenue Performance over Time
- Due Revenue by Branch
- Top Doctors by Revenue
- Doctor Revenue vs Completed Appointments
- Top Branch and Top Doctor KPIs

### 5. Patient & Treatment Insights

- Revenue by Treatment
- Revenue by Age Group
- Revenue by Patient Location
- Completed Visits by Season
- Top Treatment
- Highest Revenue Age Group

The `.pbix` file is available in the [`powerbi`](powerbi/) folder.

---

## Key Findings

Based on the final dashboard:

- **Total Revenue:** 551,250
- **Paid Revenue:** 173,425
- **Due Revenue:** 377,825
- **Due Percentage:** 68.5%
- **Total Appointments:** 200
- **Completed Appointments:** 46
- **Unattended Appointments:** 103
- **Unattended Percentage:** 51.5%
- **Highest Revenue Branch:** Central Hospital — approximately 229K
- **Top Doctor by Revenue:** Sarah Taylor — approximately 83K
- **Top Treatment:** Chemotherapy — approximately 129K
- **Highest Revenue Age Group:** 30–40 — approximately 149K
- **Highest Completed Visits Season:** Spring — 19 completed visits

---

## Repository Structure

```text
Hospital-Revenue-Operations-Analysis/
│
├── Dashboard/
│   ├── ERD.png
│   ├── page_1_overview.png
│   ├── page_2_financial.png
│   ├── page_3_appointments.png
│   ├── page_4_branch_doctor.png
│   └── page_5_patient_treatment.png
│
├── SQL/
│   ├── 01_database_setup.sql
│   ├── 02_revenue_analysis.sql
│   ├── 03_appointment_analysis.sql
│   ├── 04_patient_treatment_analysis.sql
│   └── 05_branch_doctor_analysis.sql
│
├── dataset/
│   └── ...
│
├── powerbi/
│   └── Hospital_Revenue_Operations_Analysis.pbix
│
└── README.md
```

---

## Project Workflow

```text
Relational Hospital Data
        ↓
Database Structure / ERD
        ↓
SQL Data Exploration & Analysis
        ↓
Business Questions & KPIs
        ↓
Power BI Data Modeling & DAX
        ↓
Interactive 5-Page Dashboard
        ↓
Business Insights
```

---

## Skills Demonstrated

**SQL**
- Joins
- Aggregations
- CASE expressions
- CTEs
- Window functions
- Conditional aggregation
- Date/time analysis
- Data transformation
- Data quality checks

**Power BI**
- KPI cards
- Bar and column charts
- Line and combo charts
- Donut charts
- Scatter plot
- Slicers / bookmarks
- Conditional formatting
- Dashboard layout and storytelling

**DAX**
- Measures
- Calculated columns
- KPI calculations
- Time/season categorisation
- Sorting logic

---

## Notes

This repository contains the SQL analysis, database structure, Power BI dashboard and supporting project assets.

If the dataset contains real patient information, personally identifiable information must be removed or anonymized before publishing the repository publicly.

