#!/bin/bash
# lid-hibernate.sh

evtest /dev/input/event0 | while read line; do
    if echo "$line" | grep -q "SW_LID.*value 1"; then
        CURRENT_USER=$(loginctl list-sessions --no-legend | awk '{print $3}' | head -1)
        SESSION=$(loginctl list-sessions --no-legend | awk -v user="$CURRENT_USER" '$3 == user && $4 == "seat0" {print $1}' | head -1)
        CONFIG_FILE="/home/$CURRENT_USER/.config/inactivity/config"

        if [ -f "$CONFIG_FILE" ]; then
            source "$CONFIG_FILE"
        else
            echo "pas de fichier de configuration - utilisation d'ignore par defaut"
            LID_ACTION="ignore"
        fi

        case "$LID_ACTION" in
        hibernate)
            loginctl lock-session $SESSION
            sleep 1
            echo " Entrer en hibernation"
            systemctl hibernate
        ;;
        suspend)
            loginctl lock-session $SESSION
            sleep 1
            echo " Entrer en veille..."
            systemctl suspend
        ;;
        ignore)
            echo "Fermeture du couvercle ignorée."
        ;;
        *)
            echo "erreur dans $CONFIG_FILE LID_ACTION doit etre egal a hibernate/suspend/ignore"
            exit 0
        ;;
        esac
    fi
done
