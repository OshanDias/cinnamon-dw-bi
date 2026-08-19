-- =====================================================================
-- 02_staging_tables.sql : Text-based staging tables
-- Every column is VARCHAR2 so NiFi loads cannot fail on type coercion.
-- Type conversion happens later, in the transform step (04).
-- =====================================================================

-- ---------- STAGING: CSV booking export (119,390 rows) ----------
CREATE TABLE STG_BOOKINGS_CSV (
    HOTEL                          VARCHAR2(50),
    IS_CANCELED                    VARCHAR2(10),
    LEAD_TIME                      VARCHAR2(20),
    ARRIVAL_DATE_YEAR              VARCHAR2(10),
    ARRIVAL_DATE_MONTH             VARCHAR2(20),
    ARRIVAL_DATE_WEEK_NUMBER       VARCHAR2(10),
    ARRIVAL_DATE_DAY_OF_MONTH      VARCHAR2(10),
    STAYS_IN_WEEKEND_NIGHTS        VARCHAR2(10),
    STAYS_IN_WEEK_NIGHTS           VARCHAR2(10),
    ADULTS                         VARCHAR2(10),
    CHILDREN                       VARCHAR2(10),
    BABIES                         VARCHAR2(10),
    MEAL                           VARCHAR2(20),
    COUNTRY                        VARCHAR2(20),
    MARKET_SEGMENT                 VARCHAR2(50),
    DISTRIBUTION_CHANNEL           VARCHAR2(50),
    IS_REPEATED_GUEST              VARCHAR2(10),
    PREVIOUS_CANCELLATIONS         VARCHAR2(10),
    PREVIOUS_BOOKINGS_NOT_CANCELED VARCHAR2(10),
    RESERVED_ROOM_TYPE             VARCHAR2(10),
    ASSIGNED_ROOM_TYPE             VARCHAR2(10),
    BOOKING_CHANGES                VARCHAR2(10),
    DEPOSIT_TYPE                   VARCHAR2(30),
    AGENT                          VARCHAR2(20),
    COMPANY                        VARCHAR2(20),
    DAYS_IN_WAITING_LIST           VARCHAR2(10),
    CUSTOMER_TYPE                  VARCHAR2(30),
    ADR                            VARCHAR2(20),
    REQUIRED_CAR_PARKING_SPACES    VARCHAR2(10),
    TOTAL_OF_SPECIAL_REQUESTS      VARCHAR2(10),
    RESERVATION_STATUS             VARCHAR2(20),
    RESERVATION_STATUS_DATE        VARCHAR2(20)
);

-- ---------- STAGING: MySQL PMS reservations (36,275 rows) ----------
CREATE TABLE STG_RESERVATIONS (
    Booking_ID                           VARCHAR2(30),
    no_of_adults                         VARCHAR2(20),
    no_of_children                       VARCHAR2(20),
    no_of_weekend_nights                 VARCHAR2(20),
    no_of_week_nights                    VARCHAR2(20),
    type_of_meal_plan                    VARCHAR2(50),
    required_car_parking_space           VARCHAR2(20),
    room_type_reserved                   VARCHAR2(50),
    lead_time                            VARCHAR2(20),
    arrival_year                         VARCHAR2(10),
    arrival_month                        VARCHAR2(10),
    arrival_date                         VARCHAR2(10),
    market_segment_type                  VARCHAR2(50),
    repeated_guest                       VARCHAR2(10),
    no_of_previous_cancellations         VARCHAR2(20),
    no_of_previous_bookings_not_canceled VARCHAR2(20),
    avg_price_per_room                   VARCHAR2(20),
    no_of_special_requests               VARCHAR2(20),
    booking_status                       VARCHAR2(30)
);

-- ---------- STAGING: SLTDA monthly arrivals (12 rows) ----------
CREATE TABLE STG_ARRIVALS (
    Month                VARCHAR2(20),
    Arrivals_2018        VARCHAR2(20),
    Arrivals_2024        VARCHAR2(20),
    Arrivals_2025        VARCHAR2(20),
    Pct_Change_25_vs_24  VARCHAR2(20),
    Pct_Change_25_vs_18  VARCHAR2(20)
);
