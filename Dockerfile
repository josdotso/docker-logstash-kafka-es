FROM java:openjdk-8-jre-alpine
MAINTAINER joway@okjike.com

ENV LOGSTASH_PKG_NAME logstash-5.3.2

# Install Logstash
RUN apk add --update curl bash ca-certificates
RUN \
  ( curl -Lskj http://artifacts.elastic.co/downloads/logstash/$LOGSTASH_PKG_NAME.tar.gz | \
  gunzip -c - | tar xf - ) && \
  mv $LOGSTASH_PKG_NAME /logstash && \
  rm -rf $(find /logstash | egrep "(\.(exe|bat)$|sigar/.*(dll|winnt|x86-linux|solaris|ia64|freebsd|macosx))") && \
  apk del curl wget

COPY run.sh /run.sh
RUN chmod +x /run.sh

COPY config/ /logstash/config/

VOLUME ["/logstash/certs"]

ENTRYPOINT ["/run.sh"]
