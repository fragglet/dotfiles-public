#!/bin/sh

set -eu

# Point $1 to $2, replacing existing symlink at $2 if necessary.
# Fails if $2 is a directory, in which case user should fix.
symlink() {
	rm -f "$2"
	ln -s "$1" "$2"
}

exclude_files() {
	grep -v "^./.git/" \
		| grep -v "^./install.sh" \
		| grep -v "^./.gitignore" \
		| grep -v "^./.gitmodules" \
		| grep -v "swp$" \
		| grep -v "^./modules"
}

# macos? add symlinks from ~/.local into ~/Library directory.
if [ -d ~/Library ]; then
	# We have to copy the .ttf files in, symlinks don't work.
	mkdir -p ~/Library/Fonts
	cp .fonts/*.ttf ~/Library/Fonts

	mkdir -p ~/.local/share ~/.config/gzdoom
	for d in .local/share/*; do
		bn=$(basename "$d")
		mkdir -p "$HOME/Library/Application Support/$bn"
		symlink "$HOME/Library/Application Support/$bn" \
		        "$HOME/.local/share/$bn"
	done
	ln -sf "$HOME/.config/gzdoom/gzdoom.ini" \
	       "$HOME/Library/Preferences/gzdoom.ini"
	ln -sf "$HOME/.config/GIMP" \
	       "$HOME/Library/Application Support/GIMP"
fi

chmod go-rwx .ssh
git submodule init
git submodule update

# Fixups for earlier version:
if [ -d ~/.dosbox/ydrive/ultrasnd/midi ]; then
    rm -rf ~/.dosbox/ydrive/ultrasnd/midi
fi
if [ -d ~/.config/GIMP/3.0/palettes ] && \
   [ ! -L ~/.config/GIMP/3.0/palettes ]; then
    mv ~/.config/GIMP/3.0/palettes/* ~/.config/GIMP/2.10/palettes/
    rmdir ~/.config/GIMP/3.0/palettes
fi

find . -type f -or -type l | exclude_files | while read filename; do
	# Make any mising directories.
	dir=$(dirname "$filename")
	mkdir -p "$HOME/$dir"

	dst="$HOME/$filename"

	if [ -f "$dst" ] && ! [ -h "$dst" ]; then
		echo "$filename already exists; copying local version"
		cp "$dst" "$filename"
	fi
	symlink "$PWD/$filename" "$dst"
done

# gtk 2.0 uses gtk 3.0 bookmarks (should be ok?)
symlink "$PWD/.config/gtk-3.0/bookmarks" ~/.gtk-bookmarks

# Generate vim help file tags
if vim --version >/dev/null; then
	vim -e -c "helptags ALL" -c "exit" >/dev/null
fi
