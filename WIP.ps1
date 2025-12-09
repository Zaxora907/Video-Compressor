param([string]$IN = $args[0])
[string]$OUT = "$([System.IO.Path]::GetFileNameWithoutExtension($IN))_converted.mp4"

[byte]$AUDIO_BITRATE=128
[ushort]$MAX_SIZE_KB=9728

[uint]$BITRATE, [double]$DURATION =(ffprobe -i $IN -v error -select_streams v:0 -show_entries "format=duration:stream=bit_rate" -of csv=p=0) -split ","
$BITRATE /= 1000

[double]$MAX_VIDEO_BITRATE_KBPS=($MAX_SIZE_KB*8/$DURATION)-$AUDIO_BITRATE
[double]$FINAL_BITRATE_KBPS = $BITRATE -lt $MAX_VIDEO_BITRATE_KBPS ? $BITRATE : $MAX_VIDEO_BITRATE_KBPS

ffmpeg -i $IN -vf "scale=min(1280\,iw):-1" -v quiet -stats -c:v libx264 -c:a aac -b:v "${FINAL_BITRATE_KBPS}k" -b:a "${AUDIO_BITRATE}k" $OUT