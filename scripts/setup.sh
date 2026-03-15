#!/bin/bash

mkdir -p "${STEAMAPPDIR}" || true

args=(
    "+@sSteamCmdForcePlatformType" "linux"
    "+@sSteamCmdForcePlatformBitness" "64"
    "+force_install_dir" "$STEAMAPPDIR"
    "+login" "anonymous"
)

app_args=("+app_update" "380870")

if [[ -n $SERVER_BRANCH ]]; then
    app_args+=("-beta" "$SERVER_BRANCH")
fi

if [ ! -f "${STEAMAPPDIR}/ProjectZomboid64" ]; then
    app_args+=("validate")
fi

args+=("${app_args[@]}")
args+=("+quit")

"$STEAMCMDDIR/steamcmd.sh" "${args[@]}"
chmod +x "$STEAMAPPDIR/ProjectZomboid64"

exec bash "${SCRIPTSDIR}/start.sh"
