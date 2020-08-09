#!/usr/bin/env sh

# Reference https://www.howtogeek.com/168145/how-to-use-ssh-tunneling/

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
/usr/sbin/sshd
echo "Starting SSH proxy on port 9090"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /root/id -D `/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`:9090 -N ssh@127.0.0.1