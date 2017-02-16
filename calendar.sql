-- DROP FUNCTION generate_dates(date, integer);

CREATE OR REPLACE FUNCTION generate_dates(
    date,
    integer)
  RETURNS SETOF date AS
$BODY$
    SELECT (date_trunc('month',$1::DATE)::DATE + (interval '1' month * generate_series(0,$2::INTEGER)))::DATE AS days
$BODY$
  LANGUAGE sql IMMUTABLE STRICT
  COST 100
  ROWS 1000;

  -- DROP VIEW dates;

CREATE OR REPLACE VIEW dates AS 
 SELECT generate_dates((now() - '3 years'::interval)::date, 72) AS dates;
  
  
-- DROP VIEW calendar;

CREATE OR REPLACE VIEW calendar AS 
 SELECT to_char(dates.dates::timestamp with time zone, 'YYYY'::text) AS year, 
 to_char(dates.dates::timestamp with time zone, 'Month'::text) AS month, 
 dates.dates AS start_date, date_part('days'::text, date_trunc('month'::text, dates.dates::timestamp with time zone) + '1 mon'::interval - '1 day'::interval) AS duration
   FROM dates;
  
  
--USAGE
SELECT * FROM calendar
