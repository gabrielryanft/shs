#!/bin/bash

stats(){
	if [ $1 -lt 60 ]; then
		printf "\n==========\n\n${1}s\n\n==========\n"
	else
		printf "\n==========\n\n$(($1 / 60))min $(( $1 % 60 ))s\n\n==========\n"
	fi
}

i=0

trap 'stats $i' EXIT  # Trap deve ser definido fora do loop

while true
do
	printf "$i\n"
	sleep 1
	((i++))
done
