guide-lvs-keepalived
====================


lvs+keepalived负载均衡和主机检测教程<br>

lvs+keepalived集群由master-backup方式实现，由keepalived负责失效检测和自动切换。<br>

## 使用
安装ipvsadm和keepalived<br>
需要root权限<br>
yum install ipvsadm keepalived<br>

新建路径/home/lvs-keepalived/<br>


在nginx运行的服务器上运行real_server/startup.sh<br>

在lvs master服务器上运行dr_master/init.sh初始化配置<br>

运行dr_master/startup.sh启动<br>

在lvs backup服务器上运行dr_master/init.sh初始化配置<br>

运行dr_backup/startup.sh启动<br>


realserver配置文件放在conf/virtualserver文件夹中，格式需要按照已有配置进行<br>
