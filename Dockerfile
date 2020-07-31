FROM alpine

# ~3.56GB

# Package dependencies
# exploitdb: libxml2-utils, ncurses
# sqlmap: libxml2-utils python3-dev libxml2-dev libxslt-dev libffi-dev

# Pip dependencies
# impacket: flask ldap3 ldapdomaindump pycryptodomex

RUN apk update && apk upgrade && apk add openvpn nmap nmap-scripts git tmux zsh lynx python3 \
    libxml2-utils python3-dev libxml2-dev libxslt-dev libffi-dev py-pip openssl-dev htop curl openssl vim file go nikto \
    openssh bash py3-impacket tcpdump ncurses exiftool john openjdk10 which radare2 \
    && pip install --upgrade requests colorama beautifulsoup4 scrapy sqlmap flask ldap3 ldapdomaindump pycryptodomex \
    && ln -sf /usr/bin/python3 /usr/local/bin/python \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && go get github.com/OJ/gobuster \
    && git clone https://github.com/danielmiessler/SecLists.git /tools/SecLists \
    && git clone https://github.com/offensive-security/exploitdb.git /opt/exploitdb \
    && ln -sf /opt/exploitdb/searchsploit /usr/local/bin/searchsploit \
    && ln -sf /usr/bin/nikto.pl /usr/local/bin/nikto \
    && ln -sf /usr/bin/vim /usr/bin/vi \
    && echo -n 'export PATH=/usr/lib/jvm/default-jvm/bin:~/go/bin:$PATH' >> ~/.zshrc \
    && echo -n 'export PATH=/usr/lib/jvm/default-jvm/bin:~/go/bin:$PATH' >> ~/.bashrc

COPY ssh-proxy.sh /usr/local/bin/ssh-proxy

ENV TERM xterm-256color
ENV JAVA_HOME /usr/lib/jvm/default-jvm

WORKDIR /app

ENTRYPOINT ["/bin/zsh"]