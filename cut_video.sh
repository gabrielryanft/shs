#!/bin/bash
video="$1"
timestamp="$2" # Hh:Mm:Ss

ffmpeg -i "$video" -to "$timestamp" -c copy first.mp4
ffmpeg -i "$video" -ss "$timestamp" -c copy second.mp4
