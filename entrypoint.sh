#!/bin/sh

# Get desired UID & GID and fall back to 911
PUID=${PUID:-911}
PGID=${PGID:-911}

# Get pre-existing users and groups with desired ID's
B_GROUP_NAME=$(cat /etc/group | grep :${PGID}: | cut -d: -f1)
B_USER_NAME=$(cat /etc/passwd | grep :${PUID}: | cut -d: -f1)

if [[ -z $B_GROUP_NAME ]]
then
    B_GROUP_NAME="dockergroup"
    addgroup -g "${PGID}" -S "${B_GROUP_NAME}"
fi

if [[ -z $B_USER_NAME ]]
then
    B_USER_NAME="dockeruser"
    adduser -u ${PUID} -D "${B_USER_NAME}"
fi

usermod -g ${PGID} ${B_USER_NAME}

# Explicitly grant ownership of /config volume to new user
chown -R ${B_USER_NAME}:${B_GROUP_NAME} /config
chown -R ${B_USER_NAME}:${B_GROUP_NAME} /opt

# Output 
echo "Running container as ${B_USER_NAME} in group ${B_GROUP_NAME} (${PUID}:${PGID})"

# Run requested CMD through passed UID & GID
exec su-exec ${B_USER_NAME}:${B_GROUP_NAME} "${@}"
