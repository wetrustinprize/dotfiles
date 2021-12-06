#!/bin/sh

total=$(apt-get upgrade -s |grep -P '^\d+ upgraded'|cut -d" " -f1)

echo "%{F#4c566a}$total"