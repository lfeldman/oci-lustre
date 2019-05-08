#!/bin/bash
## cloud-init bootstrap script

set -x 

## Stop SSHD to prevent remote execution during this process
systemctl stop sshd


THIS_FQDN=`hostname --fqdn`
THIS_HOST=$${THIS_FQDN%%.*}

#######################################################"
################# Turn Off the Firewall ###############"
#######################################################"
echo "Turning off the Firewall..."
which apt-get &> /dev/null
if [ $? -eq 0 ] ; then
    echo "" > /etc/iptables/rules.v4
    echo "" > /etc/iptables/rules.v6

    iptables -F
    iptables -X
    iptables -t nat -F
    iptables -t nat -X
    iptables -t mangle -F
    iptables -t mangle -X
    iptables -P INPUT ACCEPT
    iptables -P OUTPUT ACCEPT
    iptables -P FORWARD ACCEPT
else
    service firewalld stop
    chkconfig firewalld off
fi

#######################################################"
#################   Update resolv.conf  ###############"
#######################################################"
## Modify resolv.conf to ensure DNS lookups work from one private subnet to another subnet
#cp /etc/resolv.conf /etc/resolv.conf.backup
#rm -f /etc/resolv.conf
#echo "search ${PrivateSubnetsFQDN}" > /etc/resolv.conf
#echo "nameserver 169.254.169.254" >> /etc/resolv.conf

#######################################################"



which apt-get &> /dev/null
if [ $? -eq 0 ] ; then
    echo "apt-get Ubuntu EL"
else
    echo "yum EL" 
fi




cat > /etc/yum.repos.d/lustre.repo << EOF
[hpddLustreserver]
name=CentOS- - Lustre
baseurl=https://downloads.whamcloud.com/public/lustre/latest-release/el7.6.1810/server/
gpgcheck=0

[e2fsprogs]
name=CentOS- - Ldiskfs
baseurl=https://downloads.whamcloud.com/public/e2fsprogs/latest/el7/
gpgcheck=0

[hpddLustreclient]
name=CentOS- - Lustre
baseurl=https://downloads.whamcloud.com/public/lustre/latest-release/el7.6.1810/client/
gpgcheck=0
EOF

sudo yum install lustre-tests -y

cp /etc/selinux/config /etc/selinux/config.backup
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

setenforce 0

touch /tmp/complete

echo "complete.  rebooting now"
reboot 
set +x 