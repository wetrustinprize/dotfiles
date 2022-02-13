#!/bin/sh

# customization variables
color_used="%{F#eceff4}"
color_unused="%{F#4c566a}"

char_fill=""
char_empty=""

total_bars=4

# do not edit below this line

# https://github.com/polybar/polybar-scripts/tree/master/polybar-scripts/system-nvidia-smi
percentage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)

result=""
pieces=$((percentage/(100/total_bars)))

for i in $(seq 1 ${total_bars})
do
    if [ $pieces -eq 0 ]; then
        result="$result$color_unused$char_empty"
    elif [ $pieces -ge $i ] || [ $pieces -eq $total_bars ]; then
        result="$result$color_used$char_fill"
    else
        result="$result$color_unused$char_empty"
    fi
done

result="$result%{F-}"
echo $result