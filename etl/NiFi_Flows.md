# Apache NiFi ETL Flows

All extraction and loading was done in **Apache NiFi 2.10.0** (no Python, per the coursework rules). Three flows load the three sources into text staging tables; SQL script `04_transform_load.sql` then populates the star schema.

## Controller Services (connection pools)

| Pool name | URL | Driver class |
|---|---|---|
| `Oracle_DW_Pool` | `jdbc:oracle:thin:@localhost:1521/XEPDB1` | `oracle.jdbc.OracleDriver` (ojdbc11.jar) |
| `MySQL_PMS_Pool` | `jdbc:mysql://localhost:3306/cinnamon_pms` | `com.mysql.cj.jdbc.Driver` (mysql-connector-j 9.6.0) |

## Flow 1 — CSV → STG_BOOKINGS_CSV  (119,390 rows)
`GetFile`  →  `PutDatabaseRecord`
- GetFile: Input Directory = folder holding `hotel_bookings.csv`; Keep Source File = true
- PutDatabaseRecord: Record Reader = **CSVRecordSetReader** (Schema Access Strategy = *Use String Fields From Header*, Treat First Line as Header = true); DB Pool = `Oracle_DW_Pool`; Statement Type = INSERT; Table = `STG_BOOKINGS_CSV`; Translate Field Names = true

## Flow 2 — MySQL → STG_RESERVATIONS  (36,275 rows)
`QueryDatabaseTable`  →  `PutDatabaseRecord`
- QueryDatabaseTable: DB Pool = `MySQL_PMS_Pool`; Table = `horeservations_raw`; Run Schedule = 9999 sec (anti-loop)
- PutDatabaseRecord: Record Reader = **AvroReader**; DB Pool = `Oracle_DW_Pool`; INSERT into `STG_RESERVATIONS`

## Flow 3 — Excel(CSV) → STG_ARRIVALS  (12 rows)
`GetFile`  →  `PutDatabaseRecord`
- SLTDA sheet exported to `sltda_arrivals.csv` (header row first) in its own folder
- Same CSVRecordSetReader pattern as Flow 1; INSERT into `STG_ARRIVALS`

## Golden rule used throughout
**Stage everything as text (VARCHAR2), convert late.** This avoided `ORA-01722` numeric-conversion failures on messy source values — the conversion is done safely in SQL during the transform step.

## Running NiFi
The new NiFi build does not start from `run-nifi.bat`. Set a `JAVA_HOME` path, then launch with `nifi start`, wait ~60s, and open `https://localhost:8443/nifi`.
