#!/bin/bash

THE_FILE="$HOME/settings/.spaced_repetition.info"
KNOWLEDGE_FILE="$HOME/settings/.spaced_repetition.info"

temp_file="$(mktemp)"
cat $THE_FILE > $temp_file
while read line
do
	echo ----------------------------
	echo $line
	echo ----------------------------
	if [ $(echo $line | cut -d',' -f 2 | cut -d"-" -f 2) -le $(date +'%-j') ]
	then
		echo $line | cut -d',' -f 4- | sed 's/	//' >> $temp_file
		python3 $HOME/po/change_line.py $temp_file $(echo $line | cut -d',' -f 1)
	fi
done < $THE_FILE

if [ -z "$(cat $temp_file)" ]
then
	echo Nothing today.
else
	cat $KNOWLEDGE_FILE > $HOME/settings/knowledge/$(date +'%Y-%m-%d-%H%M%S')
	cat $temp_file > $KNOWLEDGE_FILE
	xterm -title "KNOWLEGDE" -e tmux new-session -s "KNOWLEGDE" 'nvim $KNOWLEDGE_FILE'

fi
