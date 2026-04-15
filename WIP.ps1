param ( 
    [Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)]
    [System.IO.FileInfo[]]$VIDEOS
)

[UInt16]$AUDIO_BITRATE_KBPS = 96
[UInt16]$MAX_SIZE_KB = 1024 * 9.5

foreach ($VIDEO in $VIDEOS) {
    [Double]$DURATION = (ffprobe -i $VIDEO.FullName -v error -show_entries "format=duration" -of csv=p=0)
    [Double]$VIDEO_BITRATE_KBPS = $MAX_SIZE_KB * 8 / $DURATION - $AUDIO_BITRATE_KBPS

    ffmpeg -i $VIDEO.FullName `
        -vf "scale=-2:min(540\iw)," `
        -c:a libopus -b:a "${AUDIO_BITRATE_KBPS}k" `
        -c:v libx264 -b:v "${VIDEO_BITRATE_KBPS}k" `
        -maxrate "${VIDEO_BITRATE_KBPS}k" `
        -bufsize "$($VIDEO_BITRATE_KBPS*2)k" `
        -profile:v high -level 4.1 `
        -x264-params "rc-lookahead=150:ref=6" `
        -tune animation -movflags +faststart `
        ($VIDEO.BaseName + "_converted.mp4")
}
