# Modified from https://wiki.archlinux.org/index.php/Streaming_to_twitch.tv for video playback
OUTRES="1920x1080" # output resolution
# OUTRES="1280x720"
FPS="30" # target FPS
GOP="60" # i-frame interval, should be double of FPS, 
GOPMIN="30" # min i-frame interval, should be equal to fps, 
THREADS="8" # max 6
CBR="2500k" # constant bitrate (should be between 1000k - 3000k)
QUALITY="veryfast"  # one of the many FFMPEG preset
AUDIO_RATE="44100"
SERVER="live-syd" # twitch server, see https://stream.twitch.tv/ingests/ for list
VIDEO_SOURCE="$1"

if ! [ -z "$2" ]; then
  START_TIME="-ss $2"
fi

if [ -z "$TWITCH_STREAM_KEY"  ]; then
  echo "No TWITCH_STREAM_KEY set."
  exit 1
fi

ffmpeg -re $START_TIME -i "$VIDEO_SOURCE" -f flv -ac 2 -ar $AUDIO_RATE \
  -vcodec libx264 -g $GOP -keyint_min $GOPMIN -b:v $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p\
  -s $OUTRES -preset $QUALITY -tune film -acodec aac -threads $THREADS -strict normal \
  -bufsize $CBR "rtmp://$SERVER.twitch.tv/app/$STREAM_KEY"