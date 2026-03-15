#!/bin/bash
# shellcheck source=scripts/functions.sh
source "${SCRIPTSDIR}/functions.sh"

LogAction "Set file permissions"

# if the user has not defined a PUID and PGID, throw an error and exit
if [ -z "${PUID}" ] || [ -z "${PGID}" ]; then
    LogError "PUID and PGID not set. Please set these in the environment variables."
    exit 1
else
    usermod -o -u "${PUID}" steam
    groupmod -o -g "${PGID}" steam
    chown -R "${USER}:${USER}" "${HOMEDIR}"
fi

cat /branding

# Start the server
if [[ "$(id -u)" -eq 0 ]]; then
    exec gosu "${USER}" bash "${SCRIPTSDIR}/setup.sh"
fi
