CREATE OR REPLACE PROCEDURE public.testrefcursor(
	INOUT p_refcur refcursor)
LANGUAGE plpgsql
AS $BODY$
BEGIN
    OPEN p_refcur FOR
        SELECT 'refcursor test' AS label;
END;
$BODY$;
ALTER PROCEDURE public.test_refcursor(INOUT p_refcur refcursor)
    OWNER TO usr;

-- Use this to fetch:
-- BEGIN;
-- CALL public.testrefcursor('cur');
-- FETCH ALL FROM cur;
-- COMMIT;