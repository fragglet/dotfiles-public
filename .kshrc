case "$-" in *i*)
    . $HOME/.bourneshrc.sh
    ;;
esac

export HISTFILE="$HOME/.ksh_history"

if [ $(uname) = OpenBSD ]; then
    PS1='\u@\h:\w\$ '
else
    PS1="$USER@$(hostname -s):\$(pwd)$ "
fi
