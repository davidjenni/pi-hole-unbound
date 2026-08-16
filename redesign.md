# Proposal to redesign pihole-unbound services

## Motivation

The current repo intermixes the 3 services with their invariant configuration
with site-specific configuration, e.g.:

- node names
- admin web GUI password
- which local VLANs exist,
- which internal (Ubiquiti) router/DNS to forward private address lookups
  `/api/config/dns/revServers`
- site-specific domain allowlists or to which published block lists to subscribe to

## Proposal

This repos will only contain the docker compose config for the 3 services
(traefik, unbound, pihole). All its config is site-invariant.

A forth 'site-config' service is added: it uses pihole's REST API
<http://localhost/pihole/api/docs> and <https://docs.pi-hole.net/api/>
to config the running pihole service; similarly.
The unbound service will have its unbound.d/lan.local.conf file modified
to inject the actual internal DNS server.
See also [unbound-control](https://unbound.docs.nlnetlabs.nl/en/latest/manpages/unbound-control.html#unbound-control-commands-reload)

This will require a new site-configuration file format, likely yaml or toml syntax.
That file is kept and managed in a separate git repo.

The 'site-config' service merely receives a url to that config file and will watch it;
and re-configure if changes are detected.

In a multi-node setup with 2 or more pihole-unbound nodes, ensure that:

- only one node attempts reconfiguring
- the old, previous config is kept cached; rollback to it if new config fails
- 2nd or more pihole-config nodes will later, one by one, update
- TBD: how nodes coordinate update timing and success/fail communication

## TODO

- update coordination and comms
- need a safe default config for newly deployed pihole-unbound nodes until valid configuation has rolled out
- distribute admin web GUI password securely through site-config into nodes (using `pihole setpassword`)
