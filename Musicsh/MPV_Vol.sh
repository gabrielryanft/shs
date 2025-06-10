#!/bin/bash

# send volume in MPV to i3blocks
# (This is one part of the script, the rest is in i3 and i3blocks config)

echo $(tmux capture-pane -t "Music MPV" -p | sed -n 's/^Volume: \([0-9]*%\)$/\1\n/p' | tail -n 2 ) > $HOME/settings/.MPV_Vol.info 
