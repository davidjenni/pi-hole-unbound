#!/bin/bash
echo ">>-- Current running containers:" && \
docker container ls && \
echo ">>-- Building and pulling latest images..." && \
docker compose --env-file lan.prod.env pull && \
docker compose --env-file lan.prod.env build && \
echo ">>-- Deploying new versions..." && \
docker compose --env-file lan.prod.env stop && \
docker compose --env-file lan.prod.env up -d --wait && \
echo ">>-- Deployment complete. Current containers:" && \
docker container ls -a && \
echo ">>-- Current container stats:" && \
docker compose --env-file lan.prod.env stats --no-stream

pihole_container="${PIHOLE_CONTAINER:-ns-pihole-1}"

if [[ -n "${PIHOLE_WEBUI_PASSWORD:-}" ]]; then
  docker exec -i "$pihole_container" sh -c 'read -r pw; pihole setpassword "$pw"' <<<"$PIHOLE_WEBUI_PASSWORD"
elif [[ -t 0 ]]; then
  docker exec -it "$pihole_container" pihole setpassword
else
  echo "PIHOLE_WEBUI_PASSWORD must be set when running non-interactively." >&2
  exit 1
fi
