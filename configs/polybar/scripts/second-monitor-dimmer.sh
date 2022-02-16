#!/bin/sh

# customization variables
color_enabled="%{F#eceff4}"
color_disabled="%{F#4c566a}"
icon=""
monitor_name="HDMI-0"
monitor_low_brightness=0.5

# do not edit below this line
enabled=0
clear="%{F-}"

t=0
sleep_pid=0

toggle() {

    if [ $t -eq 0 ]; then
        xrandr --output $monitor_name --brightness $monitor_low_brightness
    else
        xrandr --output $monitor_name --brightness 1
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