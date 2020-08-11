#!/usr/bin/env bash

# Find next free local port
lport=15820
free_port=$(netstat -lntu | grep $lport)
while [[ -n "$free_port" ]]; do
    lport=$((lport+1))
    free_port=$(netstat -taln | grep $lport)
done

# Find next free exposed port
eport=9000
free_port=$(netstat -lntu | grep $eport)
while [[ -n "$free_port" ]]; do
    eport=$((eport+1))
    free_port=$(netstat -taln | grep $eport)
done

ssh-keygen -A
adduser -D ssh
passwd ssh -d
ssh-keygen -f /root/id -P ""
mkdir /home/ssh/.ssh
mv /root/id.pub /home/ssh/.ssh/authorized_keys
chown -R ssh:ssh /home/ssh/.ssh
chmod 700 /home/ssh/.ssh
chmod 644 /home/ssh/.ssh/authorized_keys
sed -i 's/AllowTcpForwarding no/AllowTcpForwarding yes/g' /etc/ssh/sshd_config
echo "ListenAddress 127.0.0.1" >> /etc/ssh/sshd_config
echo "Port $lport" >> /etc/ssh/sshd_config
/usr/sbin/sshd

echo -e "\e[92mForwarding $FWD_TO to port $eport\e[0m"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /root/id -L `/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`:$eport:$FWD_TO -N -p $lport ssh@127.0.0.1
