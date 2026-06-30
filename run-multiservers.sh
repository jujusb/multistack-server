#!/usr/bin/env bash

ensure_network() {
    local net=$1
    if ! docker network inspect "$net" >/dev/null 2>&1; then
        echo "Creating network: $net"
        docker network create "$net"
    fi
}
ensure_network caddy_net
source .env
echo $SERVICES
IFS=',' read -ra SERVICES_ARRAY <<< "$SERVICES"
echo $SERVICES_ARRAY
for SERVICE in "${SERVICES_ARRAY[@]}"; do
    set -a  # automatically export all variables
    source ./$SERVICE/.env
    set +a
    echo "Starting $SERVICE..."
    (cd "$SERVICE" && ./run.sh "$@")
done

source .env
export COMPOSE_FILE="docker-compose.yml"
docker compose $@
unset COMPOSE_FILE