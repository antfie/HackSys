## Building

```
docker pull alpine
docker build -t antfie/haksys .
```

## Running 

## VPN

```
docker run -it --rm -v $PWD/antfie.ovpn:/app/vpn --cap-add=NET_ADMIN --device /dev/net/tun --name vpn -p 9000-9100:9000-9100 --sysctl net.ipv6.conf.all.disable_ipv6=0 --entrypoint openvpn antfie/haksys vpn
```

## SOCKS5 Proxy (For Burp)

```
docker run --rm -it --network=container:vpn --name proxy --entrypoint ssh-proxy antfie/haksys
```

## Host

```
docker run --rm -it --network=container:vpn -v $PWD:/app antfie/haksys
```

## Other Tools


### Metasploit

```
docker pull metasploitframework/metasploit-framework
docker run --rm -it --network=container:vpn -v $PWD:/app metasploitframework/metasploit-framework
```

### Kali

```
docker pull kalilinux/kali-rolling
docker run --rm -it --network=container:vpn -v $PWD:/app kalilinux/kali-rolling
```

## Docker

Remove all containers and images

```
docker rm -f $(docker ps -a -q)
docker rmi $(docker images -q)
```
