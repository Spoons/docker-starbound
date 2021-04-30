#!/usr/bin/env bash
PUID=${PUID:-1000}
GUID=${GUID:-1000}

groupadd -g "$GUID" steam
useradd -u "$PUID" -g "$GUID" steam

# Create the necessary folder structure
if [ ! -d "$STARBOUND_PATH/linux" ]; then
	echo "Creating folder structure.."
	mkdir -p /steam/starbound/linux
fi

# Check if Starbound needs to be installed or updated
STARBOUND_BIN="$STARBOUND_PATH/linux/starbound_server"
if [ ! -f "$STARBOUND_BIN" ] || [ -n "$UPDATE_STARBOUND" ]; then
        if [ -z "$STEAM_USERNAME" ] || [ -z "$STEAM_PASSWORD" ]; then
                # shellcheck disable=SC2182
                printf "Error: you must set both your Steam username and password"\
                       "to install or update the server."
                exit 1
        else
                # Install Starbound from install.txt
                printf "\nInstalling/Updating Starbound..\n"
                sed -i "s/login anonymous/login $STEAM_USERNAME $STEAM_PASSWORD/g" /steam/install.txt
                /usr/bin/steamcmd +runscript /steam/install.txt

                # Links mods from Workshop folder to mods directory
                for dir in "$STARBOUND_PATH"/steamapps/workshop/content/211820/*/; do
                        dir="${dir%*/}"
                        printf "Linking mod %s into the mods folder\n" "${dir##*/}"
                        ln -rsf "$STARBOUND_PATH/steamapps/workshop/content/211820/${dir##*/}/contents.pak" "$STARBOUND_PATH/mods/${dir##*/}.pak"
                done

                chown -R steam:steam "$STARBOUND_PATH"
        fi
fi

unset STEAM_USERNAME
unset STEAM_PASSWORD

# Run the server
printf "\nStarting Starbound..\n"
exec gosu steam bash /bin/starbound.sh
