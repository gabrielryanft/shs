#!/bin/bash

# sctipt to know if song is playing to pause it when screen is blocked

if [ ! -e $HOME/settings/.is_it_playing.info ];
then
	echo "is playing" > $HOME/settings/.is_it_playing.info
else
	rm $HOME/settings/.is_it_playing.info
fi
