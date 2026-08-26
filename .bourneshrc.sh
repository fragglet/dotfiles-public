# Common configuration for shells with bourne-style syntax.

alias a="tmux -u -CC attach"
alias vi="vim -X"
alias cgrep="grep -C5"

export EDITOR=vim
export PAGER=less
export NETHACKOPTIONS="color,fruit:garglefruit,autopickup,pickup_types:?/!$+,DECgraphics,!tutorial"
PATH="$HOME/.local/bin:/sbin:/usr/sbin:$PATH:/usr/games:/usr/local/games"

set -o emacs

export LESSOPEN="|lesspipe.sh %s"
export LESS="--ignore-case --RAW-CONTROL-CHARS"

if [[ -e ~/.ssh/auth_sock.sh ]]; then
    . ~/.ssh/auth_sock.sh
fi

# xterm can do better than it pretends
if [[ "$TERM" = xterm ]] && [[ "$XTERM_VERSION" != "" ]]; then
    TERM=xterm-256color
fi

KERNEL=$(uname -s)

# The only sensible and correct date format for `ls -l`.
export TIME_STYLE=long-iso

# Sensible `df` and `du` output on BSD systems.
export BLOCKSIZE=1m

# Generate coredumps
# On NetBSD this "exceeds allowable limit"
if [[ "$KERNEL" != "NetBSD" ]]; then
    ulimit -c unlimited
fi

# Prefer gmake over BSD.
make() {
    if which gmake >/dev/null; then
        command gmake "$@"
    else
        command make "$@"
    fi
}

if [[ "${MAKEFLAGS:-unset}" = unset ]]; then
    NUM_CPUS=$(nproc 2>/dev/null || echo 4)
    export MAKEFLAGS=-j${NUM_CPUS}
fi

# I always forget.
alias rescan=rehash

# Minimalist alternative to the info command that works like "man":
minfo() {
    info --subnodes -o - "$@" | less
}

# Connect to existing emacs if there is one running.
emacs() {
    emacsclient -a "emacs -nw" -c -nw -q "$@"
}

start-ssh-agent() {
    ssh-agent > ~/.ssh/agent-env
    . ~/.ssh/agent-env
    ssh-add
}

export GPG_TTY=$(tty)

if [[ "${XDG_SESSION_TYPE:-nil}" = "wayland" ]]; then
    export SDL_VIDEODRIVER=wayland
elif [[ "$KERNEL" != "Darwin" ]] && [[ "${DISPLAY:-no-x}" != no-x ]]; then
    export SDL_VIDEODRIVER=x11
fi
if [[ "${SSH_CLIENT:-none}" != none ]]; then
    # good for SDL over remote X:
    export SDL_RENDER_DRIVER=opengl SDL_RENDER_VSYNC=0 SDL_AUDIODRIVER=dummy
fi

export DOOMWADDIR=~/doom/doom2-1.9
export DOOMWADPATH=~/doom/doom2-1.9
for p in chex-quest doom-registered-1.9 doom-shareware-1.9 ultimate-doom-1.9 \
         strife-registered-1.31 heretic-registered-1.3 hexen-1.1; do
    DOOMWADPATH="$DOOMWADPATH:$HOME/doom/$p"
done

export ANSIBLE_NOCOWS=1

# Make gzip files / .tar.gz files rsyncable; this also makes backups more
# recoverable since the state is reset periodically:
if [[ "$KERNEL" = "Linux" ]]; then
    export GZIP=--rsyncable
fi

bazel-dir() {
    local dir=$PWD
    local subpart=""
    while [[ ! -e "$dir/$1" ]]; do
        if [[ "$dir" = / ]]; then
            echo "$1 not found" >&2
            return 1
        fi
        subpart=$(basename "$dir")/"$subpart"
        dir=$(dirname "$dir")
    done
    echo "$dir/$1/$subpart"
}

bb() {
    bazel-dir bazel-bin
}

if [[ -e "$HOME/.bourneshrc.local.sh" ]]; then
    . "$HOME/.bourneshrc.local.sh"
fi
