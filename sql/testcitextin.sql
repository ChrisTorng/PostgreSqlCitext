CREATE OR REPLACE FUNCTION public.testcitextin(
	input_val citext)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
    -- doint nothing
END;
$BODY$;

ALTER FUNCTION public.testcitextin(input_val citext)
    OWNER TO usr;
