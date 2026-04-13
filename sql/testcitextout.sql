CREATE OR REPLACE FUNCTION public.testcitextout()
    RETURNS TABLE(result citext)
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY SELECT 'Hello citext'::citext;
END;
$BODY$;

ALTER FUNCTION public.testcitextout()
    OWNER TO usr;
