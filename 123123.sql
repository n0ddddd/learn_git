DROP TABLE IF EXISTS t_student;
CREATE TABLE t_student (
  id int(10) unsigned NOT NULL,
  std_name varchar(30) NOT NULL,
  age tinyint(3) unsigned NOT NULL,
  class_id int(11) unsigned NOT NULL,
  PRIMARY KEY (id),
  KEY idx_std_age (age),
  KEY idx_std_name_age_class (std_name,age,class_id) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
 
--添加测试数据的存储过程
DROP PROCEDURE IF EXISTS proc_insert_student; 
DELIMITER $$
CREATE PROCEDURE proc_insert_student()      
BEGIN
  DECLARE i INT;                 
  SET i=0;                        
  WHILE i<=100000 DO               
    INSERT INTO t_student(id,std_name,age,class_id) VALUES(i,CONCAT('Li Lei',i), (i MOD 120)+1 ,(i MOD 3)+1);   
	do sleep(5);
    SET i=i+1;                     
  END WHILE;
END $$

-- 执行存储过程
call proc_insert_student();



select s.inst_id,
	   s.sql_id,
	   s.username,
	   object_name,
	   s.status,
	   s.event,
	   machine,
	   s.PROGRAM,
	   s.type,
	   'alter system kill session ''' || s.sid || ',' || s.serial# || ',@' ||
	   s.inst_id || ''' IMMEDIATE;',
	   l.locked_mode,
	   'ps -ef|grep ' || p.SPID,
	   'kill -9 ' || p.SPID
  from gv$locked_object l,dba_objects o,gv$session s, gv$process p
 where l.object_id = o.object_id
   and l.session_id = s.sid
   and s.inst_id = p.INST_ID
   and s.PADDR = p.ADDR
   and s.type = 'USER'
   and object_name = 'T_NKH_CFRW'