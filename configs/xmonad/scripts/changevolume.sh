#!/bin/bash

case $1 in

    up)
        amixer set Master 5%+
        ;;

    down)
        amixer set Master 5%-
        ;;

    toggle)
        amixer -D pulse sset Master toggle
        ;;

    *)
        echo "Usage: $0 {up|down|toggle}"
        exit 1
        ;;

esac

# https://wiki.archlinux.org/title/Dunst

# Query amixer for the current volume and whether or not the speaker is muted
volume="$(amixer -c 0 get Master | tail -1 | awk '{print $4}' | sed 's/[^0-9]*//g')"
mute="$(amixer -c 0 get Master | tail -1 | awk '{print $6}' | sed 's/[^a-z]*//g')"
if [[ $volume == 0 || "$mute" == "off" ]]; then
    # Show the sound muted notification
    dunstify -a "changeVolume" -u low -i audio-volume-muted -h string:x-dunst-stack-tag:volume "Volume muted"
else
    # Show the volume notification
    dunstify -a "changeVolume" -u low -i audio-volume-high -h string:x-dunst-stack-tag:volume \
    -h int:value:"$volume" "Volume: ${volume}%"
fi