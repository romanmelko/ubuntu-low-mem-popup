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
    available=$(free -m | awk '/^Mem:/{print $7}')
    if [ $available -lt $THRESHOLD ]; then
        title="Low memory! $available MB available"
        message=$(top -bo %MEM -n 1 | grep -A 3 PID | awk '{print $(NF - 6) " \t" $(NF)}')
        # KDE Plasma notifier
        kdialog --title "$title" --passivepopup "$message" $POPUP_DELAY
        # use the following command if you are not using KDE Plasma, comment the line above and uncomment the line below
        # please note that timeout for notify-send is represented in milliseconds
        # notify-send "$title" "$message" -t $POPUP_DELAY
    fi
    sleep $INTERVAL
done
