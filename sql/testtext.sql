CREATE OR REPLACE FUNCTION public.testtext(
	input_val text)
    RETURNS TABLE(resultcolumn text)
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
    RETURN QUERY SELECT 'Hello text';
END;
$BODY$;

ALTER FUNCTION public.testtext(input_val text)
    OWNER TO usr;
