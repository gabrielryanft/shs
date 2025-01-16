#!/bin/bash

# send volume in MPV to i3blocks
# (This is one part of the script, the rest is in i3 and i3blocks config)

echo $(tmux capture-pane -t "Music MPV" -p | sed -n 'x;$p' | sed 's/Volume: //g' | sed 's/ //g') > $HOME/settings/.MPV_Vol.info 
pkill -SIGRTMIN+11 i3blocks
