#!/bin/bash

# remove the file with yt songs in it.
rm /tmp/songs_data.csv.temp

# load the file with yt songs in it. ( to choose from )
load_vid_index () {
	yt-dlp --flat-playlist --print "\"%(title)s\", %(uploader)s	,https://www.youtube.com/watch?v=%(id)s" "$(cat $HOME/settings/link_yt_playlist.info)" \
		| nl -w2 -s',	' \
		| tee $HOME/settings/songs_data.csv \
		| sed 's/,	/>  /' \
		| cut -f 1 \
		> /tmp/songs_data.csv.temp
	
}
load_vid_index &

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

tmux new-session -d -s "Music MPV" $menu_items
#                 |
# ( man tmux: new session is attached to the current terminal unless -d is given.# the current term is tty. i dont want to go back to the tty and have to deal with mpv/tmux. )
