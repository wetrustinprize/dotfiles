#!/bin/sh

# customization variables
color_enabled="%{F#eceff4}"
color_disabled="%{F#4c566a}"
micOnIcon=""
micOffIcon=""

# do not edit below this line
clear="%{F-}"

sleep_pid=0

toggle() {

    amixer set Capture toggle -q

    if [ "$sleep_pid" -ne 0 ]; then
        kill $sleep_pid >/dev/null 2>&1
    fi

}

trap "toggle" USR1

while true; do
    if ! amixer get Capture | grep -q off; then
        echo "$color_disabled$micOnIcon$clear"
    else
        echo "$color_enabled$micOffIcon$clear"
    fi
    sleep 1 &
    sleep_pid=$!
    wait
done