-- 创建错误记录表
CREATE TABLE data_mig.mig_error_log (
    table_name     VARCHAR2(100),
    error_time    TIMESTAMP DEFAULT SYSTIMESTAMP,
    error_message VARCHAR2(4000)
);

CREATE INDEX idx_error_time ON data_mig.mig_error_log (error_time);

CREATE OR REPLACE PROCEDURE data_mig.mig_table_data (
  p_src_table   IN VARCHAR2,  -- 源表名（含dblink）
  p_dst_table   IN VARCHAR2,  -- 目标表名
  p_pk_col      IN VARCHAR2,  -- 主键字段名
  p_cutoff_date IN DATE,      -- 截止日期
  p_batch_size  IN NUMBER DEFAULT 5000
) AS
  TYPE pk_tab IS TABLE OF VARCHAR2(200);
  v_pks pk_tab;
  v_sql VARCHAR2(4000);
  v_retry NUMBER := 0;
  v_max_retry CONSTANT NUMBER := 2;
  v_success BOOLEAN;
BEGIN
  LOOP
    -- 动态获取主键集合
    v_sql := 'SELECT ' || p_pk_col || ' FROM (SELECT ' || p_pk_col ||
             ' FROM ' || p_src_table ||
             ' WHERE ts < :1 ORDER BY ts) WHERE ROWNUM <= :2';
    EXECUTE IMMEDIATE v_sql BULK COLLECT INTO v_pks USING TO_CHAR(p_cutoff_date, 'yyyy-mm-dd hh24:mi:ss'), p_batch_size;

    EXIT WHEN v_pks.COUNT = 0;

    v_retry := 0;
    v_success := FALSE;
    WHILE v_retry < v_max_retry AND NOT v_success LOOP
      BEGIN
        -- 插入目标表
        FOR i IN 1..v_pks.COUNT LOOP
          v_sql := 'INSERT INTO ' || p_dst_table ||
                   ' SELECT * FROM ' || p_src_table ||
                   ' WHERE ' || p_pk_col || ' = :1';
          EXECUTE IMMEDIATE v_sql USING v_pks(i);
        END LOOP;
        -- 删除源表
        FOR i IN 1..v_pks.COUNT LOOP
          v_sql := 'DELETE FROM ' || p_src_table ||
                   ' WHERE ' || p_pk_col || ' = :1';
          EXECUTE IMMEDIATE v_sql USING v_pks(i);
        END LOOP;
        COMMIT;
        v_success := TRUE;
      EXCEPTION
        WHEN OTHERS THEN
          v_retry := v_retry + 1;
          INSERT INTO data_mig.mig_error_log(table_name, error_message)
          VALUES (p_src_table, 'Retry ' || v_retry || ': ' || SQLERRM);
          COMMIT;
          IF v_retry >= v_max_retry THEN
            RAISE;
          END IF;
      END;
    END LOOP;
  END LOOP;
END;
/


BEGIN
  data_mig.mig_table_data(
    p_src_table   => 'data_mig.UH_APPOINT_RECORD_LOG@sourcedb',
    p_dst_table   => 'data_mig.HIS_UH_CN_PV_SIGN_IP',
    p_pk_col      => 'pk_appointrecordlog',
    p_cutoff_date => TRUNC(SYSDATE) - 3600,
    p_batch_size  => 5000
  );
END;
/


-- 创建调度任务
-- 每天凌晨3点执行一次
BEGIN
  DBMS_SCHEDULER.CREATE_JOB(
    job_name        => 'uh_cn_pv_sign_ip_mig',
    job_type        => 'STORED_PROCEDURE',
    job_action      => 'uh_cn_pv_sign_ip_mig',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=DAILY; BYHOUR=3; BYMINUTE=0',
    enabled         => TRUE
  );
END;
/