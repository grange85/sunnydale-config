# You can put files here to add functionality separated per file, which
# will be ignored by git.
# Files on the custom/ directory will be automatically loaded by the init
# script, in alphabetical order.

# For example: add yourself some shortcuts to projects you often work on.
#
# brainstormr=~/Projects/development/planetargon/brainstormr
# cd $brainstormr
#
#
alias bej="bundle exec jekyll"
alias bejs="bundle exec jekyll serve --config _config.yml,_config_development.yml"
alias mediaall="aws s3 sync --profile grange85 --size-only --delete --exclude '.sass-cache' --exclude '*.comments/*' /media/raid1/DATA/ahfow/media/ s3://media-new.fullofwishes.co.uk"
alias mediag500="aws s3 sync --profile grange85 --size-only --delete --exclude '.sass-cache' --exclude '*.comments/*' /media/raid1/DATA/ahfow/media/01-galaxie_500/ s3://media-new.fullofwishes.co.uk/01-galaxie_500"
alias medialuna="aws s3 sync --profile grange85 --size-only --delete --exclude '.sass-cache' --exclude '*.comments/*' /media/raid1/DATA/ahfow/media/02-luna/ s3://media-new.fullofwishes.co.uk/02-luna"
alias mediadan="aws s3 sync --profile grange85 --size-only --delete --exclude '.sass-cache' --exclude '*.comments/*' /media/raid1/DATA/ahfow/media/03-damon_and_naomi s3://media-new.fullofwishes.co.uk/03-damon_and_naomi"
alias gpup="GPHOTOS_CLI_TOKENSTORE_KEY='When Will You Come Home' /home/andy/bin/gphotos-uploader-cli push"
alias g85all="aws s3 sync --profile grange85 --size-only --delete --exclude '.sass-cache' /home/andy/repos/grange85-media-cdn/ s3://cdn.grange85.co.uk"
# alias python="python3"

alias cls='clear'
alias hg='history | grep -i'
alias fx='find . -type f -not -path '\''./.git/*'\'' | sed -n '\''s/..*\.//p'\'' | sort | uniq -c'
alias egrep='grep -E --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,vendor}'
alias fgrep='grep -F --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,vendor}'
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,vendor}'
alias jop='nohup joplin --no-sandbox&'
alias sshm='ssh -t moonshot.g85 screen'
alias beetsx='/home/andy/bin/beets/venv/bin/beet'



function search_mfow {
	aws s3 ls --profile grange85  s3://media-new.fullofwishes.co.uk --recursive | cut -c 32- | egrep -v "instagram" | egrep -i $1 | sed 's_^_https://media.fullofwishes.co.uk/_'
}

function mrc {
	convert $1 -resize 1280x1280 ~/ahfow-data/media/00-misc/my-record-collection/$2	
}

function create_issue {
	gh issue create --repo grange85/ahfow-www-comments --title "$1" --body "### [View post](https://www.fullofwishes.co.uk$2)  
$3"
}

function upscale_to_4k { \
ffmpeg -i $1 \
  -vf scale=3840x2160:flags=lanczos \
  -c:v libx264 \
  -crf 13 \
  -c:a aac -b:a 512k \
  -preset slow \
  $2
}

setphotodate() {
    local file="$1"
    local date="$2"
    local time="${3:-12:00:00}"
    exiftool -DateTimeOriginal="${date} ${time}" -CreateDate="${date} ${time}" "$file"
}
compdef '_files' setphotodate
process_video() {
  INPUT="$1"
  OUTPUT="${2:-output.mp4}"
  CROP_LOCATION="${3:-centre}"
  START="${4:-0}"          # Start time in seconds (default: 0)
  DURATION=90              # Always 90 seconds
  FADE_DURATION="${5:-1}"  # Fade duration in seconds (default: 1s)
  # Get source video dimensions
  WIDTH=$(ffprobe -v error -select_streams v:0 \
    -show_entries stream=width -of csv=p=0 "$INPUT")
  HEIGHT=$(ffprobe -v error -select_streams v:0 \
    -show_entries stream=height -of csv=p=0 "$INPUT")

  # Calculate 4:5 crop dimensions
  # Target: width = height * 4/5
  TARGET_W=$(( HEIGHT * 4 / 5 ))
  TARGET_H=$HEIGHT

  # If target width exceeds source width, fit to width instead
  if [ "$TARGET_W" -gt "$WIDTH" ]; then
    TARGET_W=$WIDTH
    TARGET_H=$(( WIDTH * 5 / 4 ))
  fi

  if [[ "$CROP_LOCATION" == "left" ]]; then
    # Left crop
    CROP_X=0
    CROP_Y=$(( (HEIGHT - TARGET_H) / 2 ))
  elif [[ "$CROP_LOCATION" == "right" ]]; then
    # Right crop
    CROP_X=$(( WIDTH - TARGET_W ))
    CROP_Y=$(( (HEIGHT - TARGET_H) / 2 ))
  else
    # Center the crop
    CROP_X=$(( (WIDTH - TARGET_W) / 2 ))
    CROP_Y=$(( (HEIGHT - TARGET_H) / 2 ))
  fi

  # Fade out starts this many seconds before the clip ends
  FADE_OUT_START=$(( DURATION - FADE_DURATION ))

  echo "---"
  echo $FADE_DURATION
  echo $FADE_OUT_START
  echo "---"

  ffmpeg -ss "$START" \
	-i "$INPUT" \
    -t "$DURATION" \
    -vf "crop=${TARGET_W}:${TARGET_H}:${CROP_X}:${CROP_Y},\
fade=t=in:st=0:d=${FADE_DURATION},\
fade=t=out:st=${FADE_OUT_START}:d=${FADE_DURATION}" \
    -af "afade=t=in:st=0:d=${FADE_DURATION},\
afade=t=out:st=${FADE_OUT_START}:d=${FADE_DURATION}" \
    -c:v libx264 -crf 18 -preset fast \
    -c:a aac -b:a 192k \
    -movflags +faststart \
    "$OUTPUT"
}
