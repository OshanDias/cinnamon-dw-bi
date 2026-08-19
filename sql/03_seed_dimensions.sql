-- =====================================================================
-- 03_seed_dimensions.sql : Seed the static dimensions + build DIM_DATE
-- =====================================================================

-- ---------- DIM_HOTEL : the real Cinnamon property portfolio ----------
INSERT INTO DIM_HOTEL VALUES (1,'Cinnamon Grand Colombo',   'City',        'Colombo',         'Colombo',    5, 501);
INSERT INTO DIM_HOTEL VALUES (2,'Cinnamon Lakeside Colombo','City',        'Colombo',         'Colombo',    5, 346);
INSERT INTO DIM_HOTEL VALUES (3,'Cinnamon Bey Beruwala',    'Beach',       'Beruwala',        'Kalutara',   5, 138);
INSERT INTO DIM_HOTEL VALUES (4,'Cinnamon Wild Yala',       'Beach',       'Yala',            'Hambantota', 4,  92);
INSERT INTO DIM_HOTEL VALUES (5,'Cinnamon Citadel Kandy',   'Hill Country','Kandy',           'Kandy',      4, 122);
INSERT INTO DIM_HOTEL VALUES (6,'Cinnamon Dhonveli Maldives','Beach',      'North Male Atoll','N/A',        5, 110);

-- ---------- DIM_ROOMTYPE ----------
INSERT INTO DIM_ROOMTYPE VALUES (1,'Standard Room',    'Double/Twin',    2);
INSERT INTO DIM_ROOMTYPE VALUES (2,'Deluxe Room',      'King',           3);
INSERT INTO DIM_ROOMTYPE VALUES (3,'Executive Suite',  'King',           3);
INSERT INTO DIM_ROOMTYPE VALUES (4,'Family Room',      'Twin + Sofa Bed',4);
INSERT INTO DIM_ROOMTYPE VALUES (5,'Presidential Suite','King',          4);

-- ---------- DIM_CHANNEL ----------
INSERT INTO DIM_CHANNEL VALUES (1,'Direct - Website',  'Online');
INSERT INTO DIM_CHANNEL VALUES (2,'Direct - Walk-in',  'Offline');
INSERT INTO DIM_CHANNEL VALUES (3,'Booking.com',       'Online');
INSERT INTO DIM_CHANNEL VALUES (4,'Expedia',           'Online');
INSERT INTO DIM_CHANNEL VALUES (5,'Travel Agent',      'Offline');
INSERT INTO DIM_CHANNEL VALUES (6,'Corporate Account', 'Offline');
COMMIT;

-- ---------- DIM_DATE : one row per day, 2015-01-01 .. 2026-12-31 ----------
BEGIN
  FOR d IN 0 .. (TO_DATE('2026-12-31','YYYY-MM-DD') - TO_DATE('2015-01-01','YYYY-MM-DD')) LOOP
    DECLARE
      v_date DATE := TO_DATE('2015-01-01','YYYY-MM-DD') + d;
      v_mn   NUMBER := TO_NUMBER(TO_CHAR(v_date,'MM'));
      v_season VARCHAR2(20);
    BEGIN
      -- simple tourism-season classification
      IF v_mn IN (12,1,2,3,7,8) THEN v_season := 'Peak';
      ELSIF v_mn IN (4,11)      THEN v_season := 'Shoulder';
      ELSE                           v_season := 'Off-Peak';
      END IF;

      INSERT INTO DIM_DATE (DATEKEY, FULLDATE, DAYOFMONTH, MONTHNAME, MONTHNUMBER, QUARTER, YEAR, SEASON, ISWEEKEND)
      VALUES (
        TO_NUMBER(TO_CHAR(v_date,'YYYYMMDD')),
        v_date,
        TO_NUMBER(TO_CHAR(v_date,'DD')),
        TRIM(TO_CHAR(v_date,'Month','NLS_DATE_LANGUAGE=ENGLISH')),
        v_mn,
        'Q' || TO_CHAR(v_date,'Q'),
        TO_NUMBER(TO_CHAR(v_date,'YYYY')),
        v_season,
        CASE WHEN TO_CHAR(v_date,'DY','NLS_DATE_LANGUAGE=ENGLISH') IN ('SAT','SUN') THEN 'Y' ELSE 'N' END
      );
    END;
  END LOOP;
  COMMIT;
END;
/

-- Clean the stray SLTDA totals row if the CSV export brought one in
DELETE FROM STG_ARRIVALS WHERE Month NOT IN
 ('January','February','March','April','May','June',
  'July','August','September','October','November','December');
COMMIT;
