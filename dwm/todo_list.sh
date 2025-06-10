#!/bin/bash

if tmux has -t "AF-Z" ; then 
	if [ -n "$(ps aux | grep "xterm .*AF-Z" | grep -v "grep")" ] ; then
		kill "$(ps aux | grep "xterm .*AF-Z" | grep -v "grep" | awk '{print $2}')"
		exit
	fi

	if [ -n "$1" ] 
	then
		tmux send-keys -t 'AF-Z'.1 Escape Escape "ggO" Escape "O" Escape ":.!date" Enter "o"
		xterm -title "AF-Z" -e tmux a -t "AF-Z" 
		exit
	fi

	xterm -title "AF-Z" -e tmux a -t "AF-Z" 
	exit
fi

if [ -n "$1" ] 
then
	tmux new-session -d -s "AF-Z" vim $HOME/.af.md
#                         |
# ( man tmux: new session is attached to the current terminal unless -d is given.# the current term is tty. i dont want to go back to the tty and have to deal with mpv/tmux. )
	tmux send-keys -t 'AF-Z'.1 Escape Escape "ggO" Escape "O" Escape ":.!date" Enter "o"
	xterm -title "AF-Z" -e tmux a -t "AF-Z" 
	exit
fi

xterm -title "AF-Z" -e tmux new-session -s "AF-Z" vim $HOME/.af.md
