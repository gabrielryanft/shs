#!/bin/bash
# A very simple script to allow me
# to make web searches from my terminal emulator.

g=$(echo $@ | sed 's/ /%20/g')
g="https://searx.org/search?q=${g}&language=auto&time_range=&safesearch=0&categories=general"
firefox $g &
