#!/bin/bash
# shellcheck source=scripts/functions.sh
source "/home/steam/server/functions.sh"

# Configure RCON settings
LogAction "Configuring RCON settings"
cat >/home/steam/server/rcon.yml  <<EOL
default:
  address: "127.0.0.1:${RCON_PORT}"
  password: "${RCON_PASSWORD}"
EOL

# Enforce RCON password
config_file="$CONFIG_DIR/Server/${SERVER_NAME}.ini"
sed -i "s|RCONPassword=.*|RCONPassword=${RCON_PASSWORD}|" "$config_file"

cd /project-zomboid || exit

LogAction "Starting server"
./start-server.sh \
    -cachedir="$CONFIG_DIR" \
    -adminusername "$ADMIN_USERNAME" \
    -adminpassword "$ADMIN_PASSWORD" \
    -port "$DEFAULT_PORT" \
    -servername "$SERVER_NAME" \
    -steamvac "$STEAM_VAC" "$USE_STEAM"
