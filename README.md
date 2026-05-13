I dinnae know how to properly write readme.md's so...

Video compressor that Requires FFmpeg (and FFprobe, though it's frequently bundled) to be in the system PATH. FFprobe to get the length of the video, the script to calculate bitrate to reach the target size, and FFmpeg to re-encode the video at that target bitrate in mp4 format. libx264 for video codec and Opus for audio codec.

I have this setup as a shortcut on my desktop through `powershell -NoProfile -ExecutionPolicy Bypass -File "<PATH TO SCRIPT>"` and I set the start in directory to where I want my files to be outputted (like my desktop folder). But you can just run it through terminal with dot sourcing and having the file paths pasted after (if the file paths have spaces wrap them in "").

Max size and audio quality can be set through the variables `$AUDIO_BITRATE_KBPS` and `$MAX_SIZE_MB` but it is currently set to what I use for sending clips on Discord (since a majority of my clips come from Steam recordings). This uses `-movflags +faststart` so you can watch the video before it finishes downloading on websites. It is also capable of bulk converting videos if you drag and drop multiple into the shortcut or command line, though it does not run in parallel, and generally it doesn't go faster anyways (from personal experience).

you can remove the `-preset veryslow` option if it takes too long to encode for you. But you should be fine since this doesn't even use double pass encoding.

this works on PowerShell 5.1 and 7.6 so you'll probably be fine on other versions, but you MUST have FFmpeg installed (`winget install --id Gyan.FFmpeg` if you don't have it).
