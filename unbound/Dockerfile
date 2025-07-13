FROM alpine:latest

COPY unbound.conf /etc/unbound/unbound.conf
COPY unbound.d/*.conf /etc/unbound/unbound.d/
COPY startup.sh /etc/unbound/startup.sh

RUN apk add --no-cache drill unbound \
  && wget -S https://www.internic.net/domain/named.cache -O /etc/unbound/root.hints \
  && mkdir /var/log/unbound \
  && chown unbound:unbound /var/log/unbound \
  && chmod +x /etc/unbound/startup.sh \
  && rm -rf /var/cache/apk/*

EXPOSE 5335/tcp
EXPOSE 5335/udp

ENTRYPOINT ["/etc/unbound/startup.sh"]
CMD ["-d", "-c", "/etc/unbound/unbound.conf"]
