alias vi=vim
export EDITOR=vim
export NETHACKOPTIONS="color,fruit:garglefruit,pickup_types:?/!$+,DECgraphics"
set -o emacs
export HISTFILE="$HOME/.ksh_history"

PATH="$HOME/.local/bin:$PATH"

export LESSOPEN="|lesspipe.sh %s"
export LESS="--ignore-case --RAW-CONTROL-CHARS"

if [ -e ~/.ssh/auth_sock.sh ]; then
    . ~/.ssh/auth_sock.sh
fi

if [ $(uname) = OpenBSD ]; then
    PS1='\u@\h:\w\$ '
else
    PS1="$USER@$(hostname -s):\$(pwd)$ "
fi
