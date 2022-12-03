#!/bin/sh

# customization variables
color_enabled="%{F#eceff4}"
color_disabled="%{F#4c566a}"
icon=""

# do not edit below this line
enabled=0
clear="%{F-}"

t=0
sleep_pid=0

toggle() {

    if [ $t -eq 0 ]; then
        redshift -o -t 3700:3700 -l 0.0:0.0
    else
        redshift -x
    fi

    if [ "$sleep_pid" -ne 0 ]; then
        kill $sleep_pid >/dev/null 2>&1
    fi

    t=$(((t + 1) % 2))
}

trap "toggle" USR1

while true; do
    if [ $t -eq 0 ]; then
        echo "$color_disabled$icon$clear"
    else
        echo "$color_enabled$icon$clear"
    fi
    sleep 1 &
    sleep_pid=$!
    wait
done