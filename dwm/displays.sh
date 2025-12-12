#!/bin/bash

# you dont need to show
# xrandr | grep -i "hdmi-1" | grep -o --perl-regex "connected .* \(" && echo "" > ~/settings/.mirroring.info || echo "| [M]" > ~/settings/.mirroring.info
xrandr | grep -i "hdmi-1" | grep -o --perl-regex "connected .* \(" \
	&& \
	xrandr --output HDMI-1 --off && \
	pactl set-default-sink $(pactl list sinks | grep -i sink | head -n1 | cut -d"#" -f 2) \
	|| \
	xrandr --output HDMI-1 --auto && \
	pactl set-default-sink $(pactl list sinks | grep -i sink | tail -n1 | cut -d"#" -f 2)

# idk
# xrandr | grep -i "hdmi-1" | grep --perl-regex "connected .* \(" &&  xrandr --output HDMI-1 --off || xrandr --output HDMI-1 --same-as eDP-1

# idk too
# xrandr | grep -i "hdmi-1" | grep -o --perl-regex "connected .* \(" && echo "| [M]"  || echo "popopop"


