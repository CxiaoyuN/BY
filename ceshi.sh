#!/bin/bash
#本程序由情韵编写
#QQ:2223139086
#博雅DALO版权所有
function shell_end() {
	rm -rf /var/centos
	sed -i "s/NAS-IP-Address=127.0.0.1/NAS-IP-Address=${IP}/g" /etc/openvpn/radiusplugin*.cnf
	clear
	echo -e "\033[1;32m"
	echo "=========================================================================="
	echo "                          博雅-DALO 测试版 安装完成                          "
	echo "                                                                          "
	echo "                            博雅-DALO服务器信息                           "
	echo "                                                                          "
	echo "                   查询流量地址：( "$IP":"$cxlldk" )                           "
	echo "                   APP 下载地址：( "$IP":"$appjiemian" )脑残勿用此链接    		    "
	echo "                   后台管理地址：( "$IP":"$lkdk"/"$wenjian" )             "
	echo "                   后台管理账号: "$administrator" 密码: "$boya123"        "
	echo "                   数据库  账号: root  密码: "$sqladmin"                  "
	echo "                           重启VPN命令：vpn                               "
	echo "温馨提示下 这个脚本443 440 3389 1026 53 1194 都开了的！别瞎鸡巴弄了！我懒得售后啊！"
	echo "=========================================================================="
	echo -e "\033[0m"
	reboot
	exit
}

function install_openvpn_squid_haproxy() {
	yum -y install epel-release
	yum install httpd -y
	rm -rf /etc/yum.repos.d/rpmforge.repo
	rpm -ivh ${http}/${host}/${wenjiann}/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm >/dev/null 2>&1
	yum install -y gcc-c++ openvpn mysql mysql-server freeradius freeradius-mysql freeradius-utils libgcrypt libgpg-error libgcrypt-devel nload wget
	yum install -y zip
	yum install -y haproxy squid httpd dnsmasq exim
	yum install -y sysstat
	yum install -y php-cli php-odbc php-pear-DB php-mbstring php-pear php-mcrypt php php-common php-imap php-mysql php-pdo php-gd php-xml php-xmlrpc  --skip-broken
	yum install httpd -y
	rm -rf /etc/yum.repos.d/rpmforge.repo
	rm -rf /etc/yum.repos.d/mirrors*
	rm -rf /etc/yum.repos.d/remi*
	yum makecache
	yum -y install epel-release
	yum install -y gcc-c++ openvpn mysql mysql-server freeradius freeradius-mysql freeradius-utils libgcrypt libgpg-error libgcrypt-devel nload wget
	yum install -y zip
	yum install -y haproxy squid httpd dnsmasq exim
	yum install -y sysstat
	rpm -ivh ${http}/${host}/${wenjiann}/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm >/dev/null 2>&1
	yum install -y php-cli php-odbc php-pear-DB php-mbstring4 php-pear php-mcrypt php php-common php-imap php-mysql php-pdo php-gd php-xml php-xmlrpc  --skip-broken
	cd /root
	rm -rf *
	wget ${http}/${host}/${wenjiann}/radiusplugin_v2.1.tar.gz >/dev/null 2>&1
	tar -zxvf radiusplugin_v2.1.tar.gz > /dev/NULL 
	cd radiusplugin  
	make  > /dev/NULL
	mkdir /etc/openvpn
	cp radiusplugin.so /etc/openvpn  > /dev/NULL
	cp radiusplugin.cnf /etc/openvpn > /dev/NULL
	cd
	rm -rf *
}

