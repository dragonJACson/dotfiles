# Begin ~/.bashrc
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>

# Personal aliases and functions.

# Personal environment variables and startup programs should go in
# ~/.bash_profile.  System wide environment variables and startup
# programs are in /etc/profile.  System wide aliases and functions are
# in /etc/bashrc.

# End ~/.bashrc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[[ $- != *i* ]] && return

alias ls='ls --color=auto'

alias ll='ls -l'
alias la='ls -la'
alias lh='ls -lh'
alias grep='grep --color'
alias g="git-annex"
alias k="kde-open5"
alias x="xdg-open"
export LESS="-R -N"

alias start="sudo systemctl start"
alias stop="sudo systemctl stop"
alias restart="sudo systemctl restart"
alias .="source"
alias cp="cp -i --reflink=auto"
alias ssh="TERM=xterm-256color ssh"
alias bc="bc -lq"
alias pvb="pv -W -F'Sent Total:%b In %t Cur:%r Avg:%a %p'"
alias kwin-blur="xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0"
alias kwin-clear="xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -remove _KDE_NET_WM_BLUR_BEHIND_REGION"
alias nvrun="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia"
alias gtar="tar -Ipigz czfv"
alias btar="tar -Ilbzip2 cjfv"
alias 7tar="7z a -mmt"
alias xcp="rsync -aviHAXKhP --delete --exclude='*~' --exclude=__pycache__"
alias tmux="tmux -2"

# pacman aliases and functions
function Syu(){
    sudo pacman -Sy && sudo powerpill -Suw $@ && sudo pacman -Su $@
}

alias Rcs="sudo pacman -Rcs"
alias Ss="pacman -Ss"
alias Si="pacman -Si"
alias Sl="pacman -Sl"
alias Sg="pacman -Sg"
alias Qs="pacman -Qs"
alias Qi="pacman -Qi"
alias Qo="pacman -Qo"
alias Ql="pacman -Ql"
alias Qlp="pacman -Qlp"
alias Qm="pacman -Qm"
alias Qn="pacman -Qn"
alias U="sudo pacman -U"
alias Fo="pacman -Fo"
alias Fl="pacman -Fl"
alias Fy="sudo pacman -Fy"
alias Sy="sudo pacman -Sy"
alias Ssa="cower -c -s"
alias Sas="cower -c -s"
alias Sia="cower -c -i"
alias Sai="cower -c -i"

alias vim="nvim"
alias gae="git commit --allow-empty"
alias pk="git cherry-pick"

function Ga() {
    [ -z "$1" ] && echo "usage: Ga <aur package name>: get AUR package PKGBUILD" && return 1
    TMPDIR=$(mktemp -d)
    git clone aur@aur.archlinux.org:"$1".git "$TMPDIR"
    rm -rf "$TMPDIR"/.git
    mkdir -p "$1"
    cp -r -i "$TMPDIR"/* "$1"/
    rm -rf "$TMPDIR"
}

function G() {
    [ -z "$3" ] && echo "usage: $0 <$2 package name>: get $2 package PKGBUILD" && return 1
    git clone https://git.archlinux.org/svntogit/$1.git/ -b packages/$3 --single-branch $3
    mv "$3"/trunk/* "$3"
    rm -rf "$3"/{repos,trunk,.git}
}

function Gw() {
    [ -z "$1" ] && echo "usage: Gw <package name> [directory (default to pwd)]: get package file *.pkg.tar.xz from pacman cache" && return 1
    sudo pacman -Sw "$1" && cp /var/cache/pacman/pkg/$1*.pkg.tar.xz ${2:-.}
}

alias Ge="G packages core/extra"
alias Gc="G community community"

alias rankpacman='sed "s/^#//" /etc/pacman.d/mirrorlist.pacnew | rankmirrors -n 10 - | sudo tee /etc/pacman.d/mirrorlist'

alias urldecode='python2 -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'
alias urlencode='python2 -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'
imgvim(){
    curl -F "name=@$1" https://img.vim-cn.com/
}

simg(){
    scrot $@ -e 'curl -F \"name=@$f\" https://img.vim-cn.com/'
}

alias pvim="curl -F 'vimcn=<-' https://cfp.vim-cn.com/"

fs() {
  curl -s -F "c=@${1:--}" "https://fars.ee/?u=1" | tee /dev/tty | perl -p -e 'chomp if eof' | xclip -i -selection clipboard
}

tcn() {
    curl "http://api.t.sina.com.cn/short_url/shorten.json?source=2333871470&url_long=$1"
}

dsf(){
    # depends on diff-so-fancy
    git diff --color=always $@ | diff-so-fancy | less
}

function _git_prompt() {
    local git_status="`git status -unormal 2>&1`"
    if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
        if [[ "$git_status" =~ nothing\ to\ commit ]]; then
            local ansi=42
        elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
            local ansi=43
        else
            local ansi=45
        fi
        if [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]; then
            branch=${BASH_REMATCH[1]}
            test "$branch" != master || branch=' '
        else
            # Detached HEAD.  (branch=HEAD is a faster alternative.)
            branch="(`git describe --all --contains --abbrev=4 HEAD 2> /dev/null ||
                echo HEAD`)"
        fi
        echo -n '\[\e[0;37;'"$ansi"';1m\]'"$branch"'\[\e[0m\] '
    fi
}
function _prompt_command() {
    PS1="`_git_prompt`"'\[\e[1;32m\]\u\[\e[m\]\[\e[0;32m\]@\h\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] '
}
PROMPT_COMMAND=_prompt_command

EDITOR="nvim"
export EDITOR
