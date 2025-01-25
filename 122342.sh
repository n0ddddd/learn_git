5jxx2dzgn405h

SELECT /*+monitor test111*/ SV.SHIP_VISIT_NO SHIP_VISIT_NO,
                   SV.SHIP_USE_TYPE SHIP_USE_TYPE,
                   SSD.SHIP_NAME,
                   SV.BERTH_CODE,
                   SV.EX_CARGO_WGT,
                   SV.SHIP_LINE_CODE,
                   SV.TRANSPORT_WAY,
                   (SELECT NAME
                      FROM SYS_CODE
                     WHERE     SYS_CODE.CODE = TRANSPORT_WAY
                           AND CATEGORY_CODE = 'TRANSPORT_WAY'
                           AND FACILITY_ID = 'NKGLT')
                      TRANS_NAME,
                   SV.TRADE_TYPE,
                   (SELECT NAME
                      FROM SYS_CODE
                     WHERE     SYS_CODE.CODE = SV.TRADE_TYPE
                           AND CATEGORY_CODE = 'TRADE_TYPE'
                           AND FACILITY_ID = 'NKGLT')
                      TRADE_NAME,
                   IM_VOYAGE,
                   EX_VOYAGE,
                   SV.FROM_PORT_CODE,
                   (SELECT PORT_NAME
                      FROM SBC_PORT
                     WHERE PORT_CODE = SV.FROM_PORT_CODE AND FACILITY_ID = 'NKGLT')
                      FROM_NAME,
                   SV.TO_PORT_CODE,
                   (SELECT PORT_NAME
                      FROM SBC_PORT
                     WHERE PORT_CODE = SV.TO_PORT_CODE AND FACILITY_ID = 'NKGLT')
                      TO_NAME,
                   TO_CHAR (NVL (SV.DTA, SV.ETA), 'DD') SHIP_LINE,
                   NVL (DTA, ETA) PLAN_ETB,
                   SV.RTB,
                   SV.LOAD_BEGIN_TIME,
                   LOAD_END_TIME,
                   DISC_BEGIN_TIME,
                   DISC_END_TIME,
                   SV.RTD,
                   (SELECT MAX (NVL (SBS.ETU, WC.ETU))
                      FROM WORK_CARRIER WC, SHIP_BERTHPLAN_SORT SBS
                     WHERE     WC.CARRIER_VISIT_NO = SV.SHIP_VISIT_NO
                           AND WC.CARRIER_VISIT_NO = SBS.SHIP_VISIT_NO
                           AND WC.FACILITY_ID = SBS.FACILITY_ID
                           AND WC.FACILITY_ID = 'NKGLT')
                      PLAN_ETU,
                   NVL (
                      SUM (
                         CASE
                            WHEN     UNIT_SIZE_CODE <= '20'
                                 AND EMPTY_FULL_MARK = 'E'
                                 AND IMP_EXP_MARK = 'I'
                            THEN
                               1
                            ELSE
                               0
                         END),
                      0)
                      I_E_20,
                   NVL (
                      SUM (
                         CASE
                            WHEN     UNIT_SIZE_CODE > '20'
                                 AND UNIT_SIZE_CODE <= '40'
                                 AND EMPTY_FULL_MARK = 'E'
                                 AND IMP_EXP_MARK = 'I'
                            THEN
                               1
                            ELSE
                               0
                         END),
                      0)
                      I_E_40,
                   NVL (
                      SUM (
                         CASE
                            WHEN     UNIT_SIZE_CODE > '40'
                                 AND UNIT_SIZE_CODE <= '45'
                                 AND EMPTY_FULL_MARK = 'E'
                                 AND IMP_EXP_MARK = 'I'
                            THEN
                               1
                            ELSE
                               0
                         END),
                      0)
                      I_E_45,
                   NVL (
                      SUM (
                         CASE
                            WHEN     UNIT_SIZE_CODE <= '20'
                                 AND EMPTY_FULL_MARK = 'F'
                                 AND IMP_EXP_MARK = 'I'
                            THEN
                               1
                            ELSE
                               0
                         END),
                      0)
                      I_F_20,
                   NVL (
                      SUM (
                         CASE
                            WHEN     UNIT_SIZE_CODE > '20'
                                 AND UNIT_SIZE_CODE <= '40'
                                 AND EMPTY_FULL_MARK = 'F'
                                 AND IMP_EXP_MARK = 'I'
                            THEN
                               1
                            ELSE
                               0
                         END),
                      0)
                      I_F_40,
                   NVL (
                      SUM (
                         CASE
                            WHEN     UNIT_SIZE_CODE > '40'
                                 AND UNIT_SIZE_CODE <= '45'
                                 AND EMPTY_FULL_MARK = 'F'
                                 AND IMP_EXP_MARK = 'I'
                            THEN
                               1
                            ELSE
                               0
                         END),
                      0)
                      I_F_45,
                   NVL (
                      SUM (
                         CASE
                            WHEN     UNIT_SIZE_CODE <= '20'
                                 AND EMPTY_FULL_MARK = 'E'
                                 AND IMP_EXP_MARK = 'E'
                            THEN
                               1
                            ELSE
                               0
                         END),
                      0)
                      E_E_20,
                   NVL (
                      SUM (
                         CASE
                            WHEN     UNIT_SIZE_CODE > 20
                                 AND UNIT_SIZE_CODE <= '40'
                                 AND EMPTY_FULL_MARK = 'E'
                                 AND IMP_EXP_MARK = 'E'
                            THEN
                               1
                            ELSE
                               0
                         END),
                      0)
                      E_E_40,
                   NVL (
                      SUM (
                         CASE
                            WHEN     UNIT_SIZE_CODE > 40
                                 AND UNIT_SIZE_CODE <= '45'
                                 AND EMPTY_FULL_MARK = 'E'
                                 AND IMP_EXP_MARK = 'E'
                            THEN
                               1
                            ELSE
                               0
                         END),
                      0)
                      E_E_45,
                   NVL (
                      SUM (
                         CASE
                            WHEN     UNIT_SIZE_CODE <= '20'
                                 AND EMPTY_FULL_MARK = 'F'
                                 AND IMP_EXP_MARK = 'E'
                            THEN
                               1
                            ELSE
                               0
                         END),
                      0)
                      E_F_20,
                   NVL (
                      SUM (
                         CASE
                            WHEN     UNIT_SIZE_CODE > '20'
                                 AND UNIT_SIZE_CODE <= '40'
                                 AND EMPTY_FULL_MARK = 'F'
                                 AND IMP_EXP_MARK = 'E'
                            THEN
                               1
                            ELSE
                               0
                         END),
                      0)
                      E_F_40,
                   NVL (
                      SUM (
                         CASE
                            WHEN     UNIT_SIZE_CODE > '40'
                                 AND UNIT_SIZE_CODE <= '45'
                                 AND EMPTY_FULL_MARK = 'F'
                                 AND IMP_EXP_MARK = 'E'
                            THEN
                               1
                            ELSE
                               0
                         END),
                      0)
                      E_F_45,
                   SUM (
                      CASE
                         WHEN IMP_EXP_MARK = 'I' THEN F_GET_TEU (UNIT_SIZE_CODE)
                         ELSE 0
                      END)
                      I_TEU,
                   SUM (
                      CASE
                         WHEN IMP_EXP_MARK = 'E' THEN F_GET_TEU (UNIT_SIZE_CODE)
                         ELSE 0
                      END)
                      E_TEU,
                   SUM (F_GET_TEU (UNIT_SIZE_CODE)) TEU,
                   TEU_QTY,
                     SUM (
                        CASE
                           WHEN IMP_EXP_MARK = 'E'
                           THEN
                              F_GET_TEU (UNIT_SIZE_CODE)
                           ELSE
                              0
                        END)
                   / TEU_QTY
                      E_LOAD_RATE,
                     SUM (
                        CASE
                           WHEN IMP_EXP_MARK = 'I'
                           THEN
                              F_GET_TEU (UNIT_SIZE_CODE)
                           ELSE
                              0
                        END)
                   / TEU_QTY
                      I_LOAD_RATE,
                   ELEC_PILE_MARK,
                   MIN (CASE WHEN IMP_EXP_MARK = 'I' THEN QUAY_WORK_TIME END)
                      MIN_I_WORK_TIME,
                   MIN (CASE WHEN IMP_EXP_MARK = 'E' THEN QUAY_WORK_TIME END)
                      MIN_E_WORK_TIME,
                   MAX (CASE WHEN IMP_EXP_MARK = 'I' THEN QUAY_WORK_TIME END)
                      MAX_I_WORK_TIME,
                   MAX (CASE WHEN IMP_EXP_MARK = 'E' THEN QUAY_WORK_TIME END)
                      MAX_E_WORK_TIME,
                   MIN (QUAY_WORK_TIME) MIN_WORK_TIME,
                   MAX (QUAY_WORK_TIME) MAX_WORK_TIME,
                   SV.SERVICE_CODE,
                   SSS.SERVICE_NAME,
                   SHIP_COURSE_CODE,
                   (SELECT SHIP_COURSE_NAME
                      FROM SBC_SHIP_COURSE SSC
                     WHERE     SSC.SHIP_COURSE_CODE = SSS.SHIP_COURSE_CODE
                           AND SSC.FACILITY_ID = 'NKGLT')
                      SHIP_COURSE_NAME
              FROM SHIP_VISIT SV,
                   SHIP_WORK_UNIT SWU,
                   SBC_SHIP_SERVICE SSS,
                   SBC_SHIP_DATA SSD
             WHERE     SWU.SHIP_VISIT_NO = SV.SHIP_VISIT_NO
                   AND SV.SHIP_CODE = SSD.SHIP_CODE
                   AND SV.FACILITY_ID = SSD.FACILITY_ID
                   AND SV.SERVICE_CODE = SSS.SERVICE_CODE(+)
                   AND NVL (ROLLBACK_MARK, '0') <> '1'
                   AND SV.FACILITY_ID = 'NKGLT'
                   AND SWU.QUAY_WORK_TIME >=
                          TO_DATE ( '2024-11-01', 'yyyy-MM-dd hh24:mi:ss')
                   AND SWU.QUAY_WORK_TIME <=
                          TO_DATE ( '2024-11-08', 'yyyy-MM-dd hh24:mi:ss')
                   AND NVL (SWU.IMIT_MARK, '0') = '0'
          GROUP BY SV.SHIP_VISIT_NO,
                   SSD.SHIP_NAME,
                   SV.BERTH_CODE,
                   SV.SHIP_LINE_CODE,
                   SV.TRANSPORT_WAY,
                   SV.SHIP_USE_TYPE,
                   SV.TRADE_TYPE,
                   IM_VOYAGE,
                   EX_VOYAGE,
                   SV.FROM_PORT_CODE,
                   SV.TO_PORT_CODE,
                   TO_CHAR (NVL (SV.DTA, SV.ETA), 'DD'),
                   NVL (DTA, ETA),
                   SV.RTB,
                   LOAD_BEGIN_TIME,
                   LOAD_END_TIME,
                   DISC_BEGIN_TIME,
                   DISC_END_TIME,
                   SV.RTD,
                   TEU_QTY,
                   ELEC_PILE_MARK,
                   SV.SERVICE_CODE,
                   SSS.SERVICE_NAME,
                   SV.EX_CARGO_WGT,
                   SHIP_COURSE_CODE;
				   
				   

283 rows selected.

Elapsed: 00:00:02.29

Execution Plan
----------------------------------------------------------
Plan hash value: 938028027

--------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                                       | Name                         | Rows  | Bytes |TempSpc| Cost (%CPU)| Time     | Pstart| Pstop |
--------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                                |                              | 34097 |  7725K|       |    38M  (1)| 00:01:50 |       |       |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED            | SYS_CODE                     |     1 |    39 |       |     4   (0)| 00:00:01 |       |       |
|*  2 |   INDEX SKIP SCAN                               | IDX_SYS_CODE                 |     1 |       |       |     3   (0)| 00:00:01 |       |       |
|   3 |  TABLE ACCESS BY INDEX ROWID BATCHED            | SYS_CODE                     |     1 |    39 |       |     3   (0)| 00:00:01 |       |       |
|*  4 |   INDEX SKIP SCAN                               | IDX_SYS_CODE                 |     1 |       |       |     2   (0)| 00:00:01 |       |       |
|*  5 |  TABLE ACCESS BY INDEX ROWID BATCHED            | SBC_PORT                     |     1 |    23 |       |     2   (0)| 00:00:01 |       |       |
|*  6 |   INDEX SKIP SCAN                               | IDX_SBC_PORT_AUTH            |     1 |       |       |     1   (0)| 00:00:01 |       |       |
|*  7 |  TABLE ACCESS BY INDEX ROWID BATCHED            | SBC_PORT                     |     1 |    23 |       |     2   (0)| 00:00:01 |       |       |
|*  8 |   INDEX SKIP SCAN                               | IDX_SBC_PORT_AUTH            |     1 |       |       |     1   (0)| 00:00:01 |       |       |
|   9 |  SORT AGGREGATE                                 |                              |     1 |    51 |       |            |          |       |       |
|* 10 |   HASH JOIN                                     |                              |     1 |    51 |       |  1324   (0)| 00:00:01 |       |       |
|  11 |    TABLE ACCESS BY INDEX ROWID                  | SHIP_BERTHPLAN_SORT          |     1 |    29 |       |     2   (0)| 00:00:01 |       |       |
|* 12 |     INDEX UNIQUE SCAN                           | IDX_SHIP_BERTHPLAN_SORT      |     1 |       |       |     1   (0)| 00:00:01 |       |       |
|* 13 |    TABLE ACCESS BY INDEX ROWID BATCHED          | WORK_CARRIER                 |     2 |    44 |       |  1322   (0)| 00:00:01 |       |       |
|* 14 |     INDEX SKIP SCAN                             | WORKCARRIER_SHIP_WORK_UNIQUE |     2 |       |       |  1320   (0)| 00:00:01 |       |       |
|  15 |  TABLE ACCESS BY INDEX ROWID BATCHED            | SBC_SHIP_COURSE              |     1 |    27 |       |     2   (0)| 00:00:01 |       |       |
|* 16 |   INDEX RANGE SCAN                              | IDX_SBC_SHIP_COURSE_AUTH     |     1 |       |       |     1   (0)| 00:00:01 |       |       |
|  17 |  HASH GROUP BY                                  |                              | 34097 |  7725K|  8536K|    38M  (1)| 00:01:50 |       |       |
|* 18 |   FILTER                                        |                              |       |       |       |            |          |       |       |
|* 19 |    HASH JOIN                                    |                              | 34097 |  7725K|       | 17119   (1)| 00:00:01 |       |       |
|* 20 |     TABLE ACCESS FULL                           | SBC_SHIP_DATA                |  2529 | 78399 |       |    27   (0)| 00:00:01 |       |       |
|* 21 |     HASH JOIN RIGHT OUTER                       |                              | 34068 |  6687K|       | 17092   (1)| 00:00:01 |       |       |
|  22 |      TABLE ACCESS FULL                          | SBC_SHIP_SERVICE             |    33 |   891 |       |     4   (0)| 00:00:01 |       |       |
|* 23 |      HASH JOIN                                  |                              | 34068 |  5788K|       | 17088   (1)| 00:00:01 |       |       |
|  24 |       PARTITION RANGE ITERATOR                  |                              | 34068 |  1131K|       | 15719   (1)| 00:00:01 |   KEY |   KEY |
|* 25 |        TABLE ACCESS BY LOCAL INDEX ROWID BATCHED| SHIP_WORK_UNIT               | 34068 |  1131K|       | 15719   (1)| 00:00:01 |   KEY |   KEY |
|* 26 |         INDEX RANGE SCAN                        | IDX_SHIP_WORK_UNIT_04        | 34078 |       |       |    95   (0)| 00:00:01 |   KEY |   KEY |
|* 27 |       TABLE ACCESS FULL                         | SHIP_VISIT                   | 78838 |    10M|       |  1369   (1)| 00:00:01 |       |       |
--------------------------------------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   2 - access("FACILITY_ID"='NKGLT' AND "CATEGORY_CODE"='TRANSPORT_WAY' AND "SYS_CODE"."CODE"=:B1)
       filter("SYS_CODE"."CODE"=:B1 AND "CATEGORY_CODE"='TRANSPORT_WAY')
   4 - access("FACILITY_ID"='NKGLT' AND "CATEGORY_CODE"='TRADE_TYPE' AND "SYS_CODE"."CODE"=:B1)
       filter("SYS_CODE"."CODE"=:B1 AND "CATEGORY_CODE"='TRADE_TYPE')
   5 - filter("FACILITY_ID"='NKGLT')
   6 - access("PORT_CODE"=:B1)
       filter("PORT_CODE"=:B1)
   7 - filter("FACILITY_ID"='NKGLT')
   8 - access("PORT_CODE"=:B1)
       filter("PORT_CODE"=:B1)
  10 - access("WC"."CARRIER_VISIT_NO"="SBS"."SHIP_VISIT_NO" AND "WC"."FACILITY_ID"="SBS"."FACILITY_ID")
  12 - access("SBS"."SHIP_VISIT_NO"=:B1 AND "SBS"."FACILITY_ID"='NKGLT')
  13 - filter("WC"."FACILITY_ID"='NKGLT')
  14 - access("WC"."CARRIER_VISIT_NO"=:B1)
       filter("WC"."CARRIER_VISIT_NO"=:B1)
  16 - access("SSC"."FACILITY_ID"='NKGLT' AND "SSC"."SHIP_COURSE_CODE"=:B1)
       filter("SSC"."SHIP_COURSE_CODE"=:B1)
  18 - filter(TO_DATE('2024-11-08','yyyy-MM-dd hh24:mi:ss')>=TO_DATE('2024-11-01','yyyy-MM-dd hh24:mi:ss'))
  19 - access("SV"."SHIP_CODE"="SSD"."SHIP_CODE" AND "SV"."FACILITY_ID"="SSD"."FACILITY_ID")
  20 - filter("SSD"."FACILITY_ID"='NKGLT')
  21 - access("SV"."SERVICE_CODE"="SSS"."SERVICE_CODE"(+))
  23 - access("SWU"."SHIP_VISIT_NO"="SV"."SHIP_VISIT_NO")
  25 - filter(NVL("SWU"."IMIT_MARK",'0')='0' AND NVL("ROLLBACK_MARK",'0')<>'1')
  26 - access("SWU"."QUAY_WORK_TIME">=TO_DATE('2024-11-01','yyyy-MM-dd hh24:mi:ss') AND
              "SWU"."QUAY_WORK_TIME"<=TO_DATE('2024-11-08','yyyy-MM-dd hh24:mi:ss'))
  27 - filter("SV"."FACILITY_ID"='NKGLT')


