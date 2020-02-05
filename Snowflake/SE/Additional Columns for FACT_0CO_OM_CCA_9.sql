UPDATE FACT_0CO_OM_CCA_9 
SET  XLIFNR = CASE 
    WHEN LIFNR = '' THEN (CASE WHEN ZZLIFNR = '' THEN '' ELSE ZZLIFNR END)
    ELSE LIFNR
END,
 intdate = cast(cast(year(budat) as varchar(4))||right('0'|| cast(month(budat) as varchar(2)),2)||right('0'|| cast(day(budat) as varchar(2)),2) as integer)
;
