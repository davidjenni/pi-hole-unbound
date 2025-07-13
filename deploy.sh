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
