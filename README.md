# Secure recursive DNS resolver with pi-hole

Docker based stack with [Unbound recursive DNS resolver](https://unbound.docs.nlnetlabs.nl/en/latest/index.html)
and [pi-hole ad blocker](https://pi-hole.net/).

## Goals

- optimize privacy:
  - DNS sink to filter/block unwanted content
  - a recursive DNS with DNSSEC to shield visited sites from ISP's DNS
- docker-based for easy initial deployment and low-friction, regular updates
- forwarding to local DHCP/DNS host (e.g. Ubiquiti UDM) to resolve local network names
- TODO: deployable and upgradable via separate docker image on minimal config, immutable Ubuntu Core node
(no git nor curl etc. installed on docker host)

## local test for pihole

```bash
docker compose build
docker compose stop
docker compose up -d
docker compose ps
docker image prune -f --filter 'dangling=true'
dig -p 5300 @localhost github.com
```

test DNSSEC:

```bash
dig -p 5300 @localhost SOA com. +dnssec
dig -p 5300 @localhost cloudflare.com +dnssec
```

directly connect to container:

```bash
docker exec -it dns ash
```

## Deployment

### Manual deployment

- git clone this repo (or [download main branch as zip, then unzip](https://github.com/davidjenni/pi-hole-unbound/archive/refs/heads/main.zip))
- Create your own *.prod.env file, use the checked in jenni.prod.env as starting point
- re-start compose stack (build & pull before stopping the already running DNS server!):

```bash
docker compose --env-file lan.prod.env build --pull && \
docker compose --env-file lan.prod.env stop && \
docker compose --env-file lan.prod.env up -d --wait && \
docker compose ps
```

## TODOs

There's still work left, see [Issues](https://github.com/davidjenni/pi-hole-unbound/issues?q=is%3Aissue%20state%3Aopen%20label%3Afeature)

Any bugs, file via [Issues](https://github.com/davidjenni/pi-hole-unbound/issues).

## References

- [DNSSEC query and response process](https://learn.microsoft.com/en-us/windows-server/networking/dns/validate-dnssec-responses#including-dnssec-data)
- [DNSSEC troubleshooting with dig](https://developers.cloudflare.com/dns/dnssec/troubleshooting/#view-the-dnssec-chain-of-trust-with-dig)
