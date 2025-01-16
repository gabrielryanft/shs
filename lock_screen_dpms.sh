#!/bin/bash 

revert() {
	# To make the screen turn off and only turn on again
	# when you put the correct password STEP 1 (One)
	# ( eDP-1 = display to blackout )
	xrandr --output eDP-1 --auto

	# Never blackout screen after unlocked
	# xset dpms 0 0 0

	# Play music again
	if [ -e $HOME/settings/.is_it_playing.info ];
	then 
		tmux send-keys -t "Music MPV".1 "p"
	fi

	echo "no" > $HOME/settings/.is_it_locked.info
}
trap revert HUP INT TERM

# Make tmp file - needed for all scripts that
# use the veriable $pic im them.
# pic=$(mktemp)

# Only a bad quality pic - very fast
# scrot --format jpg -q 1 - > "${pic}.jpg"
# mogrify -format png "${pic}.jpg"

# Blur in Bad quality pic - fast
# scrot --format jpg -q 10 - > $pic
# magick convert "$pic" -blur 0x4 "${pic}.jpg"
# mogrify -format png "${pic}.jpg"

# Blur in Good quality pic - slow
# scrot - > $pic
# magick convert "$pic" -blur 0x4 "${pic}.png"

# Black screen immediately
# xset -display :0.0 dpms force off

# when mouuse move, stay aake for 4s then blackout.
# xset +dpms dpms 2 2 2

# To make the screen turn off and only turn on again
# when you put the correct password STEP 2 (Two)

# Check if is playing music
if [ -e $HOME/settings/.is_it_playing.info ];
then 
	tmux send-keys -t "Music MPV".1 "p"
fi

rm $HOME/settings/.is_it_locked.info

xrandr --output eDP-1 --off
i3lock -u -c 000000 -t -p win -e -f -n

# To make it chose a random pic from a folder
# i3lock -u -c 000000 -t -p win -e -f -i $HOME/settings/lock/$(shuf -n 1 <<<$(ls -1 $HOME/settings/lock/)) -n

# i3lock -u -c 000000 -t -p win -e -f -i "${pic}.png" -n

revert
