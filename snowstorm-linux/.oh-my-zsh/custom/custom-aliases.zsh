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
alias gpup="GPHOTOS_CLI_TOKENSTORE_KEY='when will you come home?' /home/andy/bin/gphotos-uploader-cli push"
alias g85all="aws s3 sync --profile grange85 --size-only --delete --exclude '.sass-cache' /home/andy/repos/grange85-media-cdn/ s3://cdn.grange85.co.uk"
alias moonshot="gnome-terminal --tab-with-profile=moonshot"
# alias python="python3"

alias cls='clear'
alias hg='history | grep -i'
alias fx='find . -type f -not -path '\''./.git/*'\'' | sed -n '\''s/..*\.//p'\'' | sort | uniq -c'
egrep='grep -E --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,vendor}'
fgrep='grep -F --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,vendor}'
grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,vendor}'

function search_mfow {
	aws s3 ls --profile grange85  s3://media-new.fullofwishes.co.uk --recursive | cut -c 32- | egrep -i $1 | sed 's_^_https://media.fullofwishes.co.uk/_'
}

function mrc {
	convert $1 -resize 1280x1280 ~/ahfow-data/media/00-misc/my-record-collection/$2	
}

function create_issue {
	gh issue create --repo grange85/ahfow-www-comments --title "$1" --body "### [View post](https://www.fullofwishes.co.uk$2)  
$3"
}
alias sshm='ssh -t moonshot.g85 screen -Rdf'
alias ssht='ssh -t tugboat.g85 screen -Rdf'

viewmd() {
    local src html
    src="$(realpath "$1")" || return 1
    html="/tmp/$(basename "${src%.*}").html"

    pandoc "$src" -s --metadata title="$(basename "$src")" -o "$html" || return 1

    # only open a new tab if one isn't already open on this file
    if ! pgrep -f "firefox.*${html}" >/dev/null 2>&1; then
        (xdg-open "$html" &disown) >/dev/null 2>&1
    fi
}
