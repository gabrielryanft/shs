#!/bin/bash

if tmux has-session -t "CalculosTotosos"
then 
	if [ -n "$(ps ax | grep "xterm .* CalculosTotosos" | grep -v "grep")" ]
	then
		kill "$(ps aux | grep "xterm .* CalculosTotosos" | grep -v "grep" | sed 's/^[a-zA-Z0-9]* *\([0-9]*\) .*$/\1/')"
		exit
	fi
	xterm -title "CalculosTotosos" -e tmux a -t "CalculosTotosos"
fi
xterm -title "CalculosTotosos" -e tmux new-session -s "CalculosTotosos" qalc &
