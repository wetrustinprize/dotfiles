#!/bin/sh

i3-msg "workspace 4:soc; append_layout ~/.config/i3/layouts/workspace_soc.json"

(discord & disown)
(slack & disown)