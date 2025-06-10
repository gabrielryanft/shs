#!/bin/bash

# xterm -bg blank -fg black -fa 'DejaVuSansMNerdFontMono' -fs 12 -title "blank" -e man $@ 2> /dev/null &

tmux select-pane -P 'bg=#ffffff fg=#000000'
man $@
tmux select-pane -P 'default'
