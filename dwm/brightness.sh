#!/bin/bash

current=$(xrandr --verbose | grep Brightness | cut -d" " -f 2)
step='0.01'
if [ $@ == "+" ]; then
	xrandr --output eDP-1 --brightness $(just-sum-it $current ${step})
else
	xrandr --output eDP-1 --brightness $(just-subtract-it $current ${step})
fi
