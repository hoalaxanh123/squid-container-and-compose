FROM alpine:3.7

# Fix CEV https://security.alpinelinux.org/vuln/CVE-2019-14697
RUN apk upgrade musl

LABEL maintainer="alatas@gmail.com, edit by Vuong Nguyen"

#set enviromental values for certificate CA generation
ENV CN=mrv.local \
    O=mrv \
    OU=mrv.dev \
    C=US

#set proxies for alpine apk package manager
ARG all_proxy 

ENV http_proxy=$all_proxy \
    https_proxy=$all_proxy

RUN apk add --no-cache \
    squid=3.5.27-r1  \
    openssl=1.0.2t-r0 \
    ca-certificates && \
    update-ca-certificates

COPY start.sh /usr/local/bin/
COPY openssl.cnf.add /etc/ssl
COPY conf/squid*.conf /etc/squid/

RUN cat /etc/ssl/openssl.cnf.add >> /etc/ssl/openssl.cnf

RUN chmod +x /usr/local/bin/start.sh

EXPOSE 3128
EXPOSE 4128

ENTRYPOINT ["/usr/local/bin/start.sh"]