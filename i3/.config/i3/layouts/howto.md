# Creating new layouts

Take a "snapshot" of the current layout.

**Change the N to the workspace you want to copy the layout from.**

```bash
$ i3-save-tree --workspace N > ~/.config/i3/layouts/snapshot.json 
```

```bash
$ sed -i 's|^\(\s*\)// "|\1"|g; /^\s*\/\//d' ~/.config/i3/layouts/snapshot.json
```

Move the `snapshot.json` to a proper name and configure the Regex in the `swallows` key.

Create a new `.sh` file in `/layouts`, the `configure.sh` will auto load any scripts in the folder.

```bash
#!/bin/sh

# Remeber to change the `workspace 4:soc` with the correct workspace name.
i3-msg "workspace 4:soc; append_layout ~/.config/i3/layouts/workspace_soc.json"

# And finally we fill the containers with the programs they had
(whatsapp-nativefier & disown)
(discord & disown)
(telegram-desktop & disown)
```
_Example for the soc workspace_
