param([string]$IN = $args[0])
[string]$OUT = "$([System.IO.Path]::GetFileNameWithoutExtension($IN))_converted.mp4"

[byte]$AUDIO_BITRATE=128
[ushort]$MAX_SIZE_KB=9728

[double]$DURATION, [uint]$BITRATE =(ffprobe -i $IN -v error -show_entries format=duration,bit_rate -of csv=p=0) -split ","

[double]$MAX_VIDEO_BITRATE_KBPS=($MAX_SIZE_KB*8/$DURATION)-$AUDIO_BITRATE
[double]$FINAL_BITRATE_KBPS = $BITRATE/1000 -lt $MAX_VIDEO_BITRATE_KBPS ? $BITRATE/1000 : $MAX_VIDEO_BITRATE_KBPS

ffmpeg -i $IN -vf "scale=min(1280\,iw):-1" -c:v libx264 -c:a aac -b:v "${FINAL_BITRATE_KBPS}k" -b:a "${AUDIO_BITRATE}k" $OUT