Statistics
----------------------------------------------------------
          6  recursive calls
          0  db block gets
     377061  consistent gets
          0  physical reads
          0  redo size
      85103  bytes sent via SQL*Net to client
       5249  bytes received via SQL*Net from client
         20  SQL*Net roundtrips to/from client
          0  sorts (memory)
          0  sorts (disk)
        283  rows processed




SQL> @sqlinfo.sql
Enter value for sql_id: 5jxx2dzgn405h
old  19: where sql_id = '&&sql_id'
new  19: where sql_id = '5jxx2dzgn405h'
old  42: where sql_id = '&&sql_id'
new  42: where sql_id = '5jxx2dzgn405h'

SQL_ID        PLAN_HASH_VALUE INST_ID PARSING_SCHEMA_NAME         EXECS    AVG_ETIME AVG_CPU_TIME        AVG_LIO      AVG_PIO AVG_ROWPROC NOTES
------------- --------------- ------- -------------------- ------------ ------------ ------------ -------------- ------------ ----------- ---------
5jxx2dzgn405h       938028027       1 CITOS                           1        2.275        2.254      377,061.0           .0         283 now info

old   1: select * from table(dbms_xplan.display_cursor('&&sql_id',null,'allstats last +outline'))
new   1: select * from table(dbms_xplan.display_cursor('5jxx2dzgn405h',null,'allstats last +outline'))

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SQL_ID  5jxx2dzgn405h, child number 0
-------------------------------------
SELECT /*+monitor test111*/ SV.SHIP_VISIT_NO SHIP_VISIT_NO,
       SV.SHIP_USE_TYPE SHIP_USE_TYPE,
SSD.SHIP_NAME,                    SV.BERTH_CODE,
SV.EX_CARGO_WGT,                    SV.SHIP_LINE_CODE,
  SV.TRANSPORT_WAY,                    (SELECT NAME
  FROM SYS_CODE                      WHERE     SYS_CODE.CODE =
TRANSPORT_WAY                            AND CATEGORY_CODE =
'TRANSPORT_WAY'                            AND FACILITY_ID = 'NKGLT')
                    TRANS_NAME,                    SV.TRADE_TYPE,
             (SELECT NAME                       FROM SYS_CODE
           WHERE     SYS_CODE.CODE = SV.TRADE_TYPE
      AND CATEGORY_CODE = 'TRADE_TYPE'                            AND
FACILITY_ID = 'NKGLT')                       TRADE_NAME,
    IM_VOYAGE,                    EX_VOYAGE,
