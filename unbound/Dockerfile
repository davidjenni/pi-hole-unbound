FROM alpine:latest

COPY unbound.conf /etc/unbound/unbound.conf
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

# Healthcheck to ensure Unbound is running
HEALTHCHECK --interval=30s --timeout=20s --start-period=10s \
  CMD drill -p 5335 github.com @127.0.0.1 || exit 1
