
interfaces=`ifconfig | grep 'BROADCAST' | cut -d: -f1`
interface=`echo ${interfaces} | awk '{ print $1}'`

. ${lvs_keepalived_base}/conf/dr_init_keepalived.sh
. ${lvs_keepalived_base}/conf/dr_init_startup.sh
. ${lvs_keepalived_base}/conf/dr_init_shutdown.sh
