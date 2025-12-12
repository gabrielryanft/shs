#!/bin/bash

# wgen * is used as a arg in bash, it is interpreted as a whildcard,
# giving the command all the files in the current dir.
# this transforms all the files into a "*" ( multiply sign )
if grep -q "$(ls)" <(echo "$@");
then
	calc="$(echo $@ | sed "s/$(ls | tr "\n" " ")/\*/g")"
else
	calc=$@
fi

# Comverting XXmin XXh XXs to seconds
# and XXp = XX periods ( 1p = 50 min ) 
if grep -q "[0-9]* *s" <(echo "$@")
then 
	calc="$(echo $@ | sed 's/\([0-9]*\) *s/ \1 /g')"

elif grep -q "[0-9]* *min" <(echo "$@")
then 
	calc="$(echo $@ | sed 's/\([0-9]*\) *min/ \1 \* 60 /g')"

elif grep -q "[0-9]* *h" <(echo "$@")
then 
	calc="$(echo $@ | sed 's/\([0-9]*\) *h/ \1 \* 60 \* 60 /g')"
	
elif grep -q "[0-9]* *p" <(echo "$@")
then 
	calc="$(echo $@ | sed 's/\([0-9]*\) *p/ \1 \* 60 \* 50 /g')"
	
fi

# the time given to the command but in seconds
time_end="$(($calc))"

# the font to use (from the toilet command)
toilet_font="pagga.tlf"

# print he total time you gave the command.
printf "\r%02d:%02d:%02d\n" "$((time_end / 60 / 60))" "$((time_end / 60 % 60))" "$((time_end % 60))" | toilet -f $toilet_font


# verifying the height in rows of the font
# (toilet font)
temp_file=$(mktemp)
echo "string,ç[}jg´" | toilet -w 99999999 -f $toilet_font > $temp_file
height_of_toilet_font="$(($(wc -l $temp_file | sed 's/\(^[0-9]*\) .*$/\1/')))"

# spacing the line with
# the total time you gave the command.
# and the line of teh chroometer itself
spacing(){
	for ((i=0;i<$height_of_toilet_font;i++));
	do
		echo # new line
	done
}
spacing

# on keypress space is given for the "pause line" (search it)
key_press () {
	while true; do
		read -t 1 -N 1 -s -r && spacing && break
	done
}

# clean current line(s) to refresh the time
clean_term(){
	i=0
	for ((i=0;i<$height_of_toilet_font;i++)); 
	do
		printf "\r\033[A\r"
	done
}

# the total time you gave the command in secs
s=$time_end

# n of times the chronometer was paused
n_pauses=1

# start chronometer
while :
do 
	if (( s <= 0 ))
	then 
		break
	fi

	clean_term

	printf "%02d:%02d:%02d" "$((s / 60 / 60))" "$((s / 60 % 60))" "$((s % 60))" | toilet -f $toilet_font
	# If the hour gets bigger than 2 digits, it will grow to fit, it will not "cut" the last/first digit(s) off.

	read -t 1 -N 1 -s -r key && clean_term && printf "\r%02d:%02d:%02d [ Paused %d - %s ]" "$((s / 60 / 60))" "$((s / 60 % 60))" "$((s % 60))" "$n_pauses" "$(date +'%H:%M:%S')" | toilet -w $COLUMNS -f $toilet_font && key_press && ((s++)) && ((n_pauses++))

	((s--))
done

# create new line and notify the timer has ended
echo # New line
sound_alarm > /dev/null 2>&1
notify-send "TIMER DONE!!" "${calc}s"

