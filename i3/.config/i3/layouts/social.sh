#!/bin/sh

i3-msg "workspace 4:soc; append_layout ~/.config/i3/layouts/workspace_soc.json"

# And finally we fill the containers with the programs they had
(whatsapp-nativefier & disown)
(discord & disown)
(telegram-desktop & disown)