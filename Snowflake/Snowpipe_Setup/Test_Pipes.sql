
create or replace pipe TEST_PIPE_1
    auto_ingest = true
    integration = 'SNOWPIPE_NOTIFICATION'
  as
  copy into SOURCE_SYSTEM_TEST.SAPRAW.CSKT_SP
  from
  (SELECT
    $1:MANDT::VARCHAR(3) AS MANDT,
    $1:SPRAS::VARCHAR(1) AS SPRAS,
    $1:KOKRS::VARCHAR(4) AS KOKRS,
    $1:KOSTL::VARCHAR(10) AS KOSTL,
    TO_DATE(TO_TIMESTAMP($1:DATBI)) AS DATBI,
    $1:KTEXT::VARCHAR(20) AS KTEXT,
    $1:LTEXT::VARCHAR(40) AS LTEXT,
    $1:MCTXT::VARCHAR(20) AS MCTXT
  FROM
    @SE_DATALAKE_STAGE/
  );

create or replace pipe TEST_PIPE_2
    auto_ingest = true
    integration = 'SNOWPIPE_NOTIFICATION'
  as
  copy into SOURCE_SYSTEM_TEST.SAPRAW.CSKS_SP
  from
  (SELECT $1:MANDT::VARCHAR(3) AS MANDT,$1:KOKRS::VARCHAR(4) AS KOKRS,$1:KOSTL::VARCHAR(10) AS KOSTL,TO_DATE(TO_TIMESTAMP($1:DATBI)) AS DATBI,TO_DATE(TO_TIMESTAMP($1:DATAB)) AS DATAB,$1:BKZKP::VARCHAR(1) AS BKZKP,$1:PKZKP::VARCHAR(1) AS PKZKP,$1:BUKRS::VARCHAR(4) AS BUKRS,$1:GSBER::VARCHAR(4) AS GSBER,$1:KOSAR::VARCHAR(1) AS KOSAR,$1:VERAK::VARCHAR(20) AS VERAK,$1:VERAK_USER::VARCHAR(12) AS VERAK_USER,$1:WAERS::VARCHAR(5) AS WAERS,$1:KALSM::VARCHAR(6) AS KALSM,$1:TXJCD::VARCHAR(15) AS TXJCD,$1:PRCTR::VARCHAR(10) AS PRCTR,$1:WERKS::VARCHAR(4) AS WERKS,$1:LOGSYSTEM::VARCHAR(10) AS LOGSYSTEM,TO_DATE(TO_TIMESTAMP($1:ERSDA)) AS ERSDA,$1:USNAM::VARCHAR(12) AS USNAM,$1:BKZKS::VARCHAR(1) AS BKZKS,$1:BKZER::VARCHAR(1) AS BKZER,$1:BKZOB::VARCHAR(1) AS BKZOB,$1:PKZKS::VARCHAR(1) AS PKZKS,$1:PKZER::VARCHAR(1) AS PKZER,$1:VMETH::VARCHAR(2) AS VMETH,$1:MGEFL::VARCHAR(1) AS MGEFL,$1:ABTEI::VARCHAR(12) AS ABTEI,$1:NKOST::VARCHAR(10) AS NKOST,$1:KVEWE::VARCHAR(1) AS KVEWE,$1:KAPPL::VARCHAR(2) AS KAPPL,$1:KOSZSCHL::VARCHAR(6) AS KOSZSCHL,$1:LAND1::VARCHAR(3) AS LAND1,$1:ANRED::VARCHAR(15) AS ANRED,$1:NAME1::VARCHAR(35) AS NAME1,$1:NAME2::VARCHAR(35) AS NAME2,$1:NAME3::VARCHAR(35) AS NAME3,$1:NAME4::VARCHAR(35) AS NAME4,$1:ORT01::VARCHAR(35) AS ORT01,$1:ORT02::VARCHAR(35) AS ORT02,$1:STRAS::VARCHAR(35) AS STRAS,$1:PFACH::VARCHAR(10) AS PFACH,$1:PSTLZ::VARCHAR(10) AS PSTLZ,$1:PSTL2::VARCHAR(10) AS PSTL2,$1:REGIO::VARCHAR(3) AS REGIO,$1:SPRAS::VARCHAR(1) AS SPRAS,$1:TELBX::VARCHAR(15) AS TELBX,$1:TELF1::VARCHAR(16) AS TELF1,$1:TELF2::VARCHAR(16) AS TELF2,$1:TELFX::VARCHAR(31) AS TELFX,$1:TELTX::VARCHAR(30) AS TELTX,$1:TELX1::VARCHAR(30) AS TELX1,$1:DATLT::VARCHAR(14) AS DATLT,$1:DRNAM::VARCHAR(4) AS DRNAM,$1:KHINR::VARCHAR(12) AS KHINR,$1:CCKEY::VARCHAR(23) AS CCKEY,$1:KOMPL::VARCHAR(1) AS KOMPL,$1:STAKZ::VARCHAR(1) AS STAKZ,$1:OBJNR::VARCHAR(22) AS OBJNR,$1:FUNKT::VARCHAR(3) AS FUNKT,$1:AFUNK::VARCHAR(3) AS AFUNK,$1:CPI_TEMPL::VARCHAR(10) AS CPI_TEMPL,$1:CPD_TEMPL::VARCHAR(10) AS CPD_TEMPL,$1:FUNC_AREA::VARCHAR(16) AS FUNC_AREA,$1:SCI_TEMPL::VARCHAR(10) AS SCI_TEMPL,$1:SCD_TEMPL::VARCHAR(10) AS SCD_TEMPL,$1:SKI_TEMPL::VARCHAR(10) AS SKI_TEMPL,$1:SKD_TEMPL::VARCHAR(10) AS SKD_TEMPL,$1:VNAME::VARCHAR(6) AS VNAME,$1:RECID::VARCHAR(2) AS RECID,$1:ETYPE::VARCHAR(3) AS ETYPE,$1:JV_OTYPE::VARCHAR(4) AS JV_OTYPE,$1:JV_JIBCL::VARCHAR(3) AS JV_JIBCL,$1:JV_JIBSA::VARCHAR(5) AS JV_JIBSA,$1:FERC_IND::VARCHAR(4) AS FERC_IND
  FROM
    @SE_DATALAKE_STAGE/
  );
