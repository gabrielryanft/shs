# send PATH/IMG_NAME to clipboard
echo "$HOME/Pictures/Sshots/$(date +"%Y-%m-%d-%H%M%S.png")" | xclip -selection clipboard -i
# send IMAGE to clipboard
scrot -F $HOME/Pictures/Sshots/$(date +"%Y-%m-%d-%H%M%S.png") -f -s -e 'xclip -selection clipboard -t image/png -i $f' && \
	notify-send -t 100 -i "$HOME/Pictures/Sshots/$(ls $HOME/Pictures/Sshots/ -1c | sed -n 1p)" '.'
