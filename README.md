# Secure recursive DNS resolver with pi-hole

Docker based stack with [Unbound recursive DNS resolver](https://unbound.docs.nlnetlabs.nl/en/latest/index.html)
and [pi-hole ad blocker](https://pi-hole.net/).

## Goals

- optimize privacy:
  - DNS sink to filter/block unwanted content
  - a recursive DNS with DNSSEC to shield visited sites from ISP's DNS
- docker-based for easy initial deployment and low-friction, regular updates
- deployable and upgradable via separate docker image on minimal config, immutable Ubuntu Core node
(no git, curl etc. installed on docker host)
- local DNS forwarding to local DHCP/DNS host (e.g. Ubiquiti UDM) to resolve local network names

## local test for unbound

```bash
docker compose build
docker compose stop
docker compose up -d
docker compose ps
docker image prune -f --filter 'dangling=true'
dig -p 5335 @localhost github.com
```

test DNSSEC:

```bash
dig -p 5335 @localhost SOA com. +dnssec
dig -p 5335 @localhost cloudflare.com +dnssec
```

directly connect to container:

```bash
docker exec -it dns sh
```

## References

- [DNSSEC query and response process](https://learn.microsoft.com/en-us/windows-server/networking/dns/validate-dnssec-responses#including-dnssec-data)
- [DNSSEC troubleshooting with dig](https://developers.cloudflare.com/dns/dnssec/troubleshooting/#view-the-dnssec-chain-of-trust-with-dig)
