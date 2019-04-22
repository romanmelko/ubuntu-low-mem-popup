#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

# If the language is not English, free will output localized text and parsing fails
LANG=en_US.UTF-8

THRESHOLD=500
INTERVAL=300
POPUP_DELAY=999999

# sleep some time so the shell starts properly
sleep 60

while :
do
    available=$(free -mw | awk '/^Mem:/{print $8}')
    if [ $available -lt $THRESHOLD ]; then
        title="Low memory! $available MB available"
        message=$(top -bo %MEM -n 1 | grep -A 3 PID | awk '{print $(NF - 6) " \t" $(NF)}')
	    if [ -x "$(command -v kdialog)" ]; then # assume KDE Plasma is installed and is active
            kdialog --title "$title" --passivepopup "$message" $POPUP_DELAY
        else
            notify-send -u critical "$title" "$message" -t $POPUP_DELAY
	    fi
    fi
    sleep $INTERVAL
done
