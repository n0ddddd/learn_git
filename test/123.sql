SELECT SV.SHIP_VISIT_NO SHIP_VISIT_NO,
    SV.SHIP_USE_TYPE SHIP_USE_TYPE,
    SSD.SHIP_NAME,
    SV.BERTH_CODE,
    SV.EX_CARGO_WGT,
    SV.SHIP_LINE_CODE,
    SV.TRANSPORT_WAY,
    (
        SELECT NAME
        FROM SYS_CODE
        WHERE SYS_CODE.CODE = TRANSPORT_WAY
            AND CATEGORY_CODE = 'TRANSPORT_WAY'
            AND FACILITY_ID = 'NKGLT'
    ) TRANS_NAME,
    SV.TRADE_TYPE,
    (
        SELECT NAME
        FROM SYS_CODE
        WHERE SYS_CODE.CODE = SV.TRADE_TYPE
            AND CATEGORY_CODE = 'TRADE_TYPE'
            AND FACILITY_ID = 'NKGLT'
    ) TRADE_NAME,
    IM_VOYAGE,
    EX_VOYAGE,
    SV.FROM_PORT_CODE,
    (
        SELECT PORT_NAME
        FROM SBC_PORT
        WHERE PORT_CODE = SV.FROM_PORT_CODE
            AND FACILITY_ID = 'NKGLT'
    ) FROM_NAME,
    SV.TO_PORT_CODE,
    (
        SELECT PORT_NAME
        FROM SBC_PORT
        WHERE PORT_CODE = SV.TO_PORT_CODE
            AND FACILITY_ID = 'NKGLT'
    ) TO_NAME,
    TO_CHAR (NVL (SV.DTA, SV.ETA), 'DD') SHIP_LINE,
    NVL (DTA, ETA) PLAN_ETB,
    SV.RTB,
    SV.LOAD_BEGIN_TIME,
    LOAD_END_TIME,
    DISC_BEGIN_TIME,
    DISC_END_TIME,
    SV.RTD,
    (
        SELECT MAX (NVL (SBS.ETU, WC.ETU))
        FROM WORK_CARRIER WC,
            SHIP_BERTHPLAN_SORT SBS
        WHERE WC.CARRIER_VISIT_NO = SV.SHIP_VISIT_NO
            AND WC.CARRIER_VISIT_NO = SBS.SHIP_VISIT_NO
            AND WC.FACILITY_ID = SBS.FACILITY_ID
            AND WC.FACILITY_ID = 'NKGLT'
    ) PLAN_ETU,
    NVL (
        SUM (
            CASE
                WHEN UNIT_SIZE_CODE <= '20'
                AND EMPTY_FULL_MARK = 'E'
                AND IMP_EXP_MARK = 'I' THEN 1
                ELSE 0
            END
        ),
        0
    ) I_E_20,
    NVL (
        SUM (
            CASE
                WHEN UNIT_SIZE_CODE > '20'
                AND UNIT_SIZE_CODE <= '40'
                AND EMPTY_FULL_MARK = 'E'
                AND IMP_EXP_MARK = 'I' THEN 1
                ELSE 0
            END
        ),
        0
    ) I_E_40,
    NVL (
        SUM (
            CASE
                WHEN UNIT_SIZE_CODE > '40'
                AND UNIT_SIZE_CODE <= '45'
                AND EMPTY_FULL_MARK = 'E'
                AND IMP_EXP_MARK = 'I' THEN 1
                ELSE 0
            END
        ),
        0
    ) I_E_45,
    NVL (
        SUM (
            CASE
                WHEN UNIT_SIZE_CODE <= '20'
                AND EMPTY_FULL_MARK = 'F'
                AND IMP_EXP_MARK = 'I' THEN 1
                ELSE 0
            END
        ),
        0
    ) I_F_20,
    NVL (
        SUM (
            CASE
                WHEN UNIT_SIZE_CODE > '20'
                AND UNIT_SIZE_CODE <= '40'
                AND EMPTY_FULL_MARK = 'F'
                AND IMP_EXP_MARK = 'I' THEN 1
                ELSE 0
            END
        ),
        0
    ) I_F_40,
    NVL (
        SUM (
            CASE
                WHEN UNIT_SIZE_CODE > '40'
                AND UNIT_SIZE_CODE <= '45'
                AND EMPTY_FULL_MARK = 'F'
                AND IMP_EXP_MARK = 'I' THEN 1
                ELSE 0
            END
        ),
        0
    ) I_F_45,
    NVL (
        SUM (
            CASE
                WHEN UNIT_SIZE_CODE <= '20'
                AND EMPTY_FULL_MARK = 'E'
                AND IMP_EXP_MARK = 'E' THEN 1
                ELSE 0
            END
        ),
        0
    ) E_E_20,
    NVL (
        SUM (
            CASE
                WHEN UNIT_SIZE_CODE > 20
                AND UNIT_SIZE_CODE <= '40'
                AND EMPTY_FULL_MARK = 'E'
                AND IMP_EXP_MARK = 'E' THEN 1
                ELSE 0
            END
        ),
        0
    ) E_E_40,
    NVL (
        SUM (
            CASE
                WHEN UNIT_SIZE_CODE > 40
                AND UNIT_SIZE_CODE <= '45'
                AND EMPTY_FULL_MARK = 'E'
                AND IMP_EXP_MARK = 'E' THEN 1
                ELSE 0
            END
        ),
        0
    ) E_E_45,
    NVL (
        SUM (
            CASE
                WHEN UNIT_SIZE_CODE <= '20'
                AND EMPTY_FULL_MARK = 'F'
                AND IMP_EXP_MARK = 'E' THEN 1
                ELSE 0
            END
        ),
        0
    ) E_F_20,
    NVL (
        SUM (
            CASE
                WHEN UNIT_SIZE_CODE > '20'
                AND UNIT_SIZE_CODE <= '40'
                AND EMPTY_FULL_MARK = 'F'
                AND IMP_EXP_MARK = 'E' THEN 1
                ELSE 0
            END
        ),
        0
    ) E_F_40,
    NVL (
        SUM (
            CASE
                WHEN UNIT_SIZE_CODE > '40'
                AND UNIT_SIZE_CODE <= '45'
                AND EMPTY_FULL_MARK = 'F'
                AND IMP_EXP_MARK = 'E' THEN 1
                ELSE 0
            END
        ),
        0
    ) E_F_45,
    SUM (
        CASE
            WHEN IMP_EXP_MARK = 'I' THEN F_GET_TEU (UNIT_SIZE_CODE)
            ELSE 0
        END
    ) I_TEU,
    SUM (
        CASE
            WHEN IMP_EXP_MARK = 'E' THEN F_GET_TEU (UNIT_SIZE_CODE)
            ELSE 0
        END
    ) E_TEU,
    SUM (F_GET_TEU (UNIT_SIZE_CODE)) TEU,
    TEU_QTY,
    SUM (
        CASE
            WHEN IMP_EXP_MARK = 'E' THEN F_GET_TEU (UNIT_SIZE_CODE)
            ELSE 0
        END
    ) / TEU_QTY E_LOAD_RATE,
    SUM (
        CASE
            WHEN IMP_EXP_MARK = 'I' THEN F_GET_TEU (UNIT_SIZE_CODE)
            ELSE 0
        END
    ) / TEU_QTY I_LOAD_RATE,
    ELEC_PILE_MARK,
    MIN (
        CASE
            WHEN IMP_EXP_MARK = 'I' THEN QUAY_WORK_TIME
        END
    ) MIN_I_WORK_TIME,
    MIN (
        CASE
            WHEN IMP_EXP_MARK = 'E' THEN QUAY_WORK_TIME
        END
    ) MIN_E_WORK_TIME,
    MAX (
        CASE
            WHEN IMP_EXP_MARK = 'I' THEN QUAY_WORK_TIME
        END
    ) MAX_I_WORK_TIME,
    MAX (
        CASE
            WHEN IMP_EXP_MARK = 'E' THEN QUAY_WORK_TIME
        END
    ) MAX_E_WORK_TIME,
    MIN (QUAY_WORK_TIME) MIN_WORK_TIME,
    MAX (QUAY_WORK_TIME) MAX_WORK_TIME,
    SV.SERVICE_CODE,
    SSS.SERVICE_NAME,
    SHIP_COURSE_CODE,
    (
        SELECT SHIP_COURSE_NAME
        FROM SBC_SHIP_COURSE SSC
        WHERE SSC.SHIP_COURSE_CODE = SSS.SHIP_COURSE_CODE
            AND SSC.FACILITY_ID = 'NKGLT'
    ) SHIP_COURSE_NAME
FROM SHIP_VISIT SV,
    SHIP_WORK_UNIT SWU,
    SBC_SHIP_SERVICE SSS,
    SBC_SHIP_DATA SSD
WHERE SWU.SHIP_VISIT_NO = SV.SHIP_VISIT_NO
    AND SV.SHIP_CODE = SSD.SHIP_CODE
    AND SV.FACILITY_ID = SSD.FACILITY_ID
    AND SV.SERVICE_CODE = SSS.SERVICE_CODE(+)
    AND NVL (ROLLBACK_MARK, '0') <> '1'
    AND SV.FACILITY_ID = 'NKGLT'
    AND SWU.QUAY_WORK_TIME >= TO_DATE ('2024-11-01', 'yyyy-MM-dd hh24:mi:ss')
    AND SWU.QUAY_WORK_TIME <= TO_DATE ('2024-11-08', 'yyyy-MM-dd hh24:mi:ss')
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
    SHIP_COURSE_CODE