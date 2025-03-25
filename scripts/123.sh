#!/bin/bash

INSTANCE_NAME=$1
DB_NAME=$2
backup_date=$(date +%Y%m%d)
backup_base="/dbbak"
log_file="$backup_base/${DB_NAME}_backup.log"
backup_dir="$backup_base/${DB_NAME}_${backup_date}"
TABLELIST="$backup_base/${DB_NAME}_tablelist"

max_jobs=5
job_count=0
pids=()

mkdir -p "$backup_dir"
chmod 777 "$backup_dir"
touch "$log_file"
touch "$TABLELIST"
chmod 777 "$log_file"
chmod 777 "$TABLELIST"

echo "************************************START: $(date '+%Y-%m-%d %H:%M:%S')************************************" >>"$log_file"
start_time=$(date +%s)
su - "$INSTANCE_NAME" -c "
    export DB2CODEPAGE=\$(db2 get db cfg for $DB_NAME | grep 'code page' | awk '{print \$NF}')
    db2 terminate
    db2 connect to $DB_NAME
    db2 -x \"SELECT trim(tabschema) || '.' || trim(tabname) FROM syscat.tables WHERE  tabschema not like 'SYS%'\" > $TABLELIST

    while IFS= read -r tablename; do
        if [[ -n \"\$tablename\" ]]; then
            tablename=\$(echo \"\$tablename\" | xargs)
#            export_command=\"sleep $((RANDOM % 16 + 5))\"
            echo $(date '+%Y-%m-%d %H:%M:%S') >> \"$log_file\"
#            \$export_command >> \"$log_file\" 2>&1 &
            if [[ \$job_count -lt $max_jobs ]];then
                sleep $((RANDOM % 16 + 5)) &
                pid=\$!
                pids+=(\$pid)
                ((job_count++))
            else 
                sleep 3
                for i in \"\${!pids[@]}\"; do
                    if !  kill -0 \${pids[\$i]} 2>/dev/null; then
                        unset pids[\$i]
                        ((job_count--))
                    fi
                done
            fi
        fi
    done < $TABLELIST
wait
"

export_end=$(date +%s)
export_duration=$((export_end - start_time))
ls -ltr $backup_dir | 
if tar -cvf ${backup_dir}.tar ${backup_dir} && gzip ${backup_dir}.tar; then
    echo "gzip success: ${backup_dir}.tar.gz" >>"$log_file"
    rm -rf ${backup_dir}
else
    echo "gzip fail: ${backup_dir}.tar.gz" >>"$log_file"
fi
gzip_end=$(date +%s)
gzip_duration=$((gzip_end - export_end))
echo "export completed in $export_duration s." >> "$log_file"
echo "gzip completed in $gzip_duration s." >> "$log_file"

echo "*************************************END: $(date '+%Y-%m-%d %H:%M:%S')*************************************" >>"$log_file"




INSTANCE_NAME=$1
DB_NAME=$2
backup_date=$(date +%Y%m%d)
backup_base="/dbbak"
log_file="$backup_base/${DB_NAME}_backup.log"
backup_dir="$backup_base/${DB_NAME}_${backup_date}"
TABLELIST="$backup_base/${DB_NAME}_tablelist"

mkdir -p "$backup_dir"
chmod 777 "$backup_dir"
touch "$log_file"
touch "$TABLELIST"
chmod 777 "$log_file"
chmod 777 "$TABLELIST"


connect_db(){
    export DB2CODEPAGE=$(db2 get db cfg for $1 | grep 'code page' | awk '{print $NF}')
    db2 terminate
    db2 connect to $1
    db2 -x "SELECT trim(tabschema) || '.' || trim(tabname) FROM syscat.tables WHERE  tabschema not like 'SYS%'" > $2
} 

export_table(){
    db2 "EXPORT TO $1/${2}.del OF DEL lobs to $1 xml to $1 MODIFIED BY chardel+ COLDEL0x1d SELECT * FROM ${2} WITH UR"  
}


su - "$INSTANCE_NAME" -c "
    connect_db \$DB_NAME \$TABLELIST
    while IFS= read -r tablename; do
        if [[ -n \"\$tablename\" ]]; then
            tablename=\$(echo \"\$tablename\" | xargs)
            export_table \$backup_dir \$tablename >> \"$log_file\" 2>&1
        fi
    done < $TABLELIST
" 


····

if [[ $INSTANCE_NAME == "mname" ]];then 
 
fi