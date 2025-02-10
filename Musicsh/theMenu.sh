#!/bin/bash

# I call this script with a keybind in i3 to show dmenu with the options of things to listen

if tmux has-session -t 'Music MPV'; then 

	if [ -n "$(ps ux | grep "xterm .* Music MPV" | grep -v "grep")" ]
	then
		kill "$(ps ux | grep "xterm .* Music MPV" | grep -v "grep" | grep "." | sed 's/^[a-zA-Z0-9]* *\([0-9]*\) .*$/\1/')"
		exit
	fi

	xterm -title "Music MPV" -e tmux a -t "Music MPV"
	exit
fi

echo "is playing" > $HOME/settings/.is_it_playing.info
echo "100%" > $HOME/settings/.MPV_Vol.info

menu_items=$(ls --hide=*.sh $HOME/shs/Musicsh/ | dmenu -f -i -p "listen to ")
menu_items="$HOME/shs/Musicsh/$(echo "$menu_items" | sed 's/ //g')"

xterm -title "Music MPV" -e tmux new-session -s "Music MPV" $menu_items
