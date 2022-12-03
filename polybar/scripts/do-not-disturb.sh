#!/bin/sh

# customization variables
color_enabled="%{F#eceff4}"
color_disabled="%{F#4c566a}"
icon="⏾"

# do not edit below this line
clear="%{F-}"

sleep_pid=0

toggle() {

    dunstctl set-paused toggle

    if [ "$sleep_pid" -ne 0 ]; then
        kill $sleep_pid >/dev/null 2>&1
    fi
}

trap "toggle" USR1

while true; do
    case $(dunstctl is-paused) in
        (true)      echo "$color_enabled$icon$clear";;
        (false)     echo "$color_disabled$icon$clear";;
    esac

    sleep 1 &
    sleep_pid=$!
    wait
done