function set_openvpn() {
	if [ ! -d /etc/openvpn ]; then
		rm -rf /etc/yum.repos.d/rpmforge.repo
		rm -rf /etc/yum.repos.d/mirrors*
		rm -rf /etc/yum.repos.d/remi*
		yum makecache
		yum install -y openvpn
		yum install squid haproxy -y
		if [ ! -d /etc/openvpn ]; then
			echo "警告！openvpn程序安装失败!请联系管理员处理"
			exit
		fi
	fi
	rm -rf /etc/openvpn/*
	cd /etc/openvpn
	wget ${http}/${host}/${wenjiann}/openvpn.zip >/dev/null 2>&1
	unzip -o openvpn.zip >/dev/null 2>&1
	sed -i "s/440/3311/g" server*.conf
	rm -rf openvpn.zip
	service openvpn restart
	if [[ $? -eq 0 ]];then
		echo "openvpn安装成功"
	else
        echo "openvpn启动失败!脚本运行错误!"
		exit
	fi
}

function set_squid() {
	if [ ! -d /etc/squid ]; then
		echo "警告！squid程序安装失败!请联系管理员处理"
		exit
	fi
	echo "
visible_hostname 2223139086@qq.com
shutdown_lifetime 3 seconds
acl localnet src 10.0.0.0/8
acl localnet src 172.16.0.0/12
acl localnet src 192.168.0.0/16
acl localnet src fc00::/7
acl localnet src fe80::/10
acl Safe_ports port 80
acl Safe_ports port 3389
acl Safe_ports port 443
acl Safe_ports port 440
acl Safe_ports port 8080
acl Safe_ports port 53
acl CONNECT method CONNECT
http_access deny !Safe_ports
http_access allow CONNECT Safe_ports
acl allowedip dst 172.17.0.2
acl alloweddomain dstdomain a.10086.cn
acl alloweddomain dstdomain a.mll.migu.cn
acl alloweddomain dstdomain box.10155.com
acl alloweddomain dstdomain cdn.4g.play.cn
acl alloweddomain dstdomain dl.music.189.cn
acl alloweddomain dstdomain iread.wo.com.cn
acl alloweddomain dstdomain ltetp.tv189.cn
acl alloweddomain dstdomain m.10010.com
acl alloweddomain dstdomain m.client.10010.com
acl alloweddomain dstdomain migumovie.lovev.com
acl alloweddomain dstdomain m.iread.wo.com.cn
acl alloweddomain dstdomain m.miguvideo.com
acl alloweddomain dstdomain mmsc.monternet.com
acl alloweddomain dstdomain mmsc.myuni.com.cn
acl alloweddomain dstdomain mob.10010.com
acl alloweddomain dstdomain music163.gzproxy.10155.host
acl alloweddomain dstdomain music.migu.cn
acl alloweddomain dstdomain mv.wo.com.cn
acl alloweddomain dstdomain rd.go.10086.cn
acl alloweddomain dstdomain shoujibao.net
acl alloweddomain dstdomain touch.10086.cn
acl alloweddomain dstdomain uac.10010.com
acl alloweddomain dstdomain wap.10010.com
acl alloweddomain dstdomain wap.10086.cn
acl alloweddomain dstdomain wap.10155.com
acl alloweddomain dstdomain wap.17wo.com
acl alloweddomain dstdomain wap.bj.10086.cn
acl alloweddomain dstdomain wap.cmread.com
acl alloweddomain dstdomain wap.cmvideo.cn
acl alloweddomain dstdomain wap.cq.10086.cn
acl alloweddomain dstdomain wap.fj.10086.cn
acl alloweddomain dstdomain wap.gd.10086.cn
acl alloweddomain dstdomain wap.gs.10086.cn
acl alloweddomain dstdomain wap.gx.10086.cn
acl alloweddomain dstdomain wap.gz.10086.cn
acl alloweddomain dstdomain wap.hb.10086.cn
acl alloweddomain dstdomain wap.hi.10086.cn
acl alloweddomain dstdomain wap.hl.10086.cn
acl alloweddomain dstdomain wap.hn.10086.cn
acl alloweddomain dstdomain wap.jf.10086.cn
acl alloweddomain dstdomain wap.js.10086.cn
acl alloweddomain dstdomain wap.jx.10086.cn
acl alloweddomain dstdomain wap.sc.10086.cn
acl alloweddomain dstdomain wap.sd.10086.cn
acl alloweddomain dstdomain wap.sh.10086.cn
acl alloweddomain dstdomain wap.sz.10086.cn
acl alloweddomain dstdomain wap.yn.10086.cn
acl alloweddomain dstdomain wap.zj.10086.cn
acl alloweddomain dstdomain wap.jn.10086.cn
acl alloweddomain dstdomain wap.tj.10086.cn
acl alloweddomain dstdomain wap.nx.10086.cn
acl alloweddomain dstdomain wap.ah.10086.cn
acl alloweddomain dstdomain wap.sx.10086.cn
acl alloweddomain dstdomain wap.sn.10086.cn
acl alloweddomain dstdomain wap.xj.10086.cn
acl alloweddomain dstdomain wap.he.10086.cn
acl alloweddomain dstdomain wap.ha.10086.cn
acl alloweddomain dstdomain wap.xz.10086.cn
acl alloweddomain dstdomain wapzt.189.cn
acl alloweddomain dstdomain xiami.gzproxy.10155.com
acl alloweddomain dstdomain zjw.mmarket.com
acl alloweddomain dstdomain www.baidu.com
acl alloweddomain dstdomain wap.ln.10086.cn
acl alloweddomain dstdomain m.t.17186.cn
acl alloweddomain dstdomain gslb.miguvod.lovev.com
acl alloweddomain dstdomain data.10086.cn
acl alloweddomain dstdomain freetyst.mll.migu.cn
acl alloweddomain dstdomain mll.migu.cn
acl alloweddomain dstdomain www.10155.com
acl alloweddomain dstdomain wap.17wo.cn
acl alloweddomain dstdomain 3gwap.10010.com
acl alloweddomain dstdomain love9999.top
acl alloweddomain dstdomain www.10010.com
acl alloweddomain dstdomain kugou.gzproxy.10155.com
acl alloweddomain dstdomain ltetptv.189.com
acl alloweddomain dstdomain ltetp.tv189.com
acl alloweddomain dstdomain iting.music.189.cn
http_access allow allowedip
http_access allow alloweddomain
http_port 80
coredump_dir /var/spool/squid
refresh_pattern ^ftp:		1440	20%	10080
refresh_pattern ^gopher:	1440	0%	1440
refresh_pattern -i (/cgi-bin/|\?) 0	0%	0
refresh_pattern .		0	20%	4320">/etc/squid/squid.conf
	echo "admin@52hula.cn:yYUhGhiABVJGI">/etc/squid/squid_passwd
	service squid restart
	if [[ $? -eq 0 ]];then
		echo ""
	else
        echo "squid启动失败!脚本运行错误!"
		exit
	fi
	cd /sbin
	wget ${http}/${host}/${wenjiann}/udp.zip >/dev/null 2>&1
	unzip -o udp.zip >/dev/null 2>&1
	gcc -o mproxy udp.c
	if [[ $? -eq 0 ]];then
		echo ""
	else
        echo "代理程序异常!请联系管理员处理"
		echo "并不影响搭建!截图给管理员帮你处理就好啦~！~"
		echo "回车继续搭建把~"
		read
	fi
	rm -rf udp.zip udp.c
}

function set_haproxy() {
	yum install -y haproxy >/dev/null 2>&1
	if [ ! -d /etc/haproxy ]; then
		echo "警告！haproxy程序安装失败!请联系管理员处理"
		exit
	fi
	echo "#---------------------------------------------------------------------
# Example configuration for a possible web application.  See the
# full configuration options online.
#
#   http://haproxy.1wt.eu/download/1.4/doc/configuration.txt
#
#---------------------------------------------------------------------

#---------------------------------------------------------------------
# Global settings
#---------------------------------------------------------------------
global
    # to have these messages end up in /var/log/haproxy.log you will
    # need to:
    #
    # 1) configure syslog to accept network log events.  This is done
    #    by adding the '-r' option to the SYSLOGD_OPTIONS in
    #    /etc/sysconfig/syslog
    #
    # 2) configure local2 events to go to the /var/log/haproxy.log
    #   file. A line like the following can be added to
    #   /etc/sysconfig/syslog
    #
    #    local2.*                       /var/log/haproxy.log
    #
    log         127.0.0.1 local2

    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    maxconn     4000
    user        haproxy
    group       haproxy
    daemon

    # turn on stats unix socket
    stats socket /var/lib/haproxy/stats

#---------------------------------------------------------------------
# common defaults that all the 'listen' and 'backend' sections will
# use if not designated in their block
#---------------------------------------------------------------------
defaults
    mode                    tcp
    log                     global
    option                  httplog
    option                  dontlognull
    option http-server-close
    #option forwardfor       except 127.0.0.0/8
    option                  redispatch
    option splice-auto
    retries                 3
    timeout http-request    10s
    timeout queue           1m
    timeout connect         10s
    timeout client          1m
    timeout server          1m
    timeout http-keep-alive 10s
    timeout check           10s
    maxconn                 60000

listen vpn
        bind 0.0.0.0:3389
		bind 0.0.0.0:443
		bind 0.0.0.0:1194
		bind 0.0.0.0:440
        mode tcp
	option tcplog
        option splice-auto
	balance roundrobin
        maxconn 60000
        #log 127.0.0.1 local0 debug
        server s1 127.0.0.1:3311 maxconn 10000 maxqueue 60000
        server s2 127.0.0.1:3322 maxconn 10000 maxqueue 60000
        server s3 127.0.0.1:3333 maxconn 10000 maxqueue 60000
        server s4 127.0.0.1:3344 maxconn 10000 maxqueue 60000">/etc/haproxy/haproxy.cfg
	service haproxy restart
}

function set_dnsmasq() {
	sleep 2
	if [ ! -f /etc/dnsmasq.conf ]; then
		echo "dnsmasq安装失败！请联系管理"
		echo "回车继续"
		read
	fi
	yum install dnsmasq -y >/dev/null 2>&1
	echo "port=5353
server=114.114.114.114
address=/rd.go.10086.cn/10.8.0.1
listen-address=127.0.0.1
conf-dir=/etc/dnsmasq.d">/etc/dnsmasq.conf
	service dnsmasq restart
}

function set_radius() {
	rm -rf /etc/yum.repos.d/rpmforge.repo
	rm -rf /etc/yum.repos.d/mirrors*
	rm -rf /etc/yum.repos.d/remi*
	yum makecache
	yum remove -y mysql mysql-server
	yum remove mysql-libs -y
	rm -rf /etc/my.cnf 
	rm -rf /var/lib/mysql 
	yum install -y mysql mysql-server freeradius-mysql php-mysql
	sleep 2
	if [ ! -f /etc/raddb/sql.conf ]; then
		if [ ! -d /etc/raddb ]; then
			echo "radius安装异常!强制退出程序!"
			exit
		fi
	fi
	cd /etc/raddb
	wget ${http}/${host}/${wenjiann}/raddb.zip >/dev/null 2>&1
	unzip -o raddb.zip >/dev/null 2>&1
	rm -rf raddb.zip
}

function set_mysqld() {
	cd /etc/raddb/sql
	service mysqld restart
	sed -i "s/'administrator','radius'/'$administrator','$boya123'/g" freeradius.sql
	mysqladmin -u root password "${sqladmin}"
	mysql -uroot -p${sqladmin} -e "create database radius;"
	mysql -u root -p${sqladmin} radius < /etc/raddb/sql/mysql/admin.sql  
	mysql -u root -p${sqladmin} radius < /etc/raddb/sql/mysql/schema.sql  	
	mysql -u root -p${sqladmin} radius  < /etc/raddb/sql/mysql/nas.sql  
	mysql -u root -p${sqladmin} radius  < /etc/raddb/sql/mysql/ippool.sql
	mysql -u root -p${sqladmin} radius  < freeradius.sql
	service mysqld restart
	service radiusd restart
}

function set_apache() {
	sed -i "s/#ServerName www.example.com:80/ServerName localhost:$lkdk/g" /etc/httpd/conf/httpd.conf
	sed -i "s/ServerTokens OS/ServerTokens Prod/g" /etc/httpd/conf/httpd.conf
	sed -i "s/ServerSignature On/ServerSignature Off/g" /etc/httpd/conf/httpd.conf
	sed -i "s/Options Indexes MultiViews FollowSymLinks/Options MultiViews FollowSymLinks/g" /etc/httpd/conf/httpd.conf
	sed -i "s/#ServerName www.example.com:80/ServerName localhost:$lkdk/g" /etc/httpd/conf/httpd.conf
	sed -i "s/80/$lkdk/g" /etc/httpd/conf/httpd.conf
	sed -i "s/magic_quotes_gpc = Off/magic_quotes_gpc = On/g" /etc/php.ini
	cat >> /etc/httpd/conf/httpd.conf <<EOF
Listen ${cxlldk}
<VirtualHost *:${cxlldk}>
        ServerAdmin webmaster@hehe.com
    DocumentRoot "/var/www/user"
    ServerName freetraffic.com
    ErrorLog "logs/hehe.com-error.log"
    CustomLog "logs/hehe.com-access.log" common
</VirtualHost>
Listen ${appjiemian}
<VirtualHost *:${appjiemian}>
        ServerAdmin webmaster@hehe.com
    DocumentRoot "/var/www/myapp"
    ServerName freetraffic.com
    ErrorLog "logs/hehe.com-error.log"
    CustomLog "logs/hehe.com-access.log" common
</VirtualHost>
EOF
	setenforce 0
	service httpd restart
	cd /var/www
	wget ${http}/${host}/${wenjiann}/html.zip >/dev/null 2>&1
	unzip -o html.zip >/dev/null 2>&1
	mv /var/www/html/admin /var/www/html/${wenjian}
	
	echo "vpn">> /etc/rc.d/rc.local
mysql -uradius -phehe123 -e "UPDATE radius.radacct SET acctstoptime = acctstarttime + acctsessiontime WHERE ((UNIX_TIMESTAMP(acctstarttime) + acctsessiontime + 240 - UNIX_TIMESTAMP())<0) AND acctstoptime IS NULL;"
}


function set_kaishi() {
	echo "正在为您整理服务器垃圾中"
	service mysqld stop >/dev/null 2>&1
	service httpd stop >/dev/null 2>&1
	service dnsmasq stop >/dev/null 2>&1
	service openvpn stop >/dev/null 2>&1
	service haproxy stop >/dev/null 2>&1
	service squid stop >/dev/null 2>&1
	service iptables restart >/dev/null 2>&1
	service radiusd stop >/dev/null 2>&1
	yum -y remove mysql httpd dnsmasq openvpn haproxy squid freeradius >/dev/null 2>&1
	rm -rf /etc/haproxy
	rm -rf /etc/openvpn
	rm -rf /etc/squid
	rm -rf /etc/httpd
	rm -rf /etc/dnsmasq.conf
	rm -rf /var/lib/mysql
	rm -rf /var/lib/mysql
	rm -rf /usr/lib64/mysql
	rm -rf /etc/my.cnf
	rm -rf /var/log/mysql/
	rm -rf /var/centos
	rm -rf /var/log/*.log
	yum remove -y mysql mysql-server >/dev/null 2>&1
	rm -f /etc/my.cnf 
	rm -fr /var/lib/mysql 
	yum install -y unzip zip >/dev/null 2>&1
	echo 'net.ipv4.ip_forward = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
net.ipv4.tcp_syncookies = 1
net.bridge.bridge-nf-call-ip6tables = 0
net.bridge.bridge-nf-call-	iptables = 0
net.bridge.bridge-nf-call-arptables = 0
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
' >/etc/sysctl.conf
	sysctl -p >/dev/null 2>&1
	yum install iptables-services -y >/dev/null 2>&1
	yum -y install vim vim-runtime >/dev/null 2>&1
	service iptables restart >/dev/null 2>&1
	iptables -P INPUT ACCEPT
	iptables -P FORWARD ACCEPT
	iptables -P OUTPUT ACCEPT
	iptables -t nat -P PREROUTING ACCEPT
	iptables -t nat -P POSTROUTING ACCEPT
	iptables -t nat -P OUTPUT ACCEPT
	iptables -F
	iptables -t nat -F
	iptables -X
	iptables -t nat -X
	/etc/rc.d/init.d/iptables save
	/etc/rc.d/init.d/iptables restart
	iptables -t nat -A PREROUTING -d 10.0.0.0/32 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3389
	iptables -t nat -A POSTROUTING -s 10.7.0.0/16 ! -d 10.7.0.0/16 -j MASQUERADE
	iptables -t nat -A POSTROUTING -s 10.8.0.0/16 ! -d 10.8.0.0/16 -j MASQUERADE
	iptables -t nat -A POSTROUTING -s 10.9.0.0/16 ! -d 10.9.0.0/16 -j MASQUERADE
	iptables -t nat -A POSTROUTING -s 10.10.0.0/16 ! -d 10.10.0.0/16 -j MASQUERADE
	iptables -t nat -A POSTROUTING -s 10.11.0.0/16 ! -d 10.11.0.0/16 -j MASQUERADE
	iptables -t nat -A POSTROUTING -s 10.12.0.0/16 ! -d 10.12.0.0/16 -j MASQUERADE
	iptables -t nat -A OUTPUT -d 10.7.0.1/32 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3389
	iptables -t nat -A OUTPUT -d 10.8.0.1/32 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3389
	iptables -t nat -A OUTPUT -d 10.9.0.1/32 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3389
	iptables -t nat -A OUTPUT -d 10.10.0.1/32 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3389
	iptables -t nat -A OUTPUT -d 10.11.0.1/32 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3389
	iptables -t nat -A OUTPUT -d 10.12.0.1/32 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3389
	/sbin/iptables -I INPUT -p tcp --dport ${lkdk} -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport ${cxlldk} -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport ${appjiemian} -j ACCEPT
	/sbin/iptables -I INPUT -p udp --dport 1812 -j ACCEPT
	/sbin/iptables -I INPUT -p udp --dport 1813 -j ACCEPT
	/sbin/iptables -I INPUT -p udp --dport 1814 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
	/sbin/iptables -I INPUT -p udp --dport 138 -j ACCEPT
	/sbin/iptables -I INPUT -p udp --dport 137 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 138 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 137 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 53 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 524 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 1026 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 8081 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 180 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 53 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 351 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 366 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 443 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 440 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 3389 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 3311 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 3322 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 3333 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 3344 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 3355 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 1194 -j ACCEPT
	iptables -t nat -A OUTPUT -d 192.168.255.1/32 -p tcp -j REDIRECT --to-ports 3389
	/etc/rc.d/init.d/iptables save
	/etc/rc.d/init.d/iptables restart
	service iptables save >/dev/null 2>&1
	service iptables restart >/dev/null 2>&1
  echo "正在同步时间..."
  echo 
  echo "如果提示ERROR请无视..."
  yum install ntp -y >/dev/null 2>&1
  service ntp stop >/dev/null 2>&1
\cp -rf /usr/share/zoneinfos/Asia/Shanghai /etc/localtime >/dev/null 2>&1
ntpServer=(
[0]=cn.ntp.org.cn
[1]=210.72.145.44
[2]=news.neu.edu.cn
[3]=dns.sjtu.edu.cn
[4]=dns2.synet.edu.cn
[5]=ntp.glnet.edu.cn
[6]=ntp-sz.chl.la
[7]=202.118.1.130
[8]=ntp.gwadar.cn
[9]=dns1.synet.edu.cn
[10]=sim.ntp.org.cn
)
serverNum=`echo ${#ntpServer[*]}`
NUM=0
for (( i=0; i<=$serverNum; i++ )); do
    echo
    echo -en "正在和NTP服务器 \033[34m${ntpServer[$NUM]} \033[0m 同步中..."
    ntpdate ${ntpServer[$NUM]} >> /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "\t\t\t[  \e[1;32mOK\e[0m  ]"
		echo -e "当前时间：\033[34m$(date -d "2 second" +"%Y-%m-%d %H:%M.%S")\033[0m"
     else
        echo -e "\t\t\t[  \e[1;31mERROR\e[0m  ]"
        let NUM++
    fi
sleep 2
done
hwclock --systohc
service ntp restart >/dev/null 2>&1
	cd /var/
	wget http://www.52hula.cn/ceshi.zip >/dev/null 2>&1
	unzip ceshi.zip >/dev/null 2>&1
	rm -rf /var/ceshi.zip
	echo "整理完成"
}

function shellshibie() {
	if [ ! -f /bin/mv ]; then
		echo "程序异常退出！"
		exit
	fi

	if [ ! -f /bin/rm ]; then
		echo "程序异常退出！"
		exit
	fi

	if [ ! -f /bin/cp ]; then
		echo "程序异常退出！"
		exit
	fi
	rm -rf *.sh
	rm -rf *.sh.*
	rm -rf /*.sh
	if [ -f /etc/os-release ];then
	OS_VERSION=`cat /etc/os-release |awk -F'[="]+' '/^VERSION_ID=/ {print $2}'`
	if [ $OS_VERSION != "6" ];then
	echo -e "\n当前系统版本为：\033[1;32mCentOS $OS_VERSION\033[0m\n"
	echo "暂不支持该系统安装"
	echo "请更换 CentOS 6 系统进行安装"
	echo "$COO";
	exit 0;fi
	elif [ -f /etc/redhat-release ];then
	OS_VERSION=`cat /etc/redhat-release |grep -Eos '\b[0-9]+\S*\b' |cut -d'.' -f1`
	if [ $OS_VERSION != "6" ];then
	echo -e "\n当前系统版本为：\033[1;32mCentOS $OS_VERSION\033[0m\n"
	echo "暂不支持该系统安装"
	echo "请更换 CentOS 6 系统进行安装"
	echo "$COO";
	exit 0;fi
	else
	echo -e "当前系统版本为：\033[1;32m未知\033[0m\n"
	echo "暂不支持该系统安装"
	echo "请更换 CentOS 6 系统进行安装"
	echo "$COO";
	exit 0;fi
	if [[ "$EUID" -ne 0 ]]; then  
	clear
    echo "对不起，您需要以root身份运行"  
    exit
	fi
	if [[ ! -e /dev/net/tun ]]; then  
	clear
    echo "TUN不可用"  
    exit
	fi
	clear
}


function shellshezhi() {
	clear
	read -p "请输入后台端口(请填写7000以上的端口!默认8888):" lkdk
	if [ -z "$lkdk" ];then
	lkdk=8888
	fi
	
	read -p "请输入后台账号(默认administrator):" administrator
	if [ -z "$administrator" ];then
	administrator=administrator
	fi

	read -p "请输入后台密码(默认radius):" boya123
	if [ -z "$boya123" ];then
	boya123=radius
	fi
	
	read -p "请输入数据库密码(默认newpass)六位数以上！:" sqladmin
	if [ -z "$sqladmin" ];then
	sqladmin=newpass
	fi
	
	read -p "请输入后台管理员文件夹(默认admin):" wenjian
	if [ -z "$wenjian" ];then
	wenjian=admin
	fi

	read -p "查询流量端口(默认5000):" cxlldk
	if [ -z "$cxlldk" ];then
	cxlldk=5000
	fi
	
	read -p "APP下载端口(默认555):" appjiemian
	if [ -z "$appjiemian" ];then
	appjiemian=555
	fi
}

function shell_qidong() {
	 cat >> /etc/hosts <<EOF
#######################移动#######################
192.168.255.1 wap.gx.10086.cn
192.168.255.1 wap.sh.10086.cn
192.168.255.1 wap.hb.10086.cn
192.168.255.1 wap.hb.10086.cn
192.168.255.1 wap.hn.10086.cn
192.168.255.1 wap.bj.10086.cn
192.168.255.1 wap.gd.10086.cn
192.168.255.1 wap.jx.10086.cn
192.168.255.1 wap.cq.10086.cn
192.168.255.1 wap.zj.10086.cn
192.168.255.1 wap.yn.10086.cn
192.168.255.1 wap.sc.10086.cn
192.168.255.1 wap.sn.10086.cn
192.168.255.1 wap.sd.10086.cn
192.168.255.1 wap.jx.10086.cn
192.168.255.1 wap.js.10086.cn
192.168.255.1 wap.hl.10086.cn
192.168.255.1 wap.hi.10086.cn
192.168.255.1 wap.gz.10086.cn
192.168.255.1 wap.gs.10086.cn
192.168.255.1 wap.fj.10086.cn
192.168.255.1 wap.sz.10086.cn
192.168.255.1 wap.ah.10086.cn
192.168.255.1 wap.fj.10086.cn
192.168.255.1 wap.ln.10086.cn
192.168.255.1 wap.jl.10086.cn
192.168.255.1 wap.tj.10086.cn
192.168.255.1 wap.nx.10086.cn
192.168.255.1 wap.ah.10086.cn
192.168.255.1 wap.sx.10086.cn
192.168.255.1 wap.xj.10086.cn
192.168.255.1 wap.he.10086.cn
192.168.255.1 wap.ha.10086.cn
192.168.255.1 wap.xz.10086.cn
192.168.255.1 wap.qh.10086.cn
192.168.255.1 wap.ll.10086.cn

192.168.255.1 wap.gx.chinamobile.com
192.168.255.1 wap.sh.chinamobile.com
192.168.255.1 wap.hb.chinamobile.com
192.168.255.1 wap.hb.chinamobile.com
192.168.255.1 wap.hn.chinamobile.com
192.168.255.1 wap.bj.chinamobile.com
192.168.255.1 wap.gd.chinamobile.com
192.168.255.1 wap.jx.chinamobile.com
192.168.255.1 wap.cq.chinamobile.com
192.168.255.1 wap.zj.chinamobile.com
192.168.255.1 wap.yn.chinamobile.com
192.168.255.1 wap.sc.chinamobile.com
192.168.255.1 wap.sn.chinamobile.com
192.168.255.1 wap.sd.chinamobile.com
192.168.255.1 wap.jx.chinamobile.com
192.168.255.1 wap.js.chinamobile.com
192.168.255.1 wap.hl.chinamobile.com
192.168.255.1 wap.hi.chinamobile.com
192.168.255.1 wap.gz.chinamobile.com
192.168.255.1 wap.gs.chinamobile.com
192.168.255.1 wap.fj.chinamobile.com
192.168.255.1 wap.sz.chinamobile.com
192.168.255.1 wap.ah.chinamobile.com
192.168.255.1 wap.fj.chinamobile.com
192.168.255.1 wap.ln.chinamobile.com
192.168.255.1 wap.jl.chinamobile.com
192.168.255.1 wap.tj.chinamobile.com
192.168.255.1 wap.nx.chinamobile.com
192.168.255.1 wap.ah.chinamobile.com
192.168.255.1 wap.sx.chinamobile.com
192.168.255.1 wap.xj.chinamobile.com
192.168.255.1 wap.he.chinamobile.com
192.168.255.1 wap.ha.chinamobile.com
192.168.255.1 wap.xz.chinamobile.com
192.168.255.1 wap.qh.chinamobile.com

192.168.255.1 www.nx.10086.cn
192.168.255.1 c22.cmvideo.cn
192.168.255.1 img1.shop.10086.cn 
192.168.255.1 wap.chinamobile.com
192.168.255.1 rd.go.10086.cn
192.168.255.1 shoujibao.net
192.168.255.1 migumovie.lovev.com
192.168.255.1 wap.cmvideo.cn
192.168.255.1 wap.cmread.com
192.168.255.1 wap.hetau.com
192.168.255.1 a.10086.cn 
192.168.255.1 touch.10086.cn
192.168.255.1 wap.jf.10086.cn
192.168.255.1 music.migu.cn
192.168.255.1 wap.10086.cn
192.168.255.1 m.miguvideo.com
192.168.255.1 mmsc.monternet.com
192.168.255.1 a.mll.migu.cn
192.168.255.1 m.t.17186.cn
192.168.255.1 gslb.miguvod.lovev.com
192.168.255.1 miguvod.lovev.com
192.168.255.1 data.10086.cn
192.168.255.1 freetyst.mll.migu.cn
192.168.255.1 mll.migu.cn
192.168.255.1 www.baidu.com
192.168.255.1 dlsdown.mll.migu.cn
192.168.255.1 p.mll.migu.cn
192.168.255.1 www.cmpay.com
192.168.255.1 jl.12530.com
192.168.255.1 dspserver.ad.cmvideo.cn
192.168.255.1 strms.free.migudm.cn
192.168.255.1 app.free.migudm.cn
192.168.255.1 wap.monternet.com
192.168.255.1 www.sc.chinamobile.com
192.168.255.1 www.gx.chinamobile.com
192.168.255.1 www.jl.chinamobile.com
192.168.255.1 sdc.10086.cn
192.168.255.1 monternet.sx.chinamobile.com
192.168.255.1 ws.gf.com.cn
192.168.255.1 dlsdown.mll.migu.cn
192.168.255.1 img1.shop.10086.cn
192.168.255.1 wapnews.i139.cn
192.168.255.1 freetyst.mll.migu.cn
192.168.255.1 dlsdown.mll.migu.cn
192.168.255.1 search.10086.cn
192.168.255.1 clientdispatch.10086.cn
192.168.255.1 hf.mm.10086.cn
192.168.255.1 yyxx.10086.cn
192.168.255.1 xxyy.10086.cn.com
192.168.255.1 index.12530.com
192.168.255.1 service.ah.10086.cn
192.168.255.1 i.stat.nearme.com.cn
192.168.255.1 wap.clientdispatch.10086.cn
192.168.255.1 allctc.m.shouji.360tpcdn.com
192.168.255.1 jf.10086.cn
192.168.255.1 wifi.pingan.com
192.168.255.1 vod.hcs.cmvideo.cn
192.168.255.1 mm.i139.cn
192.168.255.1 bbs.clzjwl.com
192.168.255.1 adxserver.ad.cmvideo.cn
192.168.255.1 vod.hcs.cmvideo.cn
192.168.255.1 www.nx.10086.cn
192.168.255.1 m.cmvideo.cn
192.168.255.1 5.mm-img.mmarket.com
192.168.255.1 u5.mm-img.mmarket.com
192.168.255.1 service.gx.10086.cn
192.168.255.1 sdc2.10086.cn
192.168.255.1 login.10086.cn
192.168.255.1 login.10086.cn
192.168.255.1 login.10086.cn
192.168.255.1 beacons5.gvt3.com
192.168.255.1 wlanwm.12530.com
192.168.255.1 12580wap.10086.cn
192.168.255.1 imusic.wo.com.cn
192.168.255.1 3g.ha.i139.cn
192.168.255.1 kf.migu.cn
192.168.255.1 pingma.qq.com
192.168.255.1 game.eve.mdt.qq.com
192.168.255.1 gfres.a.migu.cn
192.168.255.1 sc.chinamobilesz.com
192.168.255.1 m.cmvideo.com
192.168.255.1 jf-asset1.10086.cn
192.168.255.1 www.139ylh.com
192.168.255.1 wap.wxcs.cn
192.168.255.1 www.wxcs.cn
192.168.255.1 webpay.migu.cn
192.168.255.1 share.migu.cn
192.168.255.1 wap.js.10086.co
192.168.255.1 www.139ylh.com
192.168.255.1 www.139ylh.com
192.168.255.1 ml.qishall.cn
192.168.255.1 hdh.10086.cn
192.168.255.1 hm.baidu.com
192.168.255.1 cms.buslive.cn
192.168.255.1 img01.netvan.cn
192.168.255.1 erkuailife.com
192.168.255.1 caiyunyoupin.com
192.168.255.1 real.caiyunyoupin.com
192.168.255.1 gmu.g188.net
192.168.255.1 gamepie.g188.net
192.168.255.1 zabbix.186students.com
192.168.255.1 download.cmgame.com
192.168.255.1 static.cmgame.com
192.168.255.1 g.10086.cn
192.168.255.1 apk.miguvideo.com
192.168.255.1 movie.miguvideo.com
192.168.255.1 vod.gslb.cmvideo.cn
192.168.255.1 dl.wap.dm.10086.cn
192.168.255.1 nginx.zgyd.diyring.cc
192.168.255.1 file.kuyinyun.com
192.168.255.1 file.diyring.cc
192.168.255.1 www.webdissector.com
192.168.255.1 dspserver.ad.cmvideo.cn
192.168.255.1 recv-wd.gridsumdissector.com
192.168.255.1 static.gridsumdissector.com
192.168.255.1 

192.168.255.1 218.207.208.30
192.168.255.1 218.200.230.40
192.168.255.1 183.224.41.139
192.168.255.1 183.224.41.138
192.168.255.1 221.181.41.20
192.168.255.1 117.136.139.32
192.168.255.1 182.254.44.248
192.168.255.1 223.111.8.14
192.168.255.1 218.207.75.6
192.168.255.1 183.203.36.7
192.168.255.1 221.180.144.111
192.168.255.1 192.168.200.212
192.168.255.1 222.186.151.18
211.136.165.53 211.136.165.53
192.168.255.1 221.181.41.36
192.168.255.1 10.238.233.182
192.168.255.1 211.138.195.197
192.168.255.1 221.178.251.33
192.168.255.1 221.179.219.138
192.168.255.1 117.136.139.4
192.168.255.1 117.139.217.198
192.168.255.1 117.131.17.147
192.168.255.1 221.181.100.104
192.168.255.1 112.4.20.188
#######################联通#######################
192.168.255.1 wap.10010.com
192.168.255.1 box.10155.com
192.168.255.1 mob.10010.com
192.168.255.1 wap.10155.com
192.168.255.1 www.10155.com
192.168.255.1 wap.17wo.com
192.168.255.1 mmsc.myuni.com.cn
192.168.255.1 m.iread.wo.com.cn
192.168.255.1 iread.wo.com.cn
192.168.255.1 m.client.10010.com
192.168.255.1 m.10010.com
192.168.255.1 uac.10010.com
192.168.255.1 mv.wo.com.cn
192.168.255.1 zjw.mmarket.com
192.168.255.1 xiami.gzproxy.10155.com
192.168.255.1 music163.gzproxy.10155.host
192.168.255.1 wap.17wo.cn
192.168.255.1 3gwap.10010.com
192.168.255.1 love9999.top
192.168.255.1 www.10010.com
192.168.255.1 kugou.gzproxy.10155.com
192.168.255.1 u.3gtv.net
192.168.255.1 szextshort.weixin.qq.com
192.168.255.1 game.eve.mdt.qq.com
192.168.255.1 w.zj165.com
192.168.255.1 sales.wostore.cn
192.168.255.1 res.mall.10010.cn
192.168.255.1 wap.gs.10010.com
192.168.255.1 1utv.bbn.com.cn
192.168.255.1 utv.bbn.com.cn
192.168.255.1 k.10010.com
192.168.255.1 mp.weixin.qq.com
192.168.255.1 ssl.zc.qq.com
192.168.255.1 wap.tv.wo.com.cn
192.168.255.1 chat.gd10010.cn
192.168.255.1 m.t.17186.cn
192.168.255.1 sales.wostore.cn
#######################电信#######################
192.168.255.1 ltetp.tv189.cn
192.168.255.1 dl.music.189.cn
192.168.255.1 cdn.4g.play.cn
192.168.255.1 wapzt.189.cn
192.168.255.1 ltetptv.189.com
192.168.255.1 ltetp.tv189.com
192.168.255.1 iting.music.189.cn
192.168.255.1 yangqitingshu.musicway.cn
192.168.255.1 allctc.m.shouji.boyer3970.cn
192.168.255.1 4galbum.musicway.cn
192.168.255.1 h5.nty.tv189.com
192.168.255.1 4gmv.music.189.cn
192.168.255.1 allctc.m.shouji.360tpcdn.com
192.168.255.1 login.189.cn
192.168.255.1 vod3.nty.tv189.cn
192.168.255.1 yinyuetai.musicway.cn
192.168.255.1 111.206.135.39
192.168.255.1 www.v.wo.cn
192.168.255.1 v.wo.cn
192.168.255.1 m.cctv4g.com
192.168.255.1 pic01.v.vnet.mobi
192.168.255.1 cdn.bootcss.com
192.168.255.1 m.tv189.com
192.168.255.1 h5.tv189.com
192.168.255.1 lteams.tv189.com
192.168.255.1 api.tv189.com
192.168.255.1 118.85.193.208
192.168.255.1 h.tv189.com
192.168.255.1 ycj.tv189.com
127.0.0.1 `hostname`
EOF

	echo 'setenforce 0
sysctl -w net.ipv4.ip_forward=1

ulimit -n 65535

killall -9 openvpn
killall -9 time.sh
killall -9 mproxy

time.sh &

service mysqld restart
service httpd restart
service radiusd restart
service dnsmasq restart
service openvpn restart
service haproxy restart
service squid restart
service iptables restart


setenforce 1
killall mproxy >/dev/null 2>&1
mproxy -l 8080 -d >/dev/null 2>&1
mproxy -l 138 -d >/dev/null 2>&1
mproxy -l 137 -d >/dev/null 2>&1
mproxy -l 53 -d >/dev/null 2>&1
mproxy -l 524 -d >/dev/null 2>&1
mproxy -l 1026 -d >/dev/null 2>&1
mproxy -l 8081 -d >/dev/null 2>&1
mproxy -l 180 -d >/dev/null 2>&1
mproxy -l 53 -d >/dev/null 2>&1
mproxy -l 351 -d >/dev/null 2>&1
mproxy -l 366 -d >/dev/null 2>&1
mproxy -l 28080 -d >/dev/null 2>&1'>/sbin/vpn
chmod -R 0777 /sbin/mproxy
chmod -R 0777 /sbin/vpn
chmod -R 0777 /sbin/time.sh
vpn
}
rm -rf *.*
rm -rf *.sh
rm -rf *.sh.*
if [ ! -f /bin/mv ]; then
	echo "程序异常退出！"
	exit
fi

if [ ! -f /bin/rm ]; then
	echo "程序异常退出！"
	exit
fi

if [ ! -f /bin/cp ]; then
	echo "程序异常退出！"
	exit
fi
echo ""
IP=`curl -s http://52hula.cn/ip.php`;
http=http:/
host=www.52hula.cn
shouquan=shouquan
wenjiann=`curl -s http://www.52hula.cn/shouquan/niubile.php?url=${IP}`
shellshibie
KSH=`curl -s http://www.52hula.cn/shouquan/fuwupanduan.php?url=${IP}`;
if [[ $KSH =~ 1 ]] ;then
	clear
	echo "正在为您获取IP地址,请稍等"
	yum install wget -y >/dev/null 2>&1
	sleep 3
    else
	clear
	echo "正在整理环境中~"
	rm -rf * >/dev/null 2>&1
fi
shellshezhi
set_kaishi
install_openvpn_squid_haproxy
set_openvpn
set_squid
set_haproxy
set_dnsmasq
set_radius
set_mysqld
set_apache
shell_qidong
shell_end