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
if [ ! -d "$BASE_DATA_PATH/.env" ]; then
    mkdir -p "$BASE_DATA_PATH/.env"
fi
cp ./.env $BASE_DATA_PATH/.env/.env
echo $SERVICES
IFS=',' read -ra SERVICES_ARRAY <<< "$SERVICES"
echo $SERVICES_ARRAY
for SERVICE in "${SERVICES_ARRAY[@]}"; do
    set -a  # automatically export all variables
    source ./$SERVICE/.env
    set +a
    echo "Starting $SERVICE..."
    if [ ! -d "$BASE_DATA_PATH/.env/$SERVICE" ]; then
        mkdir -p "$BASE_DATA_PATH/.env/$SERVICE"
    fi
    cp ./$SERVICE/.env $BASE_DATA_PATH/.env/$SERVICE/.env
    (pushd "$SERVICE" && ./run.sh "$@" && echo "$SERVICE started successfully." && popd) || echo "Failed to start $SERVICE."
done

source .env
is_ip() {
  [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]
}
if is_ip "$SERVER_ADDRESS"; then
    echo "Detected IP → using internal TLS"
    export TLS_CONFIG='tls internal'
else
    echo "Detected domain → using Cloudflare TLS"
    export TLS_CONFIG='tls { dns cloudflare {env.CF_API_TOKEN} }'
fi
export COMPOSE_FILE="docker-compose.yml"
docker compose $@
unset COMPOSE_FILE