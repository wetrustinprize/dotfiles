#!/bin/sh

# customization variables
color_enabled="%{F#eceff4}"
color_disabled="%{F#4c566a}"
micOnIcon=""
micOffIcon=""

# do not edit below this line
enabled=0
clear="%{F-}"

t=0
sleep_pid=0

toggle() {

    if [ $t -eq 0 ]; then
        amixer set Capture nocap
    else
        amixer set Capture cap
    fi

    if [ "$sleep_pid" -ne 0 ]; then
        kill $sleep_pid >/dev/null 2>&1
    fi

    t=$(((t + 1) % 2))
}

trap "toggle" USR1

while true; do
    if [ $t -eq 0 ]; then
        echo "$color_disabled$micOnIcon$clear"
    else
        echo "$color_enabled$micOffIcon$clear"
    fi
    sleep 1 &
    sleep_pid=$!
    wait
done