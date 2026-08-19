# 🏨 Cinnamon Hotels & Resorts — Data Warehouse & Business Intelligence

An end-to-end **Data Warehouse and Business Intelligence** solution built for a multi-property hospitality chain (modelled on Cinnamon Hotels & Resorts, John Keells Group). Three real, heterogeneous data sources are integrated into an Oracle **star schema** through an **Apache NiFi** ETL pipeline, then analysed with a **Power BI** dashboard and **OLAP cubes**.

> Coursework — Data Warehousing & Business Intelligence · HND in Software Engineering · NIBM · Group 13

---

## 📌 Overview

| | |
|---|---|
| **Organisation** | Cinnamon Hotels & Resorts (multi-property chain) |
| **Warehouse** | Oracle 21c XE — star schema, 1 fact + 5 dimensions |
| **ETL** | Apache NiFi 2.10.0 (3 flows, no Python) |
| **BI** | Microsoft Power BI — 11 visuals + 3 OLAP cubes |
| **Fact rows loaded** | **119,390** (zero row loss) |

## 🗂️ Data Sources (all real, non-synthetic)

1. **CSV** — Hotel Booking Demand (119,390 records) → central reservation system
2. **SQL** — MySQL `cinnamon_pms` (36,275 records) → Property Management System
3. **Excel** — SLTDA monthly tourist arrivals → external seasonal-demand context

## ⭐ Star Schema

`FACT_BOOKINGS` (measures: lead time, length of stay, ADR, total revenue, cancellation flag, guests, special requests) linked to:

- `DIM_DATE` · `DIM_CUSTOMER` · `DIM_HOTEL` · `DIM_ROOMTYPE` · `DIM_CHANNEL`

## 🔁 ETL Pipeline (Apache NiFi)

Extract → **stage as text** → Transform (clean, standardise codes, unify guests, build date keys) → Load into star schema. See [`etl/NiFi_Flows.md`](etl/NiFi_Flows.md).

## 📊 Key Findings

- Total revenue ≈ **Rs 42.7M**; **city hotels ≈ 59%** of revenue vs 41% beach
- Clear **seasonal peak in July–August**
- **Cancellation gap:** city hotels ~**41.7%** vs beach ~**27.8%**
- Booking data is Europe-heavy (Portugal-led) while SLTDA shows the true India-led market — proof of the value of combining internal + external data

## 🧮 OLAP Cubes

1. **Revenue Cube** — Hotel × Date × Channel
2. **Occupancy Cube** — Hotel × Room Type × Date
3. **Guest Behaviour Cube** — Segment × Country × Season

All five operations demonstrated: **roll-up, drill-down, slice, dice, pivot**.

## ▶️ How to Reproduce

1. Run SQL in order against an Oracle XE **XEPDB1** connection:
   `sql/01_create_schema.sql` → `02_staging_tables.sql` → `03_seed_dimensions.sql`
2. Load the three sources into the `STG_*` tables with the NiFi flows in `etl/`
3. Run `sql/04_transform_load.sql` to populate the star schema (expect 119,390 fact rows)
4. Run `sql/05_validation.sql` to verify counts and headline insights
5. Open the Power BI file in `powerbi/` and connect to the warehouse

## 📁 Repository Structure

```
cinnamon-dw-bi/
├── sql/           01–05 scripts: schema, staging, seed, transform, validation
├── etl/           NiFi flow documentation
├── powerbi/       Power BI .pbix dashboard  (add your file)
├── screenshots/   evidence: NiFi flows, loads, dashboard, OLAP ops
├── docs/          report, presentation, project record
└── README.md
```



## 🛠️ Tech Stack

`Oracle 21c XE` · `SQL / PL-SQL` · `MySQL` · `Apache NiFi` · `Power BI` · `OLAP`
