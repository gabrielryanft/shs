#!/bin/bash

if tmux has-session -t 'Recording'; then
	echo "" > $HOME/settings/.recording.info
	tmux send-keys -t 'Recording'.1 'q'
	tmux send-keys -t 'Recording'.0 'q'
	exit
fi

curr_last_file="$HOME/Videos/Recordings/$(ls $HOME/Videos/Recordings/ -1 | tail -n 1)"

sleep 1
echo '| #Rec ' > $HOME/settings/.recording.info
tmux new-session -d -s "Recording" \
ffmpeg -f pulse -i "$(pactl list sources | grep Name | grep -i output | cut -d" " -f 2)" -f x11grab -i :0.0 "$HOME/Videos/Recordings/$(date +"%Y-%m-%d-%H%M%S_ffmpeg.mkv")"

while [ "$(echo $curr_last_file)" = "$(echo "$HOME/Videos/Recordings/$(ls $HOME/Videos/Recordings/ -1 | tail -n 1)" )" ];
do
	sleep 0.5
done

echo "$HOME/Videos/Recordings/$(ls $HOME/Videos/Recordings/ -1 | tail -n 1)" | xclip -selection clipboard -i
echo "$HOME/Videos/Recordings/$(ls $HOME/Videos/Recordings/ -1 | tail -n 1)" | xclip -selection primary -i
