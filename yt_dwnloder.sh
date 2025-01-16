dst="$(cat $HOME/file.txt)"

for i in ${dst}; do 
	yt-dlp -S vcodec:h264,res,acodec:m4a -P "/media/usbdrive/" "$i"
done
