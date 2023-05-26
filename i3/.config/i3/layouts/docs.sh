#!/bin/sh

i3-msg "workspace 3:doc; append_layout ~/.config/i3/layouts/workspace_doc.json"

# And finally we fill the containers with the programs they had
(slack & disown)
(thunderbird & disown)