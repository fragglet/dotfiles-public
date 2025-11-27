#
# ssh auth socks management
#
# When logging in with `ssh -A`, a socket is created, the location of which is
# stored in the `SSH_AUTH_SOCK` environment variable. However, this causes
# problems with programs like `screen` and `tmux`. if you disconnect and log in
# again, your screen sessions will point at the old auth socket that no longer
# exists. This script (should be sourced in `.bashrc` or similar) fixes this.
#
# What this does:
#  * When logging in remotely, the auth socket gets added to a pool of auth
#    socket links in `~/.ssh/auth_socks/`. The pool is automatically
#    maintained so that dead links get deleted.
#  * The `SSH_AUTH_SOCK` variable is pointed at a symlink, `~/.ssh/auth_sock`.
#  * The link is automatically updated on each login to point to the latest
#    auth socket, so that we don't try to use older, dead links.
#  * When logging out, the connection's link is deleted and the symlink
#    updated if necessary, so that we always try to find a working connection
#    to send auth requests to.
#

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

