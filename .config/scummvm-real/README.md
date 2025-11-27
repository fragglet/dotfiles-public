ScummVM's configuration directory is in `~/.config/scummvm`, but we install it
to `scummvm-real` and access it via a symlink. This ensures that when ScummVM
rewrites the config file, it overwrites the real file, rather than just
replacing the symlink.
