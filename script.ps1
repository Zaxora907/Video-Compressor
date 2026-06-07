param (
    [Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)]
    [System.IO.FileInfo[]]$VIDEOS
)

[byte]$AUDIO_BITRATE_KBPS = 80
[Double]$MAX_SIZE_MB = 10
[byte]$SPLITS = 2

foreach ($VIDEO in $VIDEOS) {
    [Double]$SEGMENT_DURATION = (ffprobe -i $VIDEO.FullName -v error -show_entries "format=duration" -of csv=p=0) / $SPLITS
    [Double]$VIDEO_BITRATE_KBPS = $MAX_SIZE_MB * 8192 / $SEGMENT_DURATION - $AUDIO_BITRATE_KBPS

    for ($I = 0; $I -lt $SPLITS; $I++) {
        ffmpeg -ss ($SEGMENT_DURATION * $I) -t $SEGMENT_DURATION -i $VIDEO.FullName `
        -vf "scale=-2:min(540\,iw)" `
        -c:a libopus -b:a "${AUDIO_BITRATE_KBPS}k" `
        -c:v libx264 -b:v "${VIDEO_BITRATE_KBPS}k" `
        -maxrate "${VIDEO_BITRATE_KBPS}k" `
        -bufsize "$($VIDEO_BITRATE_KBPS * 2)k" `
        -profile:v high -level 4.1 -preset veryslow `
        -x264-params "rc-lookahead=240:ref=6" `
        -tune animation -movflags +faststart `
        "$($VIDEO.BaseName)_${I}_converted.mp4"
    }
}
