learn git
earn 
earn 
earn 
earn 
earn 
# 关闭THP 
root用户下
在vi /etc/rc.local最后添加如下代码
if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi
if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
echo never > /sys/kernel/mm/transparent_hugepage/defrag
fi

chmod +x /etc/rc.d/rc.local
echo "never" > /sys/kernel/mm/transparent_hugepage/enabled
echo "never" > /sys/kernel/mm/transparent_hugepage/defrag

cat /sys/kernel/mm/transparent_hugepage/enabled
cat /sys/kernel/mm/transparent_hugepage/defrag

/sys/kernel/mm/transparent_hugepage/enabled
extract ext1
userid ogg,password ogg123
SETENV (NLS_LANG=AMERICAN_AMERICA.AL32UTF8)
exttrail /ogg/dirdat/ex
warnlongtrans 12h,checkinterval 30m
discardfile  /ggs/dirrpt/extxj1.dsc,append,megabytes 200
table pdb2.test01.*;
TRANLOGOPTIONS INTEGRATEDCAPTURE
EXTSCN  3017924
