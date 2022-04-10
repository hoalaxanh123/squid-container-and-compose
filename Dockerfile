FROM alpine:3.7

# Fix CEV https://security.alpinelinux.org/vuln/CVE-2019-14697
RUN apk upgrade musl

LABEL maintainer="alatas@gmail.com, edit by Vuong Nguyen"

#set enviromental values for certificate CA generation
ENV CN="mrv-proxy.local" \
    O="Mr.V Proxy Container" \
    OU="Mr.V dev (proxy)" \
    C=US \
    L=Toronto \
    ST=ON

#set proxies for alpine apk package manager
ARG all_proxy 

ENV http_proxy=$all_proxy \
    https_proxy=$all_proxy

RUN apk add --no-cache \
    squid=3.5.27-r1  \
    openssl=1.0.2t-r0 \
    ca-certificates && \
    update-ca-certificates
# Extend tools
RUN apk add --no-cache \
    curl \
    wget \
    nano

COPY start.sh /usr/local/bin/
COPY openssl.cnf.add /etc/ssl
COPY conf/squid*.conf /etc/squid/

RUN cat /etc/ssl/openssl.cnf.add >> /etc/ssl/openssl.cnf

RUN chmod +x /usr/local/bin/start.sh

# No SLL
EXPOSE 3128 

# SSL- BUMP
EXPOSE 4128

# SSL
EXPOSE 5128

ENTRYPOINT ["/usr/local/bin/start.sh"]