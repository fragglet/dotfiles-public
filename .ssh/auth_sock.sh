
_update_auth_sock() {
    if ! ls ~/.ssh/auth_socks | grep -q ""; then
        # No sockets
        return
    fi

    local sockfile

    for sockfile in $(ls -t ~/.ssh/auth_socks/*); do
        if [ ! -L "$sockfile" ]; then
            continue
        elif [ ! -e "$sockfile" ]; then
            # Socket deleted, from a dead ssh connection.
            rm -f "$sockfile"
        else
            ln -sf "$sockfile" ~/.ssh/auth_sock
            break
        fi
    done
}

_init_auth_sock() {
    # We only do any of this for remote logins.
    if [ "${SSH_CLIENT:-none}" = "none" ]; then
        return
    fi
    local central_auth_sock="$HOME/.ssh/auth_sock"
    if [ -z "$SSH_AUTH_SOCK" ]; then
        return
    fi
    if [ "$SSH_AUTH_SOCK" != "$central_auth_sock" ]; then
        # This is a new SSH connection, add to the database:
        local sockid=$(echo "$SSH_AUTH_SOCK" | tr / _)
        mkdir -p ~/.ssh/auth_socks
        SSH_AUTH_SOCK_LINK=~/.ssh/auth_socks/$sockid

        ln -sf "$SSH_AUTH_SOCK" "$SSH_AUTH_SOCK_LINK"
    fi

    _update_auth_sock

    # Switch to using the central socket
    SSH_AUTH_SOCK=$central_auth_sock
}

_init_auth_sock

# On exit, delete the symlink and reset the link to a valid socket:
if [ -n "$SSH_AUTH_SOCK_LINK" ]; then
    trap "rm -f $SSH_AUTH_SOCK_LINK; _update_auth_sock" EXIT
fi

