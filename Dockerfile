FROM alpine

# Package dependencies
# exploitdb: libxml2-utils, ncurses
# sqlmap: libxml2-utils python3-dev libxml2-dev libxslt-dev libffi-dev
# wfuzz: py-curl

# Pip dependencies
# impacket: flask ldap3 ldapdomaindump pycryptodomex
# wfuzz: shodan

# Ruby dependencies
# CeWL: exiftool, json gem
# evil-winrm: krb5 bigdecimal gem

RUN apk update && apk upgrade && apk add openvpn nmap nmap-scripts git tmux zsh zsh-syntax-highlighting zsh-autosuggestions lynx python3 python3-dev \
    libxml2-utils libxml2-dev libxslt-dev libffi-dev py-pip openssl-dev htop curl openssl vim file go nikto python2 python2-dev iptraf-ng jq \
    openssh bash py3-impacket tcpdump ncurses exiftool john openjdk10 which radare2 ruby ruby-bundler ruby-dev make krb5 py-curl bind-tools php \
    && python3 -m pip install --upgrade requests colorama beautifulsoup4 scrapy sqlmap flask flask_cors ldap3 ldapdomaindump pycryptodomex wfuzz shodan coloredlogs jsbeautifier websocket-client \
    && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python2 get-pip.py && rm get-pip.py && python2 -m pip install requests colorama beautifulsoup4 scrapy coloredlogs \
    && gem install json evil-winrm bigdecimal \
    && ln -sf /usr/bin/python3 /usr/local/bin/python \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && go get github.com/OJ/gobuster \
    && git clone --depth=1 https://github.com/SecureAuthCorp/impacket.git /tools/impacket && rm -rf /tools/impacket/.git && cd /tools/impacket && pip install . \
    && git clone --depth=1 https://github.com/danielmiessler/SecLists.git /tools/SecLists && rm -rf /tools/SecLists/.git \
    && git clone --depth=1 https://github.com/offensive-security/exploitdb.git /opt/exploitdb && rm -rf /opt/exploitdb/.git && ln -sf /opt/exploitdb/searchsploit /usr/local/bin/searchsploit \
    && git clone --depth=1 https://github.com/digininja/CeWL.git /tools/CeWL && rm -rf /tools/CeWL/.git && cd /tools/CeWL && bundle update --bundler && bundle install \
    && ln -sf /tools/CeWL/cewl.rb /usr/local/bin/cewl \
    && ln -sf /usr/bin/nikto.pl /usr/local/bin/nikto \
    && ln -sf /usr/bin/vim /usr/bin/vi \
    && echo "export PATH=/usr/lib/jvm/default-jvm/bin:~/go/bin:$PATH" >> ~/.bashrc \
    && echo "StrictHostKeyChecking accept-new" >> /etc/ssh/ssh_config \
    && echo "LogLevel=Error" >> /etc/ssh/ssh_config

# TODO:
#     && git clone --depth=1 gttps://github.com/lgandx/Responder.git /tools/responder \

COPY zshrc /root/.zshrc
COPY impacket.sh /usr/local/bin/impacket-smbserver
COPY impacket.sh /usr/local/bin/impacket-wmiexec
COPY impacket.sh /usr/local/bin/impacket-psexec

COPY ssh-proxy.sh /usr/local/bin/proxy
COPY ssh-fwd.sh /usr/local/bin/fwd

ENV TERM xterm-256color
ENV JAVA_HOME /usr/lib/jvm/default-jvm

WORKDIR /app

ENTRYPOINT ["/bin/zsh"]