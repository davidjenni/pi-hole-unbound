#!/bin/sh

echo "=== $(date -u +"%F %T %Z") Starting Unbound dns..."
unbound -V

ANCHOR_FILE="/etc/unbound/dnssec-root.key"
if [ ! -f "$ANCHOR_FILE" ]; then
  echo "Root anchor file $ANCHOR_FILE not found. Fetching..."
  unbound-anchor -a "$ANCHOR_FILE" -r /etc/unbound/root.hints -v
  chown unbound:unbound $ANCHOR_FILE
fi

echo "Validating configuration..."
unbound-checkconf -f /etc/unbound/unbound.conf

exec unbound $@
