# Common configuration for shells with bourne-style syntax.

alias a="tmux -u -CC attach"
alias vi="vim -X"

export EDITOR=vim
export PAGER=less
export NETHACKOPTIONS="color,fruit:garglefruit,pickup_types:?/!$+,DECgraphics"
PATH="$HOME/.local/bin:/sbin:/usr/sbin:$PATH"

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

# Prefer emacs for browsing info pages, if installed.
info() {
    if [[ $# -eq 0 ]] && which emacsclient >/dev/null; then
        emacseval "(info)"
    elif [[ $# -eq 1 ]] && which emacsclient >/dev/null; then
        emacseval "(info \"$1\")"
    else
        command info "$@"
    fi
}

# Connect to existing emacs if there is one running.
emacs() {
    emacsclient -a "emacs -nw" -c -nw -q "$@"
}

emacseval() {
    emacsclient -a "emacs -nw --eval" -c -nw -q -e "$@"
}

export GPG_TTY=$(tty)

# good for SDL over remote X:
if [[ "$KERNEL" != "Darwin" ]] && [[ "${DISPLAY:-no-x}" != no-x ]]; then
    export SDL_VIDEODRIVER=x11
fi
if [[ "${SSH_CLIENT:-none}" != none ]]; then
    export SDL_RENDER_DRIVER=opengl SDL_RENDER_VSYNC=0 SDL_AUDIODRIVER=dummy
fi

export DOOMWADDIR=~/doom/doom2-1.9
export DOOMWADPATH=~/doom/doom2-1.9
for p in chex-quest doom-registered-1.9 doom-shareware-1.9 ultimate-doom-1.9 \
         strife-registered-1.31 heretic-registered-1.3 hexen-1.1; do
    DOOMWADPATH="$DOOMWADPATH:$HOME/doom/$p"
done

if [[ -e "$HOME/.bourneshrc.local.sh" ]]; then
    . "$HOME/.bourneshrc.local.sh"
fi
