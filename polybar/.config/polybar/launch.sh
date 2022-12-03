#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar --reload primary-top &
polybar --reload primary-bottom &

polybar --reload secondary-top &
polybar --reload secondary-bottom

echo "Bars launched..."