SV.FROM_PORT_CODE,                    (S

Plan hash value: 938028027

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                                       | Name                         | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                                |                              |      1 |        |    283 |00:00:00.35 |   28184 |       |       |          |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED            | SYS_CODE                     |      5 |      1 |      5 |00:00:00.01 |      23 |       |       |          |
|*  2 |   INDEX SKIP SCAN                               | IDX_SYS_CODE                 |      5 |      1 |      5 |00:00:00.01 |      20 |       |       |          |
|   3 |  TABLE ACCESS BY INDEX ROWID BATCHED            | SYS_CODE                     |      2 |      1 |      2 |00:00:00.01 |      10 |       |       |          |
|*  4 |   INDEX SKIP SCAN                               | IDX_SYS_CODE                 |      2 |      1 |      2 |00:00:00.01 |       8 |       |       |          |
|*  5 |  TABLE ACCESS BY INDEX ROWID BATCHED            | SBC_PORT                     |     48 |      1 |     48 |00:00:00.01 |      89 |       |       |          |
|*  6 |   INDEX SKIP SCAN                               | IDX_SBC_PORT_AUTH            |     48 |      1 |     48 |00:00:00.01 |      48 |       |       |          |
|*  7 |  TABLE ACCESS BY INDEX ROWID BATCHED            | SBC_PORT                     |     55 |      1 |     55 |00:00:00.01 |     100 |       |       |          |
|*  8 |   INDEX SKIP SCAN                               | IDX_SBC_PORT_AUTH            |     55 |      1 |     55 |00:00:00.01 |      55 |       |       |          |
|   9 |  SORT AGGREGATE                                 |                              |    283 |      1 |    283 |00:00:01.86 |     348K|       |       |          |
|* 10 |   HASH JOIN                                     |                              |    283 |      1 |    456 |00:00:01.85 |     348K|  1152K|  1152K|  417K (0)|
|  11 |    TABLE ACCESS BY INDEX ROWID                  | SHIP_BERTHPLAN_SORT          |    283 |      1 |    260 |00:00:00.01 |     827 |       |       |          |
|* 12 |     INDEX UNIQUE SCAN                           | IDX_SHIP_BERTHPLAN_SORT      |    283 |      1 |    260 |00:00:00.01 |     567 |       |       |          |
|* 13 |    TABLE ACCESS BY INDEX ROWID BATCHED          | WORK_CARRIER                 |    260 |      2 |    456 |00:00:01.84 |     347K|       |       |          |
|* 14 |     INDEX SKIP SCAN                             | WORKCARRIER_SHIP_WORK_UNIQUE |    260 |      2 |    456 |00:00:01.83 |     347K|       |       |          |
|  15 |  TABLE ACCESS BY INDEX ROWID BATCHED            | SBC_SHIP_COURSE              |      9 |      1 |      9 |00:00:00.01 |      13 |       |       |          |
|* 16 |   INDEX RANGE SCAN                              | IDX_SBC_SHIP_COURSE_AUTH     |      9 |      1 |      9 |00:00:00.01 |       5 |       |       |          |
|  17 |  HASH GROUP BY                                  |                              |      1 |  34097 |    283 |00:00:00.35 |   28184 |   764K|   764K| 2740K (0)|
|* 18 |   FILTER                                        |                              |      1 |        |  39731 |00:00:00.19 |   28184 |       |       |          |
|* 19 |    HASH JOIN                                    |                              |      1 |  34097 |  39731 |00:00:00.19 |   28184 |  1196K|  1196K| 1420K (0)|
|* 20 |     TABLE ACCESS FULL                           | SBC_SHIP_DATA                |      1 |   2529 |   2559 |00:00:00.01 |      99 |       |       |          |
|* 21 |     HASH JOIN RIGHT OUTER                       |                              |      1 |  34068 |  39731 |00:00:00.17 |   28085 |  1281K|  1281K| 1652K (0)|
|  22 |      TABLE ACCESS FULL                          | SBC_SHIP_SERVICE             |      1 |     33 |     33 |00:00:00.01 |       7 |       |       |          |
|* 23 |      HASH JOIN                                  |                              |      1 |  34068 |  39731 |00:00:00.16 |   28078 |  3944K|  1579K| 4920K (0)|
|  24 |       PARTITION RANGE ITERATOR                  |                              |      1 |  34068 |  39731 |00:00:00.08 |   23038 |       |       |          |
|* 25 |        TABLE ACCESS BY LOCAL INDEX ROWID BATCHED| SHIP_WORK_UNIT               |      1 |  34068 |  39731 |00:00:00.07 |   23038 |       |       |          |
|* 26 |         INDEX RANGE SCAN                        | IDX_SHIP_WORK_UNIT_04        |      1 |  34078 |  39732 |00:00:00.01 |     119 |       |       |          |
|* 27 |       TABLE ACCESS FULL                         | SHIP_VISIT                   |      1 |  78838 |  79216 |00:00:00.07 |    5040 |       |       |          |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------

Outline Data
-------------

  /*+
      BEGIN_OUTLINE_DATA
      IGNORE_OPTIM_EMBEDDED_HINTS
      OPTIMIZER_FEATURES_ENABLE('12.2.0.1')
      DB_VERSION('12.2.0.1')
      OPT_PARAM('_px_adaptive_dist_method' 'off')
      OPT_PARAM('_optimizer_strans_adaptive_pruning' 'false')
      OPT_PARAM('_optimizer_nlj_hj_adaptive_join' 'false')
      ALL_ROWS
      OUTLINE_LEAF(@"SEL$2")
      OUTLINE_LEAF(@"SEL$3")
      OUTLINE_LEAF(@"SEL$4")
      OUTLINE_LEAF(@"SEL$5")
      OUTLINE_LEAF(@"SEL$6")
      OUTLINE_LEAF(@"SEL$7")
      OUTLINE_LEAF(@"SEL$1")
      INDEX_RS_ASC(@"SEL$1" "SWU"@"SEL$1" ("SHIP_WORK_UNIT"."QUAY_WORK_TIME"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$1" "SWU"@"SEL$1")
      FULL(@"SEL$1" "SV"@"SEL$1")
      FULL(@"SEL$1" "SSS"@"SEL$1")
      FULL(@"SEL$1" "SSD"@"SEL$1")
      LEADING(@"SEL$1" "SWU"@"SEL$1" "SV"@"SEL$1" "SSS"@"SEL$1" "SSD"@"SEL$1")
      USE_HASH(@"SEL$1" "SV"@"SEL$1")
      USE_HASH(@"SEL$1" "SSS"@"SEL$1")
      USE_HASH(@"SEL$1" "SSD"@"SEL$1")
      SWAP_JOIN_INPUTS(@"SEL$1" "SSS"@"SEL$1")
      SWAP_JOIN_INPUTS(@"SEL$1" "SSD"@"SEL$1")
      USE_HASH_AGGREGATION(@"SEL$1")
      INDEX_RS_ASC(@"SEL$7" "SSC"@"SEL$7" ("SBC_SHIP_COURSE"."FACILITY_ID" "SBC_SHIP_COURSE"."CODES_SET_CODE" "SBC_SHIP_COURSE"."SHIP_COURSE_CODE"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$7" "SSC"@"SEL$7")
      INDEX_RS_ASC(@"SEL$6" "SBS"@"SEL$6" ("SHIP_BERTHPLAN_SORT"."SHIP_VISIT_NO" "SHIP_BERTHPLAN_SORT"."FACILITY_ID"))
      INDEX_SS(@"SEL$6" "WC"@"SEL$6" ("WORK_CARRIER"."WORK_SHIFT_NO" "WORK_CARRIER"."CARRIER_VISIT_NO"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$6" "WC"@"SEL$6")
      LEADING(@"SEL$6" "SBS"@"SEL$6" "WC"@"SEL$6")
      USE_HASH(@"SEL$6" "WC"@"SEL$6")
      INDEX_SS(@"SEL$5" "SBC_PORT"@"SEL$5" ("SBC_PORT"."CODES_SET_CODE" "SBC_PORT"."PORT_CODE"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$5" "SBC_PORT"@"SEL$5")
      INDEX_SS(@"SEL$4" "SBC_PORT"@"SEL$4" ("SBC_PORT"."CODES_SET_CODE" "SBC_PORT"."PORT_CODE"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$4" "SBC_PORT"@"SEL$4")
      INDEX_SS(@"SEL$3" "SYS_CODE"@"SEL$3" ("SYS_CODE"."FACILITY_ID" "SYS_CODE"."CODES_SET_CODE" "SYS_CODE"."CATEGORY_CODE" "SYS_CODE"."CODE"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$3" "SYS_CODE"@"SEL$3")
      INDEX_SS(@"SEL$2" "SYS_CODE"@"SEL$2" ("SYS_CODE"."FACILITY_ID" "SYS_CODE"."CODES_SET_CODE" "SYS_CODE"."CATEGORY_CODE" "SYS_CODE"."CODE"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$2" "SYS_CODE"@"SEL$2")
      END_OUTLINE_DATA
  */

Predicate Information (identified by operation id):
---------------------------------------------------

   2 - access("FACILITY_ID"='NKGLT' AND "CATEGORY_CODE"='TRANSPORT_WAY' AND "SYS_CODE"."CODE"=:B1)
       filter(("SYS_CODE"."CODE"=:B1 AND "CATEGORY_CODE"='TRANSPORT_WAY'))
   4 - access("FACILITY_ID"='NKGLT' AND "CATEGORY_CODE"='TRADE_TYPE' AND "SYS_CODE"."CODE"=:B1)
       filter(("SYS_CODE"."CODE"=:B1 AND "CATEGORY_CODE"='TRADE_TYPE'))
   5 - filter("FACILITY_ID"='NKGLT')
   6 - access("PORT_CODE"=:B1)
       filter("PORT_CODE"=:B1)
   7 - filter("FACILITY_ID"='NKGLT')
   8 - access("PORT_CODE"=:B1)
       filter("PORT_CODE"=:B1)
  10 - access("WC"."CARRIER_VISIT_NO"="SBS"."SHIP_VISIT_NO" AND "WC"."FACILITY_ID"="SBS"."FACILITY_ID")
  12 - access("SBS"."SHIP_VISIT_NO"=:B1 AND "SBS"."FACILITY_ID"='NKGLT')
  13 - filter("WC"."FACILITY_ID"='NKGLT')
  14 - access("WC"."CARRIER_VISIT_NO"=:B1)
       filter("WC"."CARRIER_VISIT_NO"=:B1)
  16 - access("SSC"."FACILITY_ID"='NKGLT' AND "SSC"."SHIP_COURSE_CODE"=:B1)
       filter("SSC"."SHIP_COURSE_CODE"=:B1)
  18 - filter(TO_DATE('2024-11-08','yyyy-MM-dd hh24:mi:ss')>=TO_DATE('2024-11-01','yyyy-MM-dd hh24:mi:ss'))
  19 - access("SV"."SHIP_CODE"="SSD"."SHIP_CODE" AND "SV"."FACILITY_ID"="SSD"."FACILITY_ID")
  20 - filter("SSD"."FACILITY_ID"='NKGLT')
  21 - access("SV"."SERVICE_CODE"="SSS"."SERVICE_CODE")
  23 - access("SWU"."SHIP_VISIT_NO"="SV"."SHIP_VISIT_NO")
  25 - filter((NVL(DECODE(TO_CHAR(SYS_OP_VECBIT("SYS_NC00129$",0)),NULL,NVL("SWU"."IMIT_MARK",'0'),'0',NVL("SWU"."IMIT_MARK",'0'),'1',"SWU"."IMIT_MARK"),'0')
              ='0' AND NVL("ROLLBACK_MARK",'0')<>'1'))
  26 - access("SWU"."QUAY_WORK_TIME">=TO_DATE('2024-11-01','yyyy-MM-dd hh24:mi:ss') AND "SWU"."QUAY_WORK_TIME"<=TO_DATE('2024-11-08','yyyy-MM-dd
              hh24:mi:ss'))
  27 - filter("SV"."FACILITY_ID"='NKGLT')


133 rows selected.

old   3: sql_id => '&sql_id',
new   3: sql_id => '5jxx2dzgn405h',
SQL Monitoring Report

SQL Text
------------------------------
SELECT /*+monitor test111*/ SV.SHIP_VISIT_NO SHIP_VISIT_NO, SV.SHIP_USE_TYPE SHIP_USE_TYPE, SSD.SHIP_NAME, SV.BERTH_CODE, SV.EX_CARGO_WGT, SV.SHIP_LINE_CODE, SV.TRANSPORT_WAY, (SELECT NAME FROM SYS_CODE WHERE SYS_CODE.CODE = TRANSPORT_WAY AND CATEGORY_CODE = 'TRANSPORT_WAY' AND FACILITY_ID = 'NKGLT') TRANS_NAME, SV.TRADE_TYPE, (SELECT NAME FROM SYS_CODE WHERE SYS_CODE.CODE = SV.TRADE_TYPE AND CATEGORY_CODE = 'TRADE_TYPE' AND FACILITY_ID = 'NKGLT') TRADE_NAME, IM_VOYAGE, EX_VOYAGE,
SV.FROM_PORT_CODE, (SELECT PORT_NAME FROM SBC_PORT WHERE PORT_CODE = SV.FROM_PORT_CODE AND FACILITY_ID = 'NKGLT') FROM_NAME, SV.TO_PORT_CODE, (SELECT PORT_NAME FROM SBC_PORT WHERE PORT_CODE = SV.TO_PORT_CODE AND FACILITY_ID = 'NKGLT') TO_NAME, TO_CHAR (NVL (SV.DTA, SV.ETA), 'DD') SHIP_LINE, NVL (DTA, ETA) PLAN_ETB, SV.RTB, SV.LOAD_BEGIN_TIME, LOAD_END_TIME, DISC_BEGIN_TIME, DISC_END_TIME, SV.RTD, (SELECT MAX (NVL (SBS.ETU, WC.ETU)) FROM WORK_CARRIER WC, SHIP_BERTHPLAN_SORT SBS WHERE
WC.CARRIER_VISIT_NO = SV.SHIP_VISIT_NO AND WC.CARRIER_VISIT_NO = SBS.SHIP_VISIT_NO AND WC.FACILITY_ID = SBS.FACILITY_ID AND WC.FACILITY_ID = 'NKGLT') PLAN_ETU, NVL ( SUM ( CASE WHEN UNIT_SIZE_CODE <= '20' AND EMPTY_FULL_MARK = 'E' AND IMP_EXP_MARK = 'I' THEN 1 ELSE 0 END), 0) I_E_20, NVL ( SUM ( CASE WHEN UNIT_SIZE_CODE > '20' AND UNIT_SIZE_CODE <= '40' AND EMPTY_FULL_MARK = 'E' AND IMP_EXP_MARK = 'I' THEN 1 ELSE 0 END), 0) I_E_40, NVL ( SUM ( CASE WHEN UNIT_SIZE_CODE > '40' AND UNIT_SIZE_CODE
<= '45' AND EMPTY_FULL_MARK = 'E' AND IMP_EXP_MARK = 'I' THEN 1 ELSE 0 END), 0) I_E_45, NVL ( SUM ( CASE WHEN UNIT_SIZE_CODE <= '20' AND EMPTY_FULL_MARK = 'F' AND IMP_EXP_MARK = 'I' THEN 1 ELSE 0 END), 0) I_F_20, NVL ( SUM ( CASE WHEN UNIT_SIZE_CODE > '20' AND UNIT_SIZE_CODE <= '40' AND EMPTY_FULL_MARK = 'F' AND IMP_EXP_MARK = 'I' THEN 1 ELSE 0 END), 0) I_F_40, NVL ( SUM ( CASE WHEN UNIT_SIZE_CODE > '40' AND UNIT_SIZE_CODE <= '45' AND EMPTY_FULL_MARK = 'F' AND IMP_EXP_MARK = 'I' THEN 1 ELSE 0
END), 0) I_F_45, NVL ( SUM ( CASE WHEN UNIT_SIZE_CODE <= '20' AND EMPTY_FULL_MARK = 'E' AND IMP_EXP_MARK = 'E' THEN 1 ELSE 0 END), 0) E_E_20, NVL ( SUM ( CASE WHEN UNIT_SIZE_CODE > 20 AND UNIT_SIZE_CODE <= '40' AND EMPTY_FULL_MARK = 'E' AND IMP_EXP_MARK = 'E' THEN 1 ELSE 0 END), 0) E_E_40, NVL ( SUM ( CASE WHEN UNIT_SIZE_CODE > 40 AND UNIT_SIZE_CODE <= '45' AND EMPTY_FULL_MARK = 'E' AND IMP_EXP_MARK = 'E' THEN 1 ELSE 0 END), 0) E_E_45, NVL ( SUM ( CASE WHEN UNIT_SIZE_CODE <= '20' AND
EMPTY_FULL_MARK = 'F' AND IMP_EXP_MARK = 'E' THEN 1 ELSE 0 END), 0) E_F_20, NVL ( SUM ( CASE WHEN UNIT_SIZE_CODE > '20' AND UNIT_SIZE_CODE <= '40' AND EMPTY_FULL_MARK = 'F' AND IMP_EXP_MARK = 'E' THEN 1 ELSE 0 END), 0) E_F_40, NVL ( SUM ( CASE WHEN UNIT_SIZE_CODE > '40' AND UNIT_SIZE_CODE <= '45' AND EMPTY_FULL_MARK = 'F' AND IMP_EXP_MARK = 'E' THEN 1 ELSE 0 END), 0) E_F_45, SUM ( CASE WHEN IMP_EXP_MARK = 'I' THEN F_GET_TEU (UNIT_SIZE_CODE) ELSE 0 END) I_TEU, SUM ( CASE WHEN IMP_EXP_MARK = 'E'
THEN F_GET_TEU (UNIT_SIZE_CODE) ELSE 0 END) E_TEU, SUM (F_GET_TEU (UNIT_SIZE_CODE)) TEU, TEU_QTY, SUM ( CASE WHEN IMP_EXP_MARK = 'E' THEN F_GET_TEU (UNIT_SIZE_CODE) ELSE 0 END) / TEU_QTY E_LOAD_RATE, SUM ( CASE WHEN IMP_EXP_MARK = 'I' THEN F_GET_TEU (UNIT_SIZE_CODE) ELSE 0 END) / TEU_QTY I_LOAD_RATE, ELEC_PILE_MARK, MIN (CASE WHEN IMP_EXP_MARK = 'I' THEN QUAY_WORK_TIME END) MIN_I_WORK_TIME, MIN (CASE WHEN IMP_EXP_MARK = 'E' THEN QUAY_WORK_TIME END) MIN_E_WORK_TIME, MAX (CASE WHEN IMP_EXP_MARK =
'I' THEN QUAY_WORK_TIME END) MAX_I_WORK_TIME, MAX (CASE WHEN IMP_EXP_MARK = 'E' THEN QUAY_WORK_TIME END) MAX_E_WORK_TIME, MIN (QUAY_WORK_TIME) MIN_WORK_TIME, MAX (QUAY_WORK_TIME) MAX_WORK_TIME, SV.SERVICE_CODE, SSS.SERVICE_NAME, SHIP_COURSE_CODE, (SELECT SHIP_COURSE_NAME FROM SBC_SHIP_COURSE SSC WHERE SSC.SHIP_COURSE_CODE = SSS.SHIP_COURSE_CODE AND SSC.FACILITY_ID = 'NKGLT') SHIP_COURSE_NAME FROM SHIP_VISIT SV, SHIP_WORK_UNIT SWU, SBC_SHIP_SERVICE SSS, SBC_SHIP_DATA SSD WHERE SWU.SHIP_VISIT_NO
= SV.SHIP_VISIT_NO AND SV.SHIP_CODE = SSD.SHIP_CODE AND SV.FACILITY_ID = SSD.FACILITY_ID AND SV.SERVICE_CODE = SSS.SERVICE_CODE(+) AND NVL (ROLLBACK_MARK, '0') <> '1' AND SV.FACILITY_ID = 'NKGLT' AND SWU.QUAY_WORK_TIME >= TO_DATE ( '2024-11-01', 'yyyy-MM-dd hh24:mi:ss') AND SWU.QUAY_WORK_TIME <= TO_DATE ( '2024-11-08', 'yyyy-MM-dd hh24:mi:ss') AND NVL (SWU.IMIT_MARK, '0') = '0' GROUP BY SV.SHIP_VISIT_NO, SSD.SHIP_NAME, SV.BERTH_CODE, SV.SHIP_LINE_CODE, SV.TRANSPORT_WAY, SV.SHIP_USE_TYPE,
SV.TRADE_TYPE, IM_VOYAGE, EX_VOYAGE, SV.FROM_PORT_CODE, SV.TO_PORT_CODE, TO_CHAR (NVL (SV.DTA, SV.ETA), 'DD'), NVL (DTA, ETA), SV.RTB, LOAD_BEGIN_TIME, LOAD_END_TIME, DISC_BEGIN_TIME, DISC_END_TIME, SV.RTD, TEU_QTY, ELEC_PILE_MARK, SV.SERVICE_CODE, SSS.SERVICE_NAME, SV.EX_CARGO_WGT, SHIP_COURSE_CODE

Global Information
------------------------------
 Status              :  DONE (ALL ROWS)
 Instance ID         :  1
 Session             :  SYS (579:61653)
 SQL ID              :  5jxx2dzgn405h
 SQL Execution ID    :  16777216
 Execution Started   :  01/22/2025 14:52:53
 First Refresh Time  :  01/22/2025 14:52:53
 Last Refresh Time   :  01/22/2025 14:52:55
 Duration            :  2s
 Module/Action       :  sqlplus@ljrac1 (TNS V1-V3)/-
 Service             :  SYS$USERS
 Program             :  sqlplus@ljrac1 (TNS V1-V3)
 Fetch Calls         :  20

Global Stats
===========================================================
| Elapsed |   Cpu   | PL/SQL  |  Other   | Fetch | Buffer |
| Time(s) | Time(s) | Time(s) | Waits(s) | Calls |  Gets  |
===========================================================
|    2.22 |    2.20 |    0.04 |     0.01 |    20 |   377K |
===========================================================

SQL Plan Monitoring Details (Plan Hash Value=938028027)
========================================================================================================================================================================================
| Id |                     Operation                     |             Name             |  Rows   | Cost  |   Time    | Start  | Execs |   Rows   |  Mem  | Activity | Activity Detail |
|    |                                                   |                              | (Estim) |       | Active(s) | Active |       | (Actual) | (Max) |   (%)    |  (# samples)   |
========================================================================================================================================================================================
|  0 | SELECT STATEMENT                                  |                              |         |       |         2 |     +0 |     5 |        5 |     . |          |        |
|  1 |   TABLE ACCESS BY INDEX ROWID BATCHED             | SYS_CODE                     |       1 |     4 |         2 |     +0 |     5 |        5 |     . |          |        |
|  2 |    INDEX SKIP SCAN                                | IDX_SYS_CODE                 |       1 |     3 |         2 |     +0 |     5 |        5 |     . |          |        |
|  3 |   TABLE ACCESS BY INDEX ROWID BATCHED             | SYS_CODE                     |       1 |     3 |         1 |     +0 |     2 |        2 |     . |          |        |
|  4 |    INDEX SKIP SCAN                                | IDX_SYS_CODE                 |       1 |     2 |         1 |     +0 |     2 |        2 |     . |          |        |
|  5 |   TABLE ACCESS BY INDEX ROWID BATCHED             | SBC_PORT                     |       1 |     2 |         3 |     +0 |    48 |       48 |     . |          |        |
|  6 |    INDEX SKIP SCAN                                | IDX_SBC_PORT_AUTH            |       1 |     1 |         3 |     +0 |    48 |       48 |     . |          |        |
|  7 |   TABLE ACCESS BY INDEX ROWID BATCHED             | SBC_PORT                     |       1 |     2 |         3 |     +0 |    55 |       55 |     . |          |        |
|  8 |    INDEX SKIP SCAN                                | IDX_SBC_PORT_AUTH            |       1 |     1 |         3 |     +0 |    55 |       55 |     . |          |        |
|  9 |   SORT AGGREGATE                                  |                              |       1 |       |         3 |     +0 |   283 |      283 |     . |          |        |
| 10 |    HASH JOIN                                      |                              |       1 |  1324 |         3 |     +0 |   283 |      456 | 417KB |          |        |
| 11 |     TABLE ACCESS BY INDEX ROWID                   | SHIP_BERTHPLAN_SORT          |       1 |     2 |         3 |     +0 |   283 |      260 |     . |          |        |
| 12 |      INDEX UNIQUE SCAN                            | IDX_SHIP_BERTHPLAN_SORT      |       1 |     1 |         3 |     +0 |   283 |      260 |     . |          |        |
| 13 |     TABLE ACCESS BY INDEX ROWID BATCHED           | WORK_CARRIER                 |       2 |  1322 |         3 |     +0 |   260 |      456 |     . |          |        |
| 14 |      INDEX SKIP SCAN                              | WORKCARRIER_SHIP_WORK_UNIQUE |       2 |  1320 |         3 |     +0 |   260 |      456 |     . |          |        |
| 15 |   TABLE ACCESS BY INDEX ROWID BATCHED             | SBC_SHIP_COURSE              |       1 |     2 |         2 |     +0 |     9 |        9 |     . |          |        |
| 16 |    INDEX RANGE SCAN                               | IDX_SBC_SHIP_COURSE_AUTH     |       1 |     1 |         2 |     +0 |     9 |        9 |     . |          |        |
| 17 |   HASH GROUP BY                                   |                              |   34097 |   38M |         3 |     +0 |     1 |      283 |   3MB |          |        |
| 18 |    FILTER                                         |                              |         |       |         1 |     +0 |     1 |    39731 |     . |          |        |
| 19 |     HASH JOIN                                     |                              |   34097 | 17119 |         1 |     +0 |     1 |    39731 |   1MB |          |        |
| 20 |      TABLE ACCESS FULL                            | SBC_SHIP_DATA                |    2529 |    27 |         1 |     +0 |     1 |     2559 |     . |          |        |
| 21 |      HASH JOIN RIGHT OUTER                        |                              |   34068 | 17092 |         1 |     +0 |     1 |    39731 |   2MB |          |        |
| 22 |       TABLE ACCESS FULL                           | SBC_SHIP_SERVICE             |      33 |     4 |         1 |     +0 |     1 |       33 |     . |          |        |
| 23 |       HASH JOIN                                   |                              |   34068 | 17088 |         1 |     +0 |     1 |    39731 |   5MB |          |        |
| 24 |        PARTITION RANGE ITERATOR                   |                              |   34068 | 15719 |         1 |     +0 |     1 |    39731 |     . |          |        |
| 25 |         TABLE ACCESS BY LOCAL INDEX ROWID BATCHED | SHIP_WORK_UNIT               |   34068 | 15719 |         1 |     +0 |     1 |    39731 |     . |          |        |
| 26 |          INDEX RANGE SCAN                         | IDX_SHIP_WORK_UNIT_04        |   34078 |    95 |         1 |     +0 |     1 |    39732 |     . |          |        |
| 27 |        TABLE ACCESS FULL                          | SHIP_VISIT                   |   78838 |  1369 |         1 |     +0 |     1 |    79216 |     . |          |        |
========================================================================================================================================================================================



SQL> @tabinfo.sql
Enter value for sql_id: 5jxx2dzgn405h
old  12:   where sql_id = '&&sql_id'
new  12:   where sql_id = '5jxx2dzgn405h'
old  21:   where a.sql_id = '&&sql_id'
new  21:   where a.sql_id = '5jxx2dzgn405h'
================================================================================================
TOTAL INFO:
================================================================================================


TABLE_OWNER                   TABLE_NAME                      TABLESPACE_NAME
---------------------------   ------------------------------  ----------------
CITOS                         SBC_PORT                        NKGLTTOS_SPA
CITOS                         SBC_SHIP_COURSE                 NKGLTTOS_SPA
CITOS                         SBC_SHIP_DATA                   NKGLTTOS_SPA
CITOS                         SBC_SHIP_SERVICE                NKGLTTOS_SPA
CITOS                         SHIP_BERTHPLAN_SORT             NKGLTTOS_SPA
CITOS                         SHIP_VISIT                      NKGLTTOS_SPA
CITOS                         SHIP_WORK_UNIT
CITOS                         SYS_CODE                        NKGLTTOS_SPA
CITOS                         WORK_CARRIER                    NKGLTTOS_SPA


total tables: 9 rows selected!


*******************************************************
*TABLE CITOS.SBC_PORT info:
*******************************************************
================================================================================================
TABLE CITOS.SBC_PORT partition info:
================================================================================================


        Table CITOS.SBC_PORT not partition table!


================================================================================================
TABLE CITOS.SBC_PORT index info:
================================================================================================


TABLE_OWNER              TABLE_NAME                    INDEX_OWNER                   PARTITION##UNIQUE##TBSNAME##NUM_ROWS##LEAF_BLKS   INDEX_NAME                           INDEX_COLUMN_LIST
----------------------   ---------------------------   ----------------------------- ------------------------------------------------  ----------------------------------
-----------------------------------------------------
CITOS                    SBC_PORT                      CITOS                         NO##UNIQUE##NKGLTTOS_SPA##223##2                  PK_SBC_PORT                          PORT_ID
CITOS                    SBC_PORT                      CITOS                         NO##NONUNIQUE##NKGLTTOS_SPA##223##1               IDX_SBC_PORT_AUTH                    CODES_SET_CODE,PORT_CODE


INDEX EXPRESSIONS:
INDEX_NAME                    COLUMN_EXPRESSION                       COLUMN_POSITION
--------------------------    -------------------------------------   ------------------


================================================================================================
TABLE CITOS.SBC_PORT statistics:
================================================================================================


TABLE CITOS.SBC_PORT tab statistics:
OWNER           TABLE_NAME                    PARTITION_NAME  OBJECT_TYPE     NUM_ROWS        SAMPLE_SIZE     BLOCKS          EMPTY_BLOCKS   AVG_ROW_LEN     STALE  LOCKED  LAST_ANALYZED
--------------- ----------------------------- --------------- --------------  --------------  --------------  --------------  -------------  --------------- ------ ------- -----------------
CITOS           SBC_PORT                                      TABLE           223             223             8               0               134             NO           20250121 22:02:18


TABLE CITOS.SBC_PORT col statistics:
COLUMN_NAME             DATA_TYPE   NULLABLE  NUM_DISTINCT    DENSITY         NUM_NULLS       SAMPLE_SIZE    HISTOGRAM       LAST_ANALYZED
----------------------  ----------  --------  --------------  -------------   --------------  -------------  --------------  -------------------
PSN_DCLR_MARK           VARCHAR2    N         2               .5              0               223             NONE            20250121 22:02:18
PORT_ID                 VARCHAR2    N         223             .002242         0               223             FREQUENCY       20250121 22:02:18
CODES_SET_CODE          VARCHAR2    N         1               1               0               223             NONE            20250121 22:02:18
PORT_CODE               VARCHAR2    N         223             .002242         0               223             FREQUENCY       20250121 22:02:18
PORT_NAME               VARCHAR2    N         213             .002242         0               223             FREQUENCY       20250121 22:02:18
ENGLISH_NAME            VARCHAR2    Y         206             .004854         13              210             NONE            20250121 22:02:18
SHORTEN_NAME            VARCHAR2    Y         168             .005952         30              193             NONE            20250121 22:02:18
MNEMONIC_CODE           VARCHAR2    Y         23              .043478         200             23              NONE            20250121 22:02:18
PORT_CLASS_CODE         VARCHAR2    Y         7               .142857         0               223             NONE            20250121 22:02:18
EPIDEMIC_AREA_TYPES     VARCHAR2    Y         0               0               223                             NONE            20250121 22:02:18
COUNTRY_CODE            VARCHAR2    N         14              .002242         0               223             FREQUENCY       20250121 22:02:18
CONTINENT_CODE          VARCHAR2    Y         3               .333333         0               223             NONE            20250121 22:02:18
SORT_NO                 NUMBER      Y         1               1               129             94              NONE            20250121 22:02:18
HARDCODED_MARK          VARCHAR2    N         1               1               0               223             NONE            20250121 22:02:18
USING_STATE             VARCHAR2    N         3               .002242         0               223             FREQUENCY       20250121 22:02:18
NOTES                   VARCHAR2    Y         25              .04             188             35              NONE            20250121 22:02:18
FACILITY_ID             VARCHAR2    N         1               .002242         0               223             FREQUENCY       20250121 22:02:18
CREATOR                 VARCHAR2    N         7               .142857         0               223             NONE            20250121 22:02:18
CREATED_ON              TIMESTAMP(6)N         95              .002242         0               223             FREQUENCY       20250121 22:02:18
CHANGER                 VARCHAR2    N         10              .1              0               223             NONE            20250121 22:02:18
CHANGED_ON              TIMESTAMP(6)N         160             .002242         0               223             FREQUENCY       20250121 22:02:18
WATER_GATE_MARK         VARCHAR2    N         2               .5              0               223             NONE            20250121 22:02:18


*******************************************************
*TABLE CITOS.SBC_SHIP_COURSE info:
*******************************************************
================================================================================================
TABLE CITOS.SBC_SHIP_COURSE partition info:
================================================================================================


        Table CITOS.SBC_SHIP_COURSE not partition table!


================================================================================================
TABLE CITOS.SBC_SHIP_COURSE index info:
================================================================================================


TABLE_OWNER              TABLE_NAME                    INDEX_OWNER                   PARTITION##UNIQUE##TBSNAME##NUM_ROWS##LEAF_BLKS   INDEX_NAME                           INDEX_COLUMN_LIST
----------------------   ---------------------------   ----------------------------- ------------------------------------------------  ----------------------------------
-----------------------------------------------------
CITOS                    SBC_SHIP_COURSE               CITOS                         NO##UNIQUE##NKGLTTOS_SPA##17##1                   PK_SBC_SHIP_COURSE                   SHIP_COURSE_ID
CITOS                    SBC_SHIP_COURSE               CITOS                         NO##NONUNIQUE##NKGLTTOS_SPA##17##1                IDX_SBC_SHIP_COURSE_AUTH
FACILITY_ID,CODES_SET_CODE,SHIP_COURSE_CODE


INDEX EXPRESSIONS:
INDEX_NAME                    COLUMN_EXPRESSION                       COLUMN_POSITION
--------------------------    -------------------------------------   ------------------


================================================================================================
TABLE CITOS.SBC_SHIP_COURSE statistics:
================================================================================================


TABLE CITOS.SBC_SHIP_COURSE tab statistics:
OWNER           TABLE_NAME                    PARTITION_NAME  OBJECT_TYPE     NUM_ROWS        SAMPLE_SIZE     BLOCKS          EMPTY_BLOCKS   AVG_ROW_LEN     STALE  LOCKED  LAST_ANALYZED
--------------- ----------------------------- --------------- --------------  --------------  --------------  --------------  -------------  --------------- ------ ------- -----------------
CITOS           SBC_SHIP_COURSE                               TABLE           17              17              8               0               118             NO           20241206 22:00:51


TABLE CITOS.SBC_SHIP_COURSE col statistics:
COLUMN_NAME             DATA_TYPE   NULLABLE  NUM_DISTINCT    DENSITY         NUM_NULLS       SAMPLE_SIZE    HISTOGRAM       LAST_ANALYZED
----------------------  ----------  --------  --------------  -------------   --------------  -------------  --------------  -------------------
SORT_NO                 NUMBER      Y         0               0               17                              NONE            20241206 22:00:51
HARDCODED_MARK          VARCHAR2    N         1               1               0               17              NONE            20241206 22:00:51
USING_STATE             VARCHAR2    N         2               .029412         0               17              FREQUENCY       20241206 22:00:51
NOTES                   VARCHAR2    Y         0               0               17                              NONE            20241206 22:00:51
FACILITY_ID             VARCHAR2    N         1               .029412         0               17              FREQUENCY       20241206 22:00:51
CREATOR                 VARCHAR2    N         4               .25             0               17              NONE            20241206 22:00:51
CREATED_ON              TIMESTAMP(6)N         17              .058824         0               17              NONE            20241206 22:00:51
CHANGER                 VARCHAR2    N         4               .25             0               17              NONE            20241206 22:00:51
CHANGED_ON              TIMESTAMP(6)N         17              .058824         0               17              NONE            20241206 22:00:51
CONTINENT_CODE          VARCHAR2    Y         0               0               17                              NONE            20241206 22:00:51
SHIP_COURSE_ID          VARCHAR2    N         17              .058824         0               17              NONE            20241206 22:00:51
CODES_SET_CODE          VARCHAR2    N         1               1               0               17              NONE            20241206 22:00:51
SHIP_COURSE_CODE        VARCHAR2    N         17              .029412         0               17              FREQUENCY       20241206 22:00:51
SHIP_COURSE_NAME        VARCHAR2    N         17              .029412         0               17              FREQUENCY       20241206 22:00:51
ENGLISH_NAME            VARCHAR2    Y         17              .058824         0               17              NONE            20241206 22:00:51


*******************************************************
*TABLE CITOS.SBC_SHIP_DATA info:
*******************************************************
================================================================================================
TABLE CITOS.SBC_SHIP_DATA partition info:
================================================================================================


        Table CITOS.SBC_SHIP_DATA not partition table!


================================================================================================
TABLE CITOS.SBC_SHIP_DATA index info:
================================================================================================


TABLE_OWNER              TABLE_NAME                    INDEX_OWNER                   PARTITION##UNIQUE##TBSNAME##NUM_ROWS##LEAF_BLKS   INDEX_NAME                           INDEX_COLUMN_LIST
----------------------   ---------------------------   ----------------------------- ------------------------------------------------  ----------------------------------
-----------------------------------------------------
CITOS                    SBC_SHIP_DATA                 CITOS                         NO##UNIQUE##NKGLTTOS_SPA##2529##21                PK_SBC_SHIP_DATA                     SHIP_ID
CITOS                    SBC_SHIP_DATA                 CITOS                         NO##UNIQUE##NKGLTTOS_SPA##2529##10                IDX_SBC_SHIP_DATA_UNIQUE
SHIP_CODE,FACILITY_ID,CODES_SET_CODE


INDEX EXPRESSIONS:
INDEX_NAME                    COLUMN_EXPRESSION                       COLUMN_POSITION
--------------------------    -------------------------------------   ------------------


================================================================================================
TABLE CITOS.SBC_SHIP_DATA statistics:
================================================================================================


TABLE CITOS.SBC_SHIP_DATA tab statistics:
OWNER           TABLE_NAME                    PARTITION_NAME  OBJECT_TYPE     NUM_ROWS        SAMPLE_SIZE     BLOCKS          EMPTY_BLOCKS   AVG_ROW_LEN     STALE  LOCKED  LAST_ANALYZED
--------------- ----------------------------- --------------- --------------  --------------  --------------  --------------  -------------  --------------- ------ ------- -----------------
CITOS           SBC_SHIP_DATA                                 TABLE           2529            2529            95              0               244             NO           20241214 09:45:18


TABLE CITOS.SBC_SHIP_DATA col statistics:
COLUMN_NAME             DATA_TYPE   NULLABLE  NUM_DISTINCT    DENSITY         NUM_NULLS       SAMPLE_SIZE    HISTOGRAM       LAST_ANALYZED
----------------------  ----------  --------  --------------  -------------   --------------  -------------  --------------  -------------------
CHANGER                 VARCHAR2    N         56              .017857         0               2529            NONE            20241214 09:45:18
CHANGED_ON              TIMESTAMP(6)N         2487            .000399         0               2529            HYBRID          20241214 09:45:18
AGENT_EMAIL_ADDRESS     VARCHAR2    Y         34              .029412         2187            342             NONE            20241214 09:45:18
SAFE_DISTANCE_TYPE      VARCHAR2    Y         2               .5              1480            1049            NONE            20241214 09:45:18
SAFE_DISTANCE           NUMBER      Y         10              .1              1506            1023            NONE            20241214 09:45:18
ELEC_PILE_MARK          VARCHAR2    Y         1               1               5               2524            NONE            20241214 09:45:18
VIRTUAL_SHIP_MARK       VARCHAR2    Y         2               .0125           2489            40              FREQUENCY       20241214 09:45:18
UNION_SHIP_MARK         VARCHAR2    Y         2               .000226         319             2210            FREQUENCY       20241214 09:45:18
SHIP_ID                 VARCHAR2    N         2529            .000395         0               2529            HYBRID          20241214 09:45:18
CODES_SET_CODE          VARCHAR2    N         1               1               0               2529            NONE            20241214 09:45:18
SHIP_CODE               VARCHAR2    N         2529            .000395         0               2529            HYBRID          20241214 09:45:18
SHIP_NAME               VARCHAR2    N         2522            .000396         0               2529            HYBRID          20241214 09:45:18
ENGLISH_NAME            VARCHAR2    Y         2027            .000493         487             2042            HYBRID          20241214 09:45:18
SHORTEN_NAME            VARCHAR2    Y         1124            .00089          1402            1127            NONE            20241214 09:45:18
MNEMONIC_CODE           VARCHAR2    Y         692             .001445         1835            694             NONE            20241214 09:45:18
SHIP_USE_TYPE           VARCHAR2    N         12              .083333         0               2529            NONE            20241214 09:45:18
SHIP_TYPE_CODE          VARCHAR2    N         3               .000198         0               2529            FREQUENCY       20241214 09:45:18
CARGO_CATEGORY_CODE     VARCHAR2    N         2               .000198         0               2529            FREQUENCY       20241214 09:45:18
SHIP_CLASS_CODE         VARCHAR2    Y         105             .003704         2394            135             FREQUENCY       20241214 09:45:18
BUILD_DATE              TIMESTAMP(6)Y         30              .033333         2498            31              NONE            20241214 09:45:18
SHIP_CALL               VARCHAR2    Y         176             .002674         2342            187             FREQUENCY       20241214 09:45:18
SHIP_IMO                VARCHAR2    Y         1235            .000779         1183            1346            HYBRID          20241214 09:45:18
SHIP_MMSI               VARCHAR2    N         2515            .000398         0               2529            HYBRID          20241214 09:45:18
SHIP_MSA                VARCHAR2    Y         162             .006173         2364            165             NONE            20241214 09:45:18
SHIP_OWNER_CODE         VARCHAR2    Y         185             .000424         1349            1180            FREQUENCY       20241214 09:45:18
COUNTRY_CODE            VARCHAR2    Y         19              .052632         1503            1026            NONE            20241214 09:45:18
SHIP_LINE_CODE          VARCHAR2    Y         139             .000371         1181            1348            FREQUENCY       20241214 09:45:18
SHIP_AGENT_CODE         VARCHAR2    Y         87              .000373         1189            1340            FREQUENCY       20241214 09:45:18
SERVICE_CODE            VARCHAR2    Y         18              .055556         2374            155             NONE            20241214 09:45:18
SHIP_CAPTAIN            VARCHAR2    Y         76              .013158         2452            77              NONE            20241214 09:45:18
SHIP_CAPTAIN_CONTACT    VARCHAR2    Y         1292            .000774         1174            1355            NONE            20241214 09:45:18
SHIP_CHIEF              VARCHAR2    Y         7               .142857         2522            7               NONE            20241214 09:45:18
SHIP_CHIEF_CONTACT      VARCHAR2    Y         110             .009091         2418            111             NONE            20241214 09:45:18
AGENT_CONTACT           VARCHAR2    Y         174             .005747         1863            666             NONE            20241214 09:45:18
LINER_MARK              VARCHAR2    N         2               .5              0               2529            NONE            20241214 09:45:18
EMAIL_ADDRESS           VARCHAR2    Y         105             .009524         2405            124             NONE            20241214 09:45:18
SAFE_EXPIRE_TIME        TIMESTAMP(6)Y         0               0               2529                            NONE            20241214 09:45:18
SHIP_LENGTH             NUMBER      N         566             .001767         0               2529            NONE            20241214 09:45:18
SHIP_WIDTH              NUMBER      Y         241             .004149         1046            1483            NONE            20241214 09:45:18
SHIP_HIGH               NUMBER      Y         172             .005814         1324            1205            NONE            20241214 09:45:18
SHIP_SPEED              NUMBER      Y         25              .04             1408            1121            NONE            20241214 09:45:18
SHIP_GROSS_WGT          NUMBER      N         1207            .000829         0               2529            NONE            20241214 09:45:18
SHIP_NET_WGT            NUMBER      N         1134            .000882         0               2529            NONE            20241214 09:45:18
SHIP_DEAD_WGT           NUMBER      Y         819             .001107         1088            1441            HYBRID          20241214 09:45:18
TEU_QTY                 NUMBER      Y         325             .003077         1156            1373            NONE            20241214 09:45:18
MAX_LOADING_QTY         NUMBER      Y         130             .007692         2158            371             NONE            20241214 09:45:18
BAY_QTY                 NUMBER      Y         24              .041667         1284            1245            NONE            20241214 09:45:18
MAX_ROW_QTY             NUMBER      Y         9               .111111         1304            1225            NONE            20241214 09:45:18
REEFER_PLUG_QTY         NUMBER      Y         22              .045455         1460            1069            NONE            20241214 09:45:18
MAINFRAME_POWER         VARCHAR2    Y         112             .008929         2180            349             NONE            20241214 09:45:18
ASSISTANT_POWER         VARCHAR2    Y         77              .012987         2312            217             NONE            20241214 09:45:18
HATCH_QTY               NUMBER      Y         10              .1              1377            1152            NONE            20241214 09:45:18
HATCH_COVER_QTY         NUMBER      Y         12              .083333         1517            1012            NONE            20241214 09:45:18
EMPTY_BOW_DRAFT         NUMBER      Y         53              .018868         1634            895             NONE            20241214 09:45:18
EMPTY_STERN_DRAFT       NUMBER      Y         4               .25             1672            857             NONE            20241214 09:45:18
FULL_BOW_DRAFT          NUMBER      Y         264             .003788         1460            1069            NONE            20241214 09:45:18
FULL_STERN_DRAFT        NUMBER      Y         6               .166667         1672            857             NONE            20241214 09:45:18
HAVE_CRANE              VARCHAR2    Y         1               1               2463            66              NONE            20241214 09:45:18
CRANE_QTY               NUMBER      Y         1               1               1670            859             NONE            20241214 09:45:18
CRANE_TYPE              VARCHAR2    Y         0               0               2529                            NONE            20241214 09:45:18
CRANE_LOCATION          VARCHAR2    Y         0               0               2529                            NONE            20241214 09:45:18
CRANE_LOAD              VARCHAR2    Y         0               0               2529                            NONE            20241214 09:45:18
WORK_REQUIRES           VARCHAR2    Y         0               0               2529                            NONE            20241214 09:45:18
STOW_REQUIRES           VARCHAR2    Y         0               0               2529                            NONE            20241214 09:45:18
WORK_NOTICE             VARCHAR2    Y         6               .166667         2523            6               NONE            20241214 09:45:18
SHIP_VIP_CLASS          VARCHAR2    Y         0               0               2529                            NONE            20241214 09:45:18
FORBID_MARK             VARCHAR2    Y         0               0               2529                            NONE            20241214 09:45:18
FORBID_EXPIRY_DATE      TIMESTAMP(6)Y         2               .5              2527            2               NONE            20241214 09:45:18
FORBID_TEXT             VARCHAR2    Y         0               0               2529                            NONE            20241214 09:45:18
SORT_NO                 NUMBER      Y         0               0               2529                            NONE            20241214 09:45:18
HARDCODED_MARK          VARCHAR2    N         1               1               0               2529            NONE            20241214 09:45:18
USING_STATE             VARCHAR2    N         3               .000198         0               2529            FREQUENCY       20241214 09:45:18
NOTES                   VARCHAR2    Y         85              .011765         2358            171             NONE            20241214 09:45:18
FACILITY_ID             VARCHAR2    N         1               .000198         0               2529            FREQUENCY       20241214 09:45:18
CREATOR                 VARCHAR2    N         161             .006211         0               2529            NONE            20241214 09:45:18
CREATED_ON              TIMESTAMP(6)N         2161            .000428         0               2529            HYBRID          20241214 09:45:18


*******************************************************
*TABLE CITOS.SBC_SHIP_SERVICE info:
*******************************************************
================================================================================================
TABLE CITOS.SBC_SHIP_SERVICE partition info:
================================================================================================


        Table CITOS.SBC_SHIP_SERVICE not partition table!


================================================================================================
TABLE CITOS.SBC_SHIP_SERVICE index info:
================================================================================================


TABLE_OWNER              TABLE_NAME                    INDEX_OWNER                   PARTITION##UNIQUE##TBSNAME##NUM_ROWS##LEAF_BLKS   INDEX_NAME                           INDEX_COLUMN_LIST
----------------------   ---------------------------   ----------------------------- ------------------------------------------------  ----------------------------------
-----------------------------------------------------
CITOS                    SBC_SHIP_SERVICE              CITOS                         NO##UNIQUE##NKGLTTOS_SPA##33##1                   PK_SBC_SHIP_SERVICE                  SERVICE_ID
CITOS                    SBC_SHIP_SERVICE              CITOS                         NO##NONUNIQUE##NKGLTTOS_SPA##33##1                IDX_SBC_SHIP_SERVICE_AUTH
FACILITY_ID,CODES_SET_CODE,SERVICE_CODE


INDEX EXPRESSIONS:
INDEX_NAME                    COLUMN_EXPRESSION                       COLUMN_POSITION
--------------------------    -------------------------------------   ------------------


================================================================================================
TABLE CITOS.SBC_SHIP_SERVICE statistics:
================================================================================================


TABLE CITOS.SBC_SHIP_SERVICE tab statistics:
OWNER           TABLE_NAME                    PARTITION_NAME  OBJECT_TYPE     NUM_ROWS        SAMPLE_SIZE     BLOCKS          EMPTY_BLOCKS   AVG_ROW_LEN     STALE  LOCKED  LAST_ANALYZED
--------------- ----------------------------- --------------- --------------  --------------  --------------  --------------  -------------  --------------- ------ ------- -----------------
CITOS           SBC_SHIP_SERVICE                              TABLE           33              33              8               0               131             NO           20241218 22:03:18


TABLE CITOS.SBC_SHIP_SERVICE col statistics:
COLUMN_NAME             DATA_TYPE   NULLABLE  NUM_DISTINCT    DENSITY         NUM_NULLS       SAMPLE_SIZE    HISTOGRAM       LAST_ANALYZED
----------------------  ----------  --------  --------------  -------------   --------------  -------------  --------------  -------------------
SERVICE_ID              VARCHAR2    N         33              .015152         0               33              FREQUENCY       20241218 22:03:18
CODES_SET_CODE          VARCHAR2    N         1               1               0               33              NONE            20241218 22:03:18
SERVICE_CODE            VARCHAR2    N         33              .015152         0               33              FREQUENCY       20241218 22:03:18
SERVICE_NAME            VARCHAR2    N         32              .015152         0               33              FREQUENCY       20241218 22:03:18
ENGLISH_NAME            VARCHAR2    Y         25              .04             8               25              NONE            20241218 22:03:18
SHORTEN_NAME            VARCHAR2    Y         2               .5              31              2               NONE            20241218 22:03:18
MNEMONIC_CODE           VARCHAR2    Y         0               0               33                              NONE            20241218 22:03:18
SHIP_COURSE_CODE        VARCHAR2    N         15              .066667         0               33              NONE            20241218 22:03:18
SHIP_SERVICE_TYPE       VARCHAR2    Y         5               .015152         0               33              FREQUENCY       20241218 22:03:18
MAIN_LINE_MARK          VARCHAR2    Y         2               .015152         0               33              FREQUENCY       20241218 22:03:18
OCEAN_LINE_MARK         VARCHAR2    Y         2               .015152         0               33              FREQUENCY       20241218 22:03:18
TRADE_TYPE              VARCHAR2    Y         2               .015625         1               32              FREQUENCY       20241218 22:03:18
DEST_PORT_SPECIFIED     VARCHAR2    Y         1               1               0               33              NONE            20241218 22:03:18
SORT_NO                 NUMBER      Y         0               0               33                              NONE            20241218 22:03:18
HARDCODED_MARK          VARCHAR2    N         1               1               0               33              NONE            20241218 22:03:18
USING_STATE             VARCHAR2    N         2               .015152         0               33              FREQUENCY       20241218 22:03:18
NOTES                   VARCHAR2    Y         5               .2              11              22              NONE            20241218 22:03:18
FACILITY_ID             VARCHAR2    N         1               .015152         0               33              FREQUENCY       20241218 22:03:18
CREATOR                 VARCHAR2    N         6               .166667         0               33              NONE            20241218 22:03:18
CREATED_ON              TIMESTAMP(6)N         32              .015152         0               33              FREQUENCY       20241218 22:03:18
CHANGER                 VARCHAR2    N         9               .111111         0               33              NONE            20241218 22:03:18
CHANGED_ON              TIMESTAMP(6)N         33              .015152         0               33              FREQUENCY       20241218 22:03:18


*******************************************************
*TABLE CITOS.SHIP_BERTHPLAN_SORT info:
*******************************************************
================================================================================================
TABLE CITOS.SHIP_BERTHPLAN_SORT partition info:
================================================================================================


        Table CITOS.SHIP_BERTHPLAN_SORT not partition table!


================================================================================================
TABLE CITOS.SHIP_BERTHPLAN_SORT index info:
================================================================================================


TABLE_OWNER              TABLE_NAME                    INDEX_OWNER                   PARTITION##UNIQUE##TBSNAME##NUM_ROWS##LEAF_BLKS   INDEX_NAME                           INDEX_COLUMN_LIST
----------------------   ---------------------------   ----------------------------- ------------------------------------------------  ----------------------------------
-----------------------------------------------------
CITOS                    SHIP_BERTHPLAN_SORT           CITOS                         NO##UNIQUE##NKGLTTOS_SPA##60179##478              SYS_C00137946                        BERTHPLAN_SORT_ID
CITOS                    SHIP_BERTHPLAN_SORT           CITOS                         NO##UNIQUE##NKGLTTOS_SPA##60179##323              IDX_SHIP_BERTHPLAN_SORT              SHIP_VISIT_NO,FACILITY_ID


INDEX EXPRESSIONS:
INDEX_NAME                    COLUMN_EXPRESSION                       COLUMN_POSITION
--------------------------    -------------------------------------   ------------------


================================================================================================
TABLE CITOS.SHIP_BERTHPLAN_SORT statistics:
================================================================================================


TABLE CITOS.SHIP_BERTHPLAN_SORT tab statistics:
OWNER           TABLE_NAME                    PARTITION_NAME  OBJECT_TYPE     NUM_ROWS        SAMPLE_SIZE     BLOCKS          EMPTY_BLOCKS   AVG_ROW_LEN     STALE  LOCKED  LAST_ANALYZED
--------------- ----------------------------- --------------- --------------  --------------  --------------  --------------  -------------  --------------- ------ ------- -----------------
CITOS           SHIP_BERTHPLAN_SORT                           TABLE           60179           60179           1000            0               95              NO           20250114 22:02:05


TABLE CITOS.SHIP_BERTHPLAN_SORT col statistics:
COLUMN_NAME             DATA_TYPE   NULLABLE  NUM_DISTINCT    DENSITY         NUM_NULLS       SAMPLE_SIZE    HISTOGRAM       LAST_ANALYZED
----------------------  ----------  --------  --------------  -------------   --------------  -------------  --------------  -------------------
ETU                     TIMESTAMP(6)Y         45288           .000022         1912            58267           NONE            20250114 22:02:04
BERTHPLAN_SORT_ID       VARCHAR2    N         60179           .000017         0               5368            HYBRID          20250114 22:02:04
SHIP_VISIT_NO           VARCHAR2    N         60179           .000017         0               5368            HYBRID          20250114 22:02:04
BERTHPLAN_SORT_NO       NUMBER      Y         140             .000056         51273           8906            FREQUENCY       20250114 22:02:04
FACILITY_ID             VARCHAR2    Y         1               .000009         0               5366            FREQUENCY       20250114 22:02:04
CREATOR                 VARCHAR2    N         14              .071429         0               60179           NONE            20250114 22:02:04
CREATED_ON              TIMESTAMP(6)N         60048           .000017         0               60179           NONE            20250114 22:02:04
CHANGER                 VARCHAR2    Y         13              .076923         0               60179           NONE            20250114 22:02:04
CHANGED_ON              TIMESTAMP(6)Y         34656           .000029         0               60179           NONE            20250114 22:02:04


*******************************************************
*TABLE CITOS.SHIP_VISIT info:
*******************************************************
================================================================================================
TABLE CITOS.SHIP_VISIT partition info:
================================================================================================


        Table CITOS.SHIP_VISIT not partition table!


================================================================================================
TABLE CITOS.SHIP_VISIT index info:
================================================================================================


TABLE_OWNER              TABLE_NAME                    INDEX_OWNER                   PARTITION##UNIQUE##TBSNAME##NUM_ROWS##LEAF_BLKS   INDEX_NAME                           INDEX_COLUMN_LIST
----------------------   ---------------------------   ----------------------------- ------------------------------------------------  ----------------------------------
-----------------------------------------------------
CITOS                    SHIP_VISIT                    CITOS                         NO##NONUNIQUE##NKGLTTOS_SPA##78842##256           IDX_ETA                              ETA
CITOS                    SHIP_VISIT                    CITOS                         NO##NONUNIQUE##NKGLTTOS_SPA##69919##226           IDX_RTD                              RTD
CITOS                    SHIP_VISIT                    CITOS                         NO##UNIQUE##NKGLTTOS_SPA##78842##783              PK_SHIP_VISIT                        SHIP_VISIT_ID
CITOS                    SHIP_VISIT                    CITOS                         NO##NONUNIQUE##NKGLTTOS_SPA##78842##207           IDX_CREATED_ON                       CREATED_ON
CITOS                    SHIP_VISIT                    CITOS                         NO##UNIQUE##NKGLTTOS_SPA##78842##356              IDX_SHIP_VISIT_NO_UNIQUE             SHIP_VISIT_NO


INDEX EXPRESSIONS:
INDEX_NAME                    COLUMN_EXPRESSION                       COLUMN_POSITION
--------------------------    -------------------------------------   ------------------


================================================================================================
TABLE CITOS.SHIP_VISIT statistics:
================================================================================================


TABLE CITOS.SHIP_VISIT tab statistics:
OWNER           TABLE_NAME                    PARTITION_NAME  OBJECT_TYPE     NUM_ROWS        SAMPLE_SIZE     BLOCKS          EMPTY_BLOCKS   AVG_ROW_LEN     STALE  LOCKED  LAST_ANALYZED
--------------- ----------------------------- --------------- --------------  --------------  --------------  --------------  -------------  --------------- ------ ------- -----------------
CITOS           SHIP_VISIT                                    TABLE           78842           78842           5032            0               480             NO           20250114 22:03:44


TABLE CITOS.SHIP_VISIT col statistics:
COLUMN_NAME             DATA_TYPE   NULLABLE  NUM_DISTINCT    DENSITY         NUM_NULLS       SAMPLE_SIZE    HISTOGRAM       LAST_ANALYZED
----------------------  ----------  --------  --------------  -------------   --------------  -------------  --------------  -------------------
INTERVAL_TYPE           VARCHAR2    Y         1               1               78822           20              NONE            20250114 22:03:42
SYS_NC00142$            RAW         Y         1               1               0               78842           NONE            20250114 22:03:42
SCHEDULE_MARK           VARCHAR2    Y         1               1               72532           6310            NONE            20250114 22:03:42
BERTHPLAN_SORT_NO       NUMBER      Y         0               0               78842                           NONE            20250114 22:03:42
INTERVAL_INST           VARCHAR2    Y         3               .333333         37020           41822           NONE            20250114 22:03:42
CUS_CONFIRM_TIME        TIMESTAMP(6)Y         3121            .00032          75720           3122            NONE            20250114 22:03:42
BERTH_PAYER_CODE        VARCHAR2    Y         101             .000019         52961           25881           FREQUENCY       20250114 22:03:42
ARRIVAL_INSP_BEGIN_TIME TIMESTAMP(6)Y         1056            .000947         77786           1056            NONE            20250114 22:03:42
ARRIVAL_INSP_END_TIME   TIMESTAMP(6)Y         1055            .000948         77787           1055            NONE            20250114 22:03:42
CI_BEGIN_TIME           TIMESTAMP(6)Y         66              .015152         78776           66              NONE            20250114 22:03:42
CI_END_TIME             TIMESTAMP(6)Y         64              .015625         78778           64              NONE            20250114 22:03:42
OTHERS_BEGIN_TIME       TIMESTAMP(6)Y         396             .002525         78446           396             NONE            20250114 22:03:42
OTHERS_END_TIME         TIMESTAMP(6)Y         354             .002825         78488           354             NONE            20250114 22:03:42
WATER_LEVEL_BEGIN_TIME  TIMESTAMP(6)Y         16              .0625           78826           16              NONE            20250114 22:03:42
WATER_LEVEL_END_TIME    TIMESTAMP(6)Y         14              .071429         78828           14              NONE            20250114 22:03:42
SH_TEU                  NUMBER      Y         17              .058824         22151           56691           NONE            20250114 22:03:42
DE20_MOVES              NUMBER      Y         302             .003311         13326           65516           NONE            20250114 22:03:42
DE40_MOVES              NUMBER      Y         333             .003003         13162           65680           NONE            20250114 22:03:42
DE45_MOVES              NUMBER      Y         17              .058824         13598           65244           NONE            20250114 22:03:42
DF20_MOVES              NUMBER      Y         543             .001842         12981           65861           NONE            20250114 22:03:42
DF40_MOVES              NUMBER      Y         202             .00495          13013           65829           NONE            20250114 22:03:42
DF45_MOVES              NUMBER      Y         10              .1              13594           65248           NONE            20250114 22:03:42
LE20_MOVES              NUMBER      Y         336             .002976         13363           65479           NONE            20250114 22:03:42
LE40_MOVES              NUMBER      Y         156             .00641          13211           65631           NONE            20250114 22:03:42
LE45_MOVES              NUMBER      Y         10              .1              13600           65242           NONE            20250114 22:03:42
LF20_MOVES              NUMBER      Y         548             .001825         12541           66301           NONE            20250114 22:03:42
LF40_MOVES              NUMBER      Y         356             .002809         12702           66140           NONE            20250114 22:03:42
LF45_MOVES              NUMBER      Y         13              .076923         13577           65265           NONE            20250114 22:03:42
RE20_MOVES              NUMBER      Y         5               .2              13600           65242           NONE            20250114 22:03:42
RE40_MOVES              NUMBER      Y         11              .090909         13600           65242           NONE            20250114 22:03:42
RE45_MOVES              NUMBER      Y         2               .5              13600           65242           NONE            20250114 22:03:42
RF20_MOVES              NUMBER      Y         12              .083333         13600           65242           NONE            20250114 22:03:42
RF40_MOVES              NUMBER      Y         10              .1              13599           65243           NONE            20250114 22:03:42
RF45_MOVES              NUMBER      Y         1               1               13600           65242           NONE            20250114 22:03:42
SE20_MOVES              NUMBER      Y         7               .142857         13600           65242           NONE            20250114 22:03:42
SE40_MOVES              NUMBER      Y         5               .2              13600           65242           NONE            20250114 22:03:42
SE45_MOVES              NUMBER      Y         3               .333333         13600           65242           NONE            20250114 22:03:42
SF20_MOVES              NUMBER      Y         12              .083333         13599           65243           NONE            20250114 22:03:42
SF40_MOVES              NUMBER      Y         8               .125            13599           65243           NONE            20250114 22:03:42
SF45_MOVES              NUMBER      Y         1               1               13600           65242           NONE            20250114 22:03:42
SORT_NO                 NUMBER      Y         24              .041667         78743           99              NONE            20250114 22:03:42
HARDCODED_MARK          VARCHAR2    N         1               1               0               78842           NONE            20250114 22:03:42
NOTES                   VARCHAR2    Y         26220           .000029         26662           6404            HYBRID          20250114 22:03:42
FACILITY_ID             VARCHAR2    N         1               .000006         0               9637            FREQUENCY       20250114 22:03:42
CREATOR                 VARCHAR2    N         561             .00087          0               9637            HYBRID          20250114 22:03:42
CREATED_ON              TIMESTAMP(6)N         68840           .000014         0               9639            HYBRID          20250114 22:03:42
CHANGER                 VARCHAR2    N         118             .008475         0               78842           NONE            20250114 22:03:42
CHANGED_ON              TIMESTAMP(6)N         75248           .000013         0               9639            HYBRID          20250114 22:03:42
USING_STATE             VARCHAR2    Y         3               .000006         753             78089           FREQUENCY       20250114 22:03:42
SHIP_VIP_CLASS          VARCHAR2    Y         3               .333333         72490           6352            NONE            20250114 22:03:42
SHIP_CLERK_NAME         VARCHAR2    Y         331             .003021         39402           39440           NONE            20250114 22:03:42
SHIP_CLERK_CONTACT      VARCHAR2    Y         701             .001427         42247           36595           NONE            20250114 22:03:42
CHECK_TIME              TIMESTAMP(6)Y         39828           .000025         7689            71153           NONE            20250114 22:03:42
CHECK_PROBLEMS          VARCHAR2    Y         3               .333333         78839           3               NONE            20250114 22:03:42
CHECK_HANDLE_TIME       TIMESTAMP(6)Y         0               0               78842                           NONE            20250114 22:03:42
CHECK_HANDLE_NOTES      VARCHAR2    Y         0               0               78842                           NONE            20250114 22:03:42
SHIP_VISIT_ID           VARCHAR2    N         78842           .000013         0               9638            HYBRID          20250114 22:03:42
SHIP_VISIT_NO           VARCHAR2    N         78842           .000013         0               9639            HYBRID          20250114 22:03:42
SHIP_CODE               VARCHAR2    N         2486            .000328         0               9639            HYBRID          20250114 22:03:42
SHIP_NAME               VARCHAR2    N         2478            .000325         0               9639            HYBRID          20250114 22:03:42
ENGLISH_NAME            VARCHAR2    Y         1510            .000547         8310            8613            HYBRID          20250114 22:03:42
SHIP_USE_TYPE           VARCHAR2    N         12              .000006         0               78842           FREQUENCY       20250114 22:03:42
SHIP_TYPE_CODE          VARCHAR2    N         3               .000006         0               78842           FREQUENCY       20250114 22:03:42
CARGO_CATEGORY_CODE     VARCHAR2    N         2               .000006         0               78842           FREQUENCY       20250114 22:03:42
IM_VOYAGE               VARCHAR2    N         20238           .000049         0               9639            HYBRID          20250114 22:03:42
EX_VOYAGE               VARCHAR2    N         20186           .00005          0               9639            HYBRID          20250114 22:03:42
LAST_PORT_CODE          VARCHAR2    Y         2               .5              78840           2               NONE            20250114 22:03:42
NEXT_PORT_CODE          VARCHAR2    Y         2               .5              78840           2               NONE            20250114 22:03:42
PORT_SEQUENCE           NUMBER      Y         0               0               78842                           NONE            20250114 22:03:42
FROM_PORT_CODE          VARCHAR2    Y         130             .007692         7609            71233           NONE            20250114 22:03:42
TO_PORT_CODE            VARCHAR2    Y         131             .007634         7668            71174           NONE            20250114 22:03:42
LINER_MARK              VARCHAR2    N         2               .5              0               78842           NONE            20250114 22:03:42
CUSTOMS_VISIT_NO        VARCHAR2    Y         0               0               78842                           NONE            20250114 22:03:42
SHIP_LINE_CODE          VARCHAR2    N         126             .000006         0               78842           FREQUENCY       20250114 22:03:42
SHIP_AGENT_CODE         VARCHAR2    Y         99              .000006         1223            77619           FREQUENCY       20250114 22:03:42
TRADE_TYPE              VARCHAR2    N         3               .000006         0               78842           FREQUENCY       20250114 22:03:42
SERVICE_CODE            VARCHAR2    N         30              .000006         0               78842           FREQUENCY       20250114 22:03:42
TRANSPORT_WAY           VARCHAR2    Y         5               .000006         1273            77569           FREQUENCY       20250114 22:03:42
BERTHING_SEQUENCE       NUMBER      Y         1               1               72165           6677            NONE            20250114 22:03:42
SHIP_STATE              VARCHAR2    N         6               .000006         0               78842           FREQUENCY       20250114 22:03:42
SHIP_PROCESS            VARCHAR2    Y         4               .000007         12139           66703           FREQUENCY       20250114 22:03:42
PLAN_BERTHING_MODE      VARCHAR2    Y         2               .5              52091           26751           NONE            20250114 22:03:42
PLAN_BERTH_CODE         VARCHAR2    Y         0               0               78842                           NONE            20250114 22:03:42
PLAN_BEGIN_BOLLARD_CODE VARCHAR2    Y         0               0               78842                           NONE            20250114 22:03:42
PLAN_END_BOLLARD_CODE   VARCHAR2    Y         0               0               78842                           NONE            20250114 22:03:42
PLAN_BEGIN_METER        NUMBER      Y         0               0               78842                           NONE            20250114 22:03:42
PLAN_END_METER          NUMBER      Y         0               0               78842                           NONE            20250114 22:03:42
BERTHING_MODE           VARCHAR2    Y         2               .5              8787            70055           NONE            20250114 22:03:42
BERTH_CODE              VARCHAR2    Y         23              .000008         14660           64182           FREQUENCY       20250114 22:03:42
BEGIN_BOLLARD_CODE      VARCHAR2    Y         111             .000008         14722           64120           FREQUENCY       20250114 22:03:42
END_BOLLARD_CODE        VARCHAR2    Y         115             .000008         14760           64082           FREQUENCY       20250114 22:03:42
BEGIN_METER             NUMBER      Y         1               1               78841           1               NONE            20250114 22:03:42
END_METER               NUMBER      Y         2               .5              78840           2               NONE            20250114 22:03:42
DISTANCE_FROM_DOCK      NUMBER      Y         0               0               78842                           NONE            20250114 22:03:42
ETA                     TIMESTAMP(6)Y         40944           .000024         0               9638            HYBRID          20250114 22:03:42
ETB                     TIMESTAMP(6)Y         2732            .000366         72553           6289            HYBRID          20250114 22:03:42
ETU                     TIMESTAMP(6)Y         1               1               78841           1               NONE            20250114 22:03:42
ETD                     TIMESTAMP(6)Y         1286            .000777         77556           1286            HYBRID          20250114 22:03:42
DTA                     TIMESTAMP(6)Y         10913           .000092         66906           11936           NONE            20250114 22:03:42
DTB                     TIMESTAMP(6)Y         39              .025641         78803           39              NONE            20250114 22:03:42
DTU                     TIMESTAMP(6)Y         32              .03125          78810           32              NONE            20250114 22:03:42
DTD                     TIMESTAMP(6)Y         2               .5              78840           2               NONE            20250114 22:03:42
RTA                     TIMESTAMP(6)Y         64048           .000016         14794           64048           NONE            20250114 22:03:42
RTB                     TIMESTAMP(6)Y         69644           .000014         9198            8500            HYBRID          20250114 22:03:42
RTU                     TIMESTAMP(6)Y         68272           .000015         9391            8488            HYBRID          20250114 22:03:42
RTD                     TIMESTAMP(6)Y         68800           .000015         8923            8531            HYBRID          20250114 22:03:42
ARRIVAL_AOB_MARK        VARCHAR2    Y         1               1               70888           7954            NONE            20250114 22:03:42
DEPART_AOB_MARK         VARCHAR2    Y         1               1               70888           7954            NONE            20250114 22:03:42
ARRIVAL_PILOT_MARK      VARCHAR2    Y         2               .5              14250           64592           NONE            20250114 22:03:42
ARRIVAL_TUGBOAT_QTY     NUMBER      Y         4               .25             24944           53898           NONE            20250114 22:03:42
DEPART_PILOT_MARK       VARCHAR2    Y         2               .5              14253           64589           NONE            20250114 22:03:42
DEPART_TUGBOAT_QTY      NUMBER      Y         4               .25             24945           53897           NONE            20250114 22:03:42
ARRIVAL_BOW_DRAFT       NUMBER      Y         0               0               78842                           NONE            20250114 22:03:42
ARRIVAL_STERN_DRAFT     NUMBER      Y         0               0               78842                           NONE            20250114 22:03:42
ARRIVAL_MIDDLE_DRAFT    NUMBER      Y         0               0               78842                           NONE            20250114 22:03:42
DEPART_BOW_DRAFT        NUMBER      Y         0               0               78842                           NONE            20250114 22:03:42
DEPART_STERN_DRAFT      NUMBER      Y         0               0               78842                           NONE            20250114 22:03:42
DEPART_MIDDLE_DRAFT     NUMBER      Y         0               0               78842                           NONE            20250114 22:03:42
BEGIN_RECEIVE_TIME      TIMESTAMP(6)Y         0               0               78842                           NONE            20250114 22:03:42
END_RECEIVE_TIME        TIMESTAMP(6)Y         0               0               78842                           NONE            20250114 22:03:42
ARRIVAL_POB_TIME        TIMESTAMP(6)Y         0               0               78842                           NONE            20250114 22:03:42
ARRIVAL_GANGWAY_TIME    TIMESTAMP(6)Y         0               0               78842                           NONE            20250114 22:03:42
ARRIVAL_AOB_TIME        TIMESTAMP(6)Y         0               0               78842                           NONE            20250114 22:03:42
ARRIVAL_CBA_TIME        TIMESTAMP(6)Y         0               0               78842                           NONE            20250114 22:03:42
DEPART_AOB_TIME         TIMESTAMP(6)Y         0               0               78842                           NONE            20250114 22:03:42
DEPART_POB_TIME         TIMESTAMP(6)Y         0               0               78842                           NONE            20250114 22:03:42
IM_CUSTOMS_VISIT_NO     VARCHAR2    Y         0               0               78842                           NONE            20250114 22:03:42
IM_SHIP_LINE_CODE       VARCHAR2    Y         106             .009434         13725           65117           NONE            20250114 22:03:42
IM_SHIP_AGENT_CODE      VARCHAR2    Y         78              .012821         13728           65114           NONE            20250114 22:03:42
IM_TRADE_TYPE           VARCHAR2    Y         5               .2              24636           54206           NONE            20250114 22:03:42
IMD_SERVICE_CODE        VARCHAR2    Y         26              .038462         36375           42467           NONE            20250114 22:03:42
IMF_SERVICE_CODE        VARCHAR2    Y         22              .045455         55531           23311           NONE            20250114 22:03:42
IM_TRANSPORT_WAY        VARCHAR2    Y         6               .166667         53521           25321           NONE            20250114 22:03:42
PLAN_DISC_BEGIN_TIME    TIMESTAMP(6)Y         0               0               78842                           NONE            20250114 22:03:42
PLAN_DISC_END_TIME      TIMESTAMP(6)Y         0               0               78842                           NONE            20250114 22:03:42
DISC_BEGIN_TIME         TIMESTAMP(6)Y         52252           .000019         25785           6510            HYBRID          20250114 22:03:42
DISC_END_TIME           TIMESTAMP(6)Y         47248           .000021         31159           47683           NONE            20250114 22:03:42
EX_CUSTOMS_VISIT_NO     VARCHAR2    Y         0               0               78842                           NONE            20250114 22:03:42
EX_SHIP_LINE_CODE       VARCHAR2    Y         106             .009434         13725           65117           NONE            20250114 22:03:42
EX_SHIP_AGENT_CODE      VARCHAR2    Y         78              .012821         13728           65114           NONE            20250114 22:03:42
EX_TRADE_TYPE           VARCHAR2    Y         4               .25             24636           54206           NONE            20250114 22:03:42
EXD_SERVICE_CODE        VARCHAR2    Y         26              .038462         36375           42467           NONE            20250114 22:03:42
EXF_SERVICE_CODE        VARCHAR2    Y         22              .045455         55533           23309           NONE            20250114 22:03:42
EX_TRANSPORT_WAY        VARCHAR2    Y         6               .166667         53521           25321           NONE            20250114 22:03:42
PLAN_LOAD_BEGIN_TIME    TIMESTAMP(6)Y         0               0               78842                           NONE            20250114 22:03:42
PLAN_LOAD_END_TIME      TIMESTAMP(6)Y         0               0               78842                           NONE            20250114 22:03:42
LOAD_BEGIN_TIME         TIMESTAMP(6)Y         45138           .000022         33704           45138           NONE            20250114 22:03:42
LOAD_END_TIME           TIMESTAMP(6)Y         45293           .000022         33549           45293           NONE            20250114 22:03:42
IM_CARGO_TYPES          VARCHAR2    Y         16              .0625           78684           158             NONE            20250114 22:03:42
IM_CARGO_WGT            NUMBER      Y         109             .009174         78683           159             NONE            20250114 22:03:42
EX_CARGO_TYPES          VARCHAR2    Y         21              .047619         78801           41              NONE            20250114 22:03:42
EX_CARGO_WGT            NUMBER      Y         121             .008264         78717           125             NONE            20250114 22:03:42
IM_TEU                  NUMBER      Y         744             .001344         16235           62607           NONE            20250114 22:03:42
EX_TEU                  NUMBER      Y         716             .001397         16235           62607           NONE            20250114 22:03:42
RE_TEU                  NUMBER      Y         15              .066667         22151           56691           NONE            20250114 22:03:42


*******************************************************
*TABLE CITOS.SHIP_WORK_UNIT info:
*******************************************************
================================================================================================
TABLE CITOS.SHIP_WORK_UNIT partition info:
================================================================================================


        Table CITOS.SHIP_WORK_UNIT part_type : RANGE, subpart_type: NONE, part_count: 1048575
        Table:CITOS.SHIP_WORK_UNIT partition key is QUAY_WORK_TIME


================================================================================================
TABLE CITOS.SHIP_WORK_UNIT index info:
================================================================================================


TABLE_OWNER              TABLE_NAME                    INDEX_OWNER                   PARTITION##UNIQUE##TBSNAME##NUM_ROWS##LEAF_BLKS   INDEX_NAME                           INDEX_COLUMN_LIST
----------------------   ---------------------------   ----------------------------- ------------------------------------------------  ----------------------------------
-----------------------------------------------------
CITOS                    SHIP_WORK_UNIT                CITOS                         NO##NONUNIQUE##NKGLTTOS_SPA##5002196##30265       IDX_WORK_SHIFT                       WORK_SHIFT_NO,FACILITY_ID
CITOS                    SHIP_WORK_UNIT                CITOS                         NO##NONUNIQUE##NKGLTTOS_SPA##5213182##24943       SHIP_WORK_UNIT_1
SHIP_VISIT_NO,WORK_TYPE,SYS_NC00128$
CITOS                    SHIP_WORK_UNIT                CITOS                         NO##UNIQUE##NKGLTTOS_SPA##5187636##37318          PK_SHIP_WORK_UNIT                    WORK_UNIT_ID
CITOS                    SHIP_WORK_UNIT                CITOS                         NO##NONUNIQUE##NKGLTTOS_SPA##5284847##37738       IDX_SHIP_WORK_UNIT
SHIP_VISIT_NO,IMP_EXP_MARK,UNIT_VISIT_NO,FACILITY_ID
CITOS                    SHIP_WORK_UNIT                CITOS                         NO##NONUNIQUE##NKGLTTOS_SPA##5161808##37131       IDX_SHIP_WORK_UNIT_02
FACILITY_ID,SHIP_VISIT_NO,IMP_EXP_MARK,UNIT_VISIT_NO
CITOS                    SHIP_WORK_UNIT                CITOS                         NO##NONUNIQUE##NKGLTTOS_SPA##5069843##35232       IDX_SHIP_WORK_UNIT_03                UNIT_NO,SHIP_VISIT_NO
CITOS                    SHIP_WORK_UNIT                CITOS                         YES##NONUNIQUE####5298789##14200                  IDX_SHIP_WORK_UNIT_04                QUAY_WORK_TIME
CITOS                    SHIP_WORK_UNIT                CITOS                         NO##NONUNIQUE##NKGLTTOS_SPA##5213182##16077       IDX_SHIP_WORK_UNIT_05                UNIT_OPERATOR_CODE
CITOS                    SHIP_WORK_UNIT                CITOS                         NO##NONUNIQUE##NKGLTTOS_SPA##5121312##17233       IDX_SHIP_WORK_UNIT_06                SYS_NC00137$ DESC
CITOS                    SHIP_WORK_UNIT                CITOS                         NO##NONUNIQUE##NKGLTTOS_SPA##5213182##21709       SHIP_WORK_UNIT_INDEX1                UNIT_VISIT_NO


INDEX EXPRESSIONS:
INDEX_NAME                    COLUMN_EXPRESSION                       COLUMN_POSITION
--------------------------    -------------------------------------   ------------------
IDX_SHIP_WORK_UNIT_06         "CHANGED_ON"                            1
SHIP_WORK_UNIT_1              NVL("ROLLBACK_MARK",'0')                3


================================================================================================
TABLE CITOS.SHIP_WORK_UNIT statistics:
================================================================================================


TABLE CITOS.SHIP_WORK_UNIT tab statistics:
OWNER           TABLE_NAME                    PARTITION_NAME  OBJECT_TYPE     NUM_ROWS        SAMPLE_SIZE     BLOCKS          EMPTY_BLOCKS   AVG_ROW_LEN     STALE  LOCKED  LAST_ANALYZED
--------------- ----------------------------- --------------- --------------  --------------  --------------  --------------  -------------  --------------- ------ ------- -----------------
CITOS           SHIP_WORK_UNIT                                TABLE           5213176         5213176         408774          0               527             NO           20241206 22:03:31
CITOS           SHIP_WORK_UNIT                P2023           PARTITION       1842371         1842371         142038          0               525             NO           20241204 22:09:23
CITOS           SHIP_WORK_UNIT                SYS_P638803     PARTITION       122213          122213          10097           0               526             NO           20250121 23:39:54
CITOS           SHIP_WORK_UNIT                P2024           PARTITION       1913975         1913975         147396          0               527             NO           20241222 23:54:51
CITOS           SHIP_WORK_UNIT                P2022           PARTITION       1553825         1553825         119340          0               522             NO           20241204 22:09:17


TABLE CITOS.SHIP_WORK_UNIT col statistics:
COLUMN_NAME             DATA_TYPE   NULLABLE  NUM_DISTINCT    DENSITY         NUM_NULLS       SAMPLE_SIZE    HISTOGRAM       LAST_ANALYZED
----------------------  ----------  --------  --------------  -------------   --------------  -------------  --------------  -------------------
TRANSPORT_FEE_ID        VARCHAR2    Y         2               .000001         4346290         866886          FREQUENCY       20241206 22:02:26
LAST_PORT_CODE          VARCHAR2    Y         116             .000001         4319692         893484          FREQUENCY       20241206 22:02:26
SYS_NC00128$            VARCHAR2    Y         2               0               0               5213176         FREQUENCY       20241206 22:02:26
SYS_NC00129$            RAW         Y         1               1               569627          4643549         NONE            20241206 22:02:26
IMIT_MARK               VARCHAR2    Y         2               .000001         4639355         573821          FREQUENCY       20241206 22:02:26
TRADE_ORIGN_TYPE        VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
MV_SEND_MARK            VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
SL_SEND_MARK            VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
DISPATCH_TIME           TIMESTAMP(6)Y         696576          .000001         4365029         848147          NONE            20241206 22:02:26
SYS_FIND_POS            VARCHAR2    Y         146496          .000007         3537789         1675387         NONE            20241206 22:02:26
SYS_FIND_CODE           VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
SYS_NC00137$            RAW         Y         4793856         0               0               6648            HYBRID          20241206 22:02:26
WORK_UNIT_ID            VARCHAR2    N         5213176         0               0               6648            HYBRID          20241206 22:02:26
WORK_UNIT_NO            VARCHAR2    N         5184512         0               0               6648            HYBRID          20241206 22:02:26
SHIP_VISIT_NO           VARCHAR2    N         35364           .000028         0               6646            HYBRID          20241206 22:02:26
IMP_EXP_MARK            VARCHAR2    N         2               0               0               5213176         FREQUENCY       20241206 22:02:26
LINE_RLS_NO             VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
UNIT_SPECIFIED          VARCHAR2    N         2               .5              0               5213176         NONE            20241206 22:02:26
UNSPECIFIED_NO          VARCHAR2    N         4093            .000244         0               5213176         NONE            20241206 22:02:26
UNIT_CLASS              VARCHAR2    N         1               1               0               5213176         NONE            20241206 22:02:26
UNIT_VISIT_NO           VARCHAR2    Y         2771968         0               0               6647            HYBRID          20241206 22:02:26
UNIT_NO                 VARCHAR2    Y         1859456         .000001         0               6648            HYBRID          20241206 22:02:26
UNIT_ISO_CODE           VARCHAR2    N         24              .041667         0               5213176         NONE            20241206 22:02:26
UNIT_SIZE_CODE          VARCHAR2    N         3               0               0               5213176         FREQUENCY       20241206 22:02:26
UNIT_TYPE_CODE          VARCHAR2    N         12              0               0               5213176         FREQUENCY       20241206 22:02:26
UNIT_HEIGHT_CODE        VARCHAR2    N         4               0               0               5213176         FREQUENCY       20241206 22:02:26
EMPTY_FULL_MARK         VARCHAR2    N         2               0               0               5213176         FREQUENCY       20241206 22:02:26
UNIT_GRADE_CODE         VARCHAR2    Y         29              .034483         5213100         76              NONE            20241206 22:02:26
UNIT_OWNER_CODE         VARCHAR2    Y         348             0               0               5213176         TOP-FREQUENCY   20241206 22:02:26
UNIT_OPERATOR_CODE      VARCHAR2    Y         97              0               0               5213176         FREQUENCY       20241206 22:02:26
UNIT_AGENT_CODE         VARCHAR2    Y         72              0               375246          4837930         FREQUENCY       20241206 22:02:26
UNIT_GROSS_WGT          NUMBER      Y         201536          .000002         10              6648            HYBRID          20241206 22:02:26
UNIT_TARE_WGT           NUMBER      Y         45              .022222         0               5213176         NONE            20241206 22:02:26
ON_SHIP_POSITION        VARCHAR2    Y         4381            .000228         4238809         974367          NONE            20241206 22:02:26
PLAN_ON_SHIP_POSITION   VARCHAR2    Y         2556            .000391         5105178         107998          NONE            20241206 22:02:26
STOW_REQUIRES           VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
BILL_NO                 VARCHAR2    Y         1004096         .000001         1937            6646            HYBRID          20241206 22:02:26
BOOKING_NO              VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
TRADE_TYPE              VARCHAR2    N         2               0               0               5213176         FREQUENCY       20241206 22:02:26
ORIGINAL_LOC_CODE       VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
ORIGINAL_LOC_NAME       VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
ORIGINAL_POL_CODE       VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
POL_CODE                VARCHAR2    N         127             0               0               5213176         FREQUENCY       20241206 22:02:26
POD_CODE                VARCHAR2    N         125             0               0               5213176         FREQUENCY       20241206 22:02:26
SECOND_POD_CODE         VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
FINAL_POD_CODE          VARCHAR2    Y         1572            .000118         50256           6579            HYBRID          20241206 22:02:26
ONCARRIAGE_LOC_CODE     VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
ONCARRIAGE_LOC_NAME     VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
UNIT_CATEGORY           VARCHAR2    N         4               0               0               5213176         FREQUENCY       20241206 22:02:26
TRANSSHIPMENT_MARK      VARCHAR2    N         2               0               0               5213176         FREQUENCY       20241206 22:02:26
TRANS_TYPE_CODE         VARCHAR2    Y         4               0               0               5213176         FREQUENCY       20241206 22:02:26
SHIPPING_TYPE_CODE      VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
DECLARE_SHIP_CODE       VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
DECLARE_SHIP_NAME       VARCHAR2    Y         217             .004608         5200072         13104           NONE            20241206 22:02:26
DECLARE_VOYAGE          VARCHAR2    Y         128             .007813         5204280         8896            NONE            20241206 22:02:26
DECLARE_UNIT_OPER_CODE  VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
NEXT_SERVICE_CODE       VARCHAR2    Y         190             .005263         4953510         259666          NONE            20241206 22:02:26
NEXT_VISIT_NO           VARCHAR2    Y         5038            .000198         4953584         259592          NONE            20241206 22:02:26
SEAL_NO1                VARCHAR2    Y         1314816         .000001         3462763         1750413         NONE            20241206 22:02:26
SEAL_NO2                VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
SEAL_NO3                VARCHAR2    Y         2               .5              5213173         3               NONE            20241206 22:02:26
SEAL_NO4                VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
LCL_MARK                VARCHAR2    N         2               .5              0               5213176         NONE            20241206 22:02:26
HAZARD_MARK             VARCHAR2    N         2               0               0               5213176         FREQUENCY       20241206 22:02:26
IMDG_CODE               VARCHAR2    Y         8               .000005         5108503         104673          FREQUENCY       20241206 22:02:26
UNDG_NO                 VARCHAR2    Y         270             .000005         5108504         104672          TOP-FREQUENCY   20241206 22:02:26
HAZARDS                 VARCHAR2    Y         120             .008333         5194451         18725           NONE            20241206 22:02:26
REEFER_MARK             VARCHAR2    N         2               0               0               5213176         FREQUENCY       20241206 22:02:26
TEMP_UNIT               VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
TEMP_SET                NUMBER      Y         36              .027778         5205528         7648            NONE            20241206 22:02:26
MIN_TEMP                NUMBER      Y         0               0               5213176                         NONE            20241206 22:02:26
MAX_TEMP                NUMBER      Y         0               0               5213176                         NONE            20241206 22:02:26
VENTILATION             NUMBER      Y         0               0               5213176                         NONE            20241206 22:02:26
VENTILATION_UNIT        VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
HUMIDITY                NUMBER      Y         0               0               5213176                         NONE            20241206 22:02:26
OOG_MARK                VARCHAR2    N         2               0               0               5213176         FREQUENCY       20241206 22:02:26
OOG_LEFT                NUMBER      Y         162             .006173         1454249         3758927         NONE            20241206 22:02:26
OOG_RIGHT               NUMBER      Y         164             .006098         1454250         3758926         NONE            20241206 22:02:26
OOG_FRONT               NUMBER      Y         4               .25             1454560         3758616         NONE            20241206 22:02:26
OOG_BACK                NUMBER      Y         4               .25             1454554         3758622         NONE            20241206 22:02:26
OOG_HIGH                NUMBER      Y         302             .003311         1452108         3761068         NONE            20241206 22:02:26
UNIT_FEATURES           VARCHAR2    Y         1               1               5213141         35              NONE            20241206 22:02:26
UNIT_CONDITIONS         VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
BUNDLED_MARK            VARCHAR2    N         2               0               0               5213176         FREQUENCY       20241206 22:02:26
PARENT_UNIT_VISIT_NO    VARCHAR2    Y         855             .000066         5138797         5489            HYBRID          20241206 22:02:26
CLEARANCE_TYPE_CODE     VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
DAMAGE_MARK             VARCHAR2    N         2               0               0               5213176         FREQUENCY       20241206 22:02:26
DAMAGES                 VARCHAR2    Y         372             .002688         5208611         4565            NONE            20241206 22:02:26
CARGO_CODE              VARCHAR2    Y         694             .001441         4964816         248360          NONE            20241206 22:02:26
CARGO_NAME              VARCHAR2    Y         64888           .000009         919817          5440            HYBRID          20241206 22:02:26
CARGO_LABEL             VARCHAR2    Y         87              .011494         5210558         2618            NONE            20241206 22:02:26
PACKAGE_UNIT_CODE       VARCHAR2    Y         50              .02             5204030         9146            NONE            20241206 22:02:26
CARGO_QTY               NUMBER      Y         7420            .000135         1461421         3751755         NONE            20241206 22:02:26
CARGO_VOLUME            NUMBER      Y         21948           .000046         4868716         344460          NONE            20241206 22:02:26
DELIVERY_CLAUSE_CODE    VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
OVERLANDED_MARK         VARCHAR2    N         1               1               0               5213176         NONE            20241206 22:02:26
WORK_TYPE               VARCHAR2    Y         2               0               0               5213176         FREQUENCY       20241206 22:02:26
WORK_FLOW_CODE          VARCHAR2    Y         5               0               0               5213176         FREQUENCY       20241206 22:02:26
WORK_METHOD_CODE        VARCHAR2    Y         1               1               5206750         6426            NONE            20241206 22:02:26
DREDGE_MARK             VARCHAR2    N         2               0               0               5213176         FREQUENCY       20241206 22:02:26
DIFFICULT_TYPE_CODE     VARCHAR2    N         1               1               0               5213176         NONE            20241206 22:02:26
WORK_QUEUE_NO           VARCHAR2    Y         190320          .000005         716             5212460         NONE            20241206 22:02:26
WORK_QUEUE_NAME         VARCHAR2    Y         86888           .000012         2578697         2634479         NONE            20241206 22:02:26
WORK_MOVE_NO            VARCHAR2    Y         5209088         0               716             5212460         NONE            20241206 22:02:26
SEND_TIME               TIMESTAMP(6)Y         444096          .000002         11              5213165         NONE            20241206 22:02:26
SENDER_NO               VARCHAR2    Y         70              .014286         11              5213165         NONE            20241206 22:02:26
SHIP_CRANE_NO           VARCHAR2    Y         22              0               0               5213176         FREQUENCY       20241206 22:02:26
SHIP_CRANE_DRIVER_NO    VARCHAR2    Y         97              0               19              5213157         FREQUENCY       20241206 22:02:26
SHIP_CRANE_WORK_MODE    VARCHAR2    Y         1               1               5210857         2319            NONE            20241206 22:02:26
QUAY_ARRIVE_TIME        TIMESTAMP(6)Y         716             .001397         5212460         716             NONE            20241206 22:02:26
QUAY_WORK_TIME          TIMESTAMP(6)N         4807168         0               0               5213176         NONE            20241206 22:02:26
QUAY_DEPART_TIME        TIMESTAMP(6)Y         716             .001397         5212460         716             NONE            20241206 22:02:26
QUAY_TALLYMAN_NO        VARCHAR2    Y         67              0               716             5212460         FREQUENCY       20241206 22:02:26
QUAY_TWIN_NO            VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
TRUCK_VISIT_NO          VARCHAR2    Y         24012           .000042         5188929         24247           NONE            20241206 22:02:26
TRUCK_NO                VARCHAR2    Y         413             0               0               5213176         TOP-FREQUENCY   20241206 22:02:26
TRUCK_DRIVER_NO         VARCHAR2    Y         285             0               24619           5188557         TOP-FREQUENCY   20241206 22:02:26
ON_TRUCK_POSITION       VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
YARD_CRANE_NO           VARCHAR2    Y         100             0               100534          5112642         FREQUENCY       20241206 22:02:26
YARD_CRANE_DRIVER_NO    VARCHAR2    Y         309             0               100608          5112568         TOP-FREQUENCY   20241206 22:02:26
YARD_CRANE_WORK_MODE    VARCHAR2    Y         1               1               2714510         2498666         NONE            20241206 22:02:26
YARD_ARRIVE_TIME        TIMESTAMP(6)Y         716             .001397         5212460         716             NONE            20241206 22:02:26
YARD_WORK_TIME          TIMESTAMP(6)Y         4899840         0               76503           5136673         NONE            20241206 22:02:26
YARD_DEPART_TIME        TIMESTAMP(6)Y         716             .001397         5212460         716             NONE            20241206 22:02:26
YARD_TALLYMAN_NO        VARCHAR2    Y         260             .003846         2653139         2560037         NONE            20241206 22:02:26
YARD_TWIN_NO            VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26
ON_YARD_POSITION        VARCHAR2    Y         258032          .000004         143923          6475            HYBRID          20241206 22:02:26
PLAN_ON_YARD_POSITION   VARCHAR2    Y         163136          .000006         2661205         2551971         NONE            20241206 22:02:26
ROLLBACK_MARK           VARCHAR2    Y         2               0               2634168         2579008         FREQUENCY       20241206 22:02:26
NOTES                   VARCHAR2    Y         223             .000012         5171881         41295           FREQUENCY       20241206 22:02:26
FACILITY_ID             VARCHAR2    N         1               0               0               6646            FREQUENCY       20241206 22:02:26
CREATOR                 VARCHAR2    N         72              .013889         0               5213176         NONE            20241206 22:02:26
CREATED_ON              TIMESTAMP(6)N         4805632         0               0               5213176         NONE            20241206 22:02:26
CHANGER                 VARCHAR2    N         281             .003559         0               5213176         NONE            20241206 22:02:26
CHANGED_ON              TIMESTAMP(6)N         4819456         0               0               5213176         NONE            20241206 22:02:26
WORK_SHIFT_NO           VARCHAR2    Y         2138            .000468         0               5213176         NONE            20241206 22:02:26
PROJECT_CARGO_CODE      VARCHAR2    Y         0               0               5213176                         NONE            20241206 22:02:26


*******************************************************
*TABLE CITOS.SYS_CODE info:
*******************************************************
================================================================================================
TABLE CITOS.SYS_CODE partition info:
================================================================================================


        Table CITOS.SYS_CODE not partition table!


================================================================================================
TABLE CITOS.SYS_CODE index info:
================================================================================================


TABLE_OWNER              TABLE_NAME                    INDEX_OWNER                   PARTITION##UNIQUE##TBSNAME##NUM_ROWS##LEAF_BLKS   INDEX_NAME                           INDEX_COLUMN_LIST
----------------------   ---------------------------   ----------------------------- ------------------------------------------------  ----------------------------------
-----------------------------------------------------
CITOS                    SYS_CODE                      CITOS                         NO##UNIQUE##NKGLTTOS_SPA##1684##14                PK_SYS_CODE                          CODE_ID
CITOS                    SYS_CODE                      CITOS                         NO##UNIQUE##NKGLTTOS_SPA##1684##12                IDX_SYS_CODE
FACILITY_ID,CODES_SET_CODE,CATEGORY_CODE,CODE


INDEX EXPRESSIONS:
INDEX_NAME                    COLUMN_EXPRESSION                       COLUMN_POSITION
--------------------------    -------------------------------------   ------------------


================================================================================================
TABLE CITOS.SYS_CODE statistics:
================================================================================================


TABLE CITOS.SYS_CODE tab statistics:
OWNER           TABLE_NAME                    PARTITION_NAME  OBJECT_TYPE     NUM_ROWS        SAMPLE_SIZE     BLOCKS          EMPTY_BLOCKS   AVG_ROW_LEN     STALE  LOCKED  LAST_ANALYZED
--------------- ----------------------------- --------------- --------------  --------------  --------------  --------------  -------------  --------------- ------ ------- -----------------
CITOS           SYS_CODE                                      TABLE           1684            1684            50              0               149             NO           20250106 23:41:12


TABLE CITOS.SYS_CODE col statistics:
COLUMN_NAME             DATA_TYPE   NULLABLE  NUM_DISTINCT    DENSITY         NUM_NULLS       SAMPLE_SIZE    HISTOGRAM       LAST_ANALYZED
----------------------  ----------  --------  --------------  -------------   --------------  -------------  --------------  -------------------
CODE_ID                 VARCHAR2    N         1684            .000594         0               1684            HYBRID          20250106 23:41:12
CODES_SET_CODE          VARCHAR2    N         1               1               0               1684            NONE            20250106 23:41:12
CATEGORY_CODE           VARCHAR2    N         320             .002308         0               1684            HYBRID          20250106 23:41:12
CATEGORY_NAME           VARCHAR2    Y         325             .002349         7               1677            HYBRID          20250106 23:41:12
CODE                    VARCHAR2    N         946             .000957         0               1684            HYBRID          20250106 23:41:12
NAME                    VARCHAR2    N         1378            .000722         0               1684            HYBRID          20250106 23:41:12
ENGLISH_NAME            VARCHAR2    Y         738             .001355         782             902             NONE            20250106 23:41:12
SORT_NO                 NUMBER      Y         128             .007813         424             1260            NONE            20250106 23:41:12
CUSTOM_TEXT01           VARCHAR2    Y         65              .002101         1446            238             FREQUENCY       20250106 23:41:12
CUSTOM_TEXT02           VARCHAR2    Y         35              .006494         1607            77              FREQUENCY       20250106 23:41:12
CUSTOM_TEXT03           VARCHAR2    Y         11              .016129         1653            31              FREQUENCY       20250106 23:41:12
CUSTOM_TEXT04           VARCHAR2    Y         20              .01             1634            50              FREQUENCY       20250106 23:41:12
CUSTOM_TEXT05           VARCHAR2    Y         1               1               1682            2               NONE            20250106 23:41:12
CUSTOM_TEXT06           VARCHAR2    Y         0               0               1684                            NONE            20250106 23:41:12
CUSTOM_DATE01           VARCHAR2    Y         0               0               1684                            NONE            20250106 23:41:12
CUSTOM_DATE02           VARCHAR2    Y         0               0               1684                            NONE            20250106 23:41:12
CUSTOM_NUMERIC01        NUMBER      Y         2               .5              1682            2               NONE            20250106 23:41:12
CUSTOM_NUMERIC02        NUMBER      Y         0               0               1684                            NONE            20250106 23:41:12
HARDCODED_MARK          VARCHAR2    N         2               .5              0               1684            NONE            20250106 23:41:12
USING_STATE             VARCHAR2    N         2               .000297         0               1684            FREQUENCY       20250106 23:41:12
NOTES                   VARCHAR2    Y         39              .025641         1644            40              NONE            20250106 23:41:12
FACILITY_ID             VARCHAR2    N         1               .000297         0               1684            FREQUENCY       20250106 23:41:12
CREATOR                 VARCHAR2    N         22              .045455         0               1684            NONE            20250106 23:41:12
CREATED_ON              TIMESTAMP(6)N         1064            .00085          0               1684            HYBRID          20250106 23:41:12
CHANGER                 VARCHAR2    N         20              .05             0               1684            NONE            20250106 23:41:12
CHANGED_ON              TIMESTAMP(6)N         924             .000936         0               1684            HYBRID          20250106 23:41:12


*******************************************************
*TABLE CITOS.WORK_CARRIER info:
*******************************************************
================================================================================================
TABLE CITOS.WORK_CARRIER partition info:
================================================================================================


        Table CITOS.WORK_CARRIER not partition table!


================================================================================================
TABLE CITOS.WORK_CARRIER index info:
================================================================================================


TABLE_OWNER              TABLE_NAME                    INDEX_OWNER                   PARTITION##UNIQUE##TBSNAME##NUM_ROWS##LEAF_BLKS   INDEX_NAME                           INDEX_COLUMN_LIST
----------------------   ---------------------------   ----------------------------- ------------------------------------------------  ----------------------------------
-----------------------------------------------------
CITOS                    WORK_CARRIER                  CITOS                         NO##UNIQUE##NKGLTTOS_SPA##130362##1093            PK_WORK_CARRIER                      WORK_CARRIER_ID
CITOS                    WORK_CARRIER                  CITOS                         NO##NONUNIQUE##NKGLTTOS_SPA##130362##1755         IDX_WORK_CARRIER
WORK_SHIFT_NO,CARRIER_MODE,CARRIER_VISIT_NO,FACILITY_ID
CITOS                    WORK_CARRIER                  CITOS                         NO##UNIQUE##NKGLTTOS_SPA##130362##1318            WORKCARRIER_SHIP_WORK_UNIQUE
WORK_SHIFT_NO,CARRIER_VISIT_NO


INDEX EXPRESSIONS:
INDEX_NAME                    COLUMN_EXPRESSION                       COLUMN_POSITION
--------------------------    -------------------------------------   ------------------


================================================================================================
TABLE CITOS.WORK_CARRIER statistics:
================================================================================================


TABLE CITOS.WORK_CARRIER tab statistics:
OWNER           TABLE_NAME                    PARTITION_NAME  OBJECT_TYPE     NUM_ROWS        SAMPLE_SIZE     BLOCKS          EMPTY_BLOCKS   AVG_ROW_LEN     STALE  LOCKED  LAST_ANALYZED
--------------- ----------------------------- --------------- --------------  --------------  --------------  --------------  -------------  --------------- ------ ------- -----------------
CITOS           WORK_CARRIER                                  TABLE           130362          130362          4909            0               254             NO           20250113 22:01:36


TABLE CITOS.WORK_CARRIER col statistics:
COLUMN_NAME             DATA_TYPE   NULLABLE  NUM_DISTINCT    DENSITY         NUM_NULLS       SAMPLE_SIZE    HISTOGRAM       LAST_ANALYZED
----------------------  ----------  --------  --------------  -------------   --------------  -------------  --------------  -------------------
SYS_NC00042$            RAW         Y         1               1               627             129735          NONE            20250113 22:01:35
LOCKED_MARK             VARCHAR2    Y         2               .5              129557          805             NONE            20250113 22:01:35
WORK_CARRIER_ID         VARCHAR2    N         130362          .000008         0               130362          NONE            20250113 22:01:35
WORK_CARRIER_NO         VARCHAR2    N         130362          .000008         0               130362          NONE            20250113 22:01:35
WORK_SHIFT_NO           VARCHAR2    N         4322            .000231         0               130362          NONE            20250113 22:01:35
WORK_SHIFT_CLASS        VARCHAR2    N         1               .000004         0               6961            FREQUENCY       20250113 22:01:35
CARRIER_MODE            VARCHAR2    Y         1               .000004         37              6959            FREQUENCY       20250113 22:01:35
CARRIER_VISIT_NO        VARCHAR2    Y         66216           .000015         0               130362          NONE            20250113 22:01:35
PRIORITY_CLASS          NUMBER      Y         40              .025            103360          27002           NONE            20250113 22:01:35
PLAN_BERTHING_MODE      VARCHAR2    Y         2               .5              26791           103571          NONE            20250113 22:01:35
PLAN_BERTH_CODE         VARCHAR2    Y         23              .043478         26792           103570          NONE            20250113 22:01:35
PLAN_BEGIN_BOLLARD_CODE VARCHAR2    Y         107             .009346         26793           103569          NONE            20250113 22:01:35
PLAN_END_BOLLARD_CODE   VARCHAR2    Y         110             .009091         26793           103569          NONE            20250113 22:01:35
PLAN_BEGIN_METER        NUMBER      Y         0               0               130362                          NONE            20250113 22:01:35
PLAN_END_METER          NUMBER      Y         0               0               130362                          NONE            20250113 22:01:35
BERTHING_MODE           VARCHAR2    Y         2               .5              103581          26781           NONE            20250113 22:01:35
BERTH_CODE              VARCHAR2    Y         23              .043478         103659          26703           NONE            20250113 22:01:35
BEGIN_BOLLARD_CODE      VARCHAR2    Y         109             .009174         103679          26683           NONE            20250113 22:01:35
END_BOLLARD_CODE        VARCHAR2    Y         114             .008772         103682          26680           NONE            20250113 22:01:35
BEGIN_METER             NUMBER      Y         0               0               130362                          NONE            20250113 22:01:35
END_METER               NUMBER      Y         0               0               130362                          NONE            20250113 22:01:35
DISTANCE_FROM_DOCK      NUMBER      Y         0               0               130362                          NONE            20250113 22:01:35
ETB                     TIMESTAMP(6)Y         74448           .000013         39              130323          NONE            20250113 22:01:35
ETU                     TIMESTAMP(6)Y         26196           .000038         101534          28828           NONE            20250113 22:01:35
RTB                     TIMESTAMP(6)Y         0               0               130362                          NONE            20250113 22:01:35
RTU                     TIMESTAMP(6)Y         0               0               130362                          NONE            20250113 22:01:35
PLAN_BEGIN_TIME         TIMESTAMP(6)Y         51088           .00002          26868           103494          NONE            20250113 22:01:35
PLAN_END_TIME           TIMESTAMP(6)Y         58056           .000017         26871           103491          NONE            20250113 22:01:35
WORK_BEGIN_TIME         TIMESTAMP(6)Y         21534           .000046         103859          26503           NONE            20250113 22:01:35
WORK_END_TIME           TIMESTAMP(6)Y         1173            .000853         129086          1276            NONE            20250113 22:01:35
DISPATCH_MODE           VARCHAR2    Y         4               .25             991             129371          NONE            20250113 22:01:35
WORK_RISK_LEVEL         VARCHAR2    Y         0               0               130362                          NONE            20250113 22:01:35
WORK_STATE              VARCHAR2    N         2               .5              0               130362          NONE            20250113 22:01:35
HARDCODED_MARK          VARCHAR2    N         1               1               0               130362          NONE            20250113 22:01:35
NOTES                   VARCHAR2    Y         19376           .000052         63816           66546           NONE            20250113 22:01:35
FACILITY_ID             VARCHAR2    N         1               .000004         0               6961            FREQUENCY       20250113 22:01:35
CREATOR                 VARCHAR2    N         92              .01087          0               130362          NONE            20250113 22:01:35
CHANGED_ON              TIMESTAMP(6)Y         128504          .000008         0               130362          NONE            20250113 22:01:35
CHANGER                 VARCHAR2    Y         102             .009804         0               130362          NONE            20250113 22:01:35
CREATED_ON              TIMESTAMP(6)N         128760          .000008         0               130362          NONE            20250113 22:01:35
NEXT_SHIFT_NO           VARCHAR2    Y         4122            .000243         102851          27511           NONE            20250113 22:01:35
PREV_SHIFT_NO           VARCHAR2    Y         4126            .000242         102926          27436           NONE            20250113 22:01:35
ETB2                    TIMESTAMP(6)Y         89              .011236         130273          89              NONE            20250113 22:01:35



PL/SQL procedure successfully completed.
