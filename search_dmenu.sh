#!/bin/bash

search=$(ThisCommandDoNotExist | dmenu -p "search? ")

# Search options:
if [[ ! "${search:0:2}" =~ [a-zA-Z]" " ]]; then
	surf https://searx.org/search?q=$(echo $search | sed 's/ /%20/g')&language=all&time_range=&safesearch=0&categories=general
else
	st
fi
