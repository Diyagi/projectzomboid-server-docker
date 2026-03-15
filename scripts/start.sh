#!/bin/bash
# shellcheck source=scripts/functions.sh
source "${SCRIPTSDIR}/functions.sh"

term_handler() {
    if ! shutdown_server; then
        # Does not save
        kill -SIGTERM "$killpid"
    fi
    tail --pid="$killpid" -f 2>/dev/null
}

trap 'term_handler' SIGTERM

# Switch to workdir
cd "${STEAMAPPDIR}" || exit

# Configure memory settings
configure_memory

# Check config for warnings
check_admin_password

# Configure RCON settings
LogAction "Configuring RCON settings"
cat >"${SCRIPTSDIR}/rcon.yml"  <<EOL
default:
  address: "127.0.0.1:${RCON_PORT}"
  password: "${RCON_PASSWORD}"
EOL

# Enforce RCON password
config_file="$STEAMAPPDATADIR/Server/${SERVER_NAME}.ini"
sed -i "s|RCONPassword=.*|RCONPassword=${RCON_PASSWORD}|" "$config_file"

LogAction "Starting server"

export PATH="${STEAMAPPDIR}/jre64/bin:$PATH"
export LD_LIBRARY_PATH="${STEAMAPPDIR}/linux64:${STEAMAPPDIR}/natives:${STEAMAPPDIR}:${STEAMAPPDIR}/jre64/lib/amd64:${LD_LIBRARY_PATH}"

JSIG="libjsig.so"
LD_PRELOAD="${LD_PRELOAD}:${JSIG}" ./ProjectZomboid64 \
    -cachedir="$STEAMAPPDATADIR" \
    -adminusername "$ADMIN_USERNAME" \
    -adminpassword "$ADMIN_PASSWORD" \
    -port "$DEFAULT_PORT" \
    -servername "$SERVER_NAME" \
    -steamvac "$STEAM_VAC" "$USE_STEAM" &

killpid="$!"
wait "$killpid"
