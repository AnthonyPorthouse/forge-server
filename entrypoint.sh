#! /usr/bin/env bash
set -e

JAR_NAME="forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-installer.jar"

PUID=${PUID:-1000}
PGID=${PGID:-1000}
USER=${USER:-"minecraft"}

set-up-user.sh "$USER" "$PUID" "$PGID"

if [ ! -f "$JAR_NAME" ]; then
    echo "Downloading Forge";
    curl -OJ "https://maven.minecraftforge.net/net/minecraftforge/forge/${MINECRAFT_VERSION}-${FORGE_VERSION}/${JAR_NAME}"
    java -jar "${JAR_NAME}" --installServer
fi

echo "Setting Java Options"
echo "${JAVA_OPTS}" > user_jvm_args.txt

echo "Accepting EULA"
echo "eula=true" > eula.txt

configure-server-properties.sh

chown -R "${USER}":"${USER}" /minecraft

COMMAND="${*:-"cd /minecraft; ./run.sh $JAR_NAME nogui"}"

su -l "${USER}" -c "$COMMAND"
