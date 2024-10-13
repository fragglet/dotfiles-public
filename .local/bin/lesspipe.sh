#!/bin/sh

filename="$1"

tmpoutput() {
    dir=$(mktemp -d)
    if ! "$@" 2>$dir/errlog; then
        echo "Filter command '$@' failed"
        echo "To try again without filter:"
        echo "  less -L $filename"
        echo
        echo "Error output:"
        cat $dir/errlog
    fi
    rm -f $dir/errlog
    rmdir $dir
}

simple_filename=$(basename "$filename" | tr A-Z a-z)

# Try mediainfo first, if it's installed.
case "$simple_filename" in
    *.mkv|*.ogm|*.avi|*.wmv|*.mpg|*.mp4|*.mov|*.webm|*.ogg|*.mp3|*.wav|*.flac|*.jpg|*.jpeg|*.gif|*.png|*.bmp|*.pcx|*.tiff)
        if mediainfo -v >/dev/null 2>&1; then
            tmpoutput mediainfo "$filename"
            exit
        fi
        ;;
esac

case "$simple_filename" in
    *.tar)
        tmpoutput tar -tvf "$filename"
        ;;
    *.tar.Z|*.tar.gz|*.tgz)
        gunzip < "$filename" | tmpoutput tar -tvf -
        ;;
    *.gz)
        tmpoutput gunzip < "$filename"
        ;;
    *.tar.bz2)
        bunzip2 < "$filename" | tmpoutput tar -tvf -
        ;;
    *.bz2)
        tmpoutput bunzip2 < "$filename"
        ;;
    *.tar.xz)
        unxz < "$filename" | tmpoutput tar -tvf -
        ;;
    *.xz)
        tmpoutput unxz < "$filename"
        ;;
    *.tar.lz)
        lzip -d < "$filename" | tmpoutput tar -tvf -
        ;;
    *.lz)
        tmpoutput lzip -d < "$filename"
        ;;
    *.tar.zst)
        unzstd < "$filename" | tmpoutput tar -tvf -
        ;;
    *.zst)
        tmpoutput unzstd < "$filename"
        ;;
    *.cpio)
        tmpoutput cpio --verbose -t -F "$filename"
        ;;
    *.zip)
        tmpoutput unzip -l "$filename"
        ;;
    *.lzh|*.pma|*.lzs)
        tmpoutput lha v "$filename"
        ;;
    *.rar)
        tmpoutput unrar v "$filename"
        ;;
    *.arj)
        tmpoutput arj v "$filename"
        ;;
    *.7z)
        tmpoutput 7z l "$filename"
        ;;
    *.ace)
        tmpoutput unace v "$filename"
        ;;
    *.arc|*.ark)
        tmpoutput nomarch v "$filename"
        ;;
    *.cab)
        tmpoutput cabextract -l "$filename"
        ;;
    *.wad)
        tmpoutput deutex -wadir "$filename"
        ;;
    *.bin)
        tmpoutput xxd < "$filename"
        ;;
    *.cap)
        tmpoutput tcpdump -nvvvxxx -r "$filename"
        ;;
    *.iso)
        tmpoutput isoinfo -l -R -J -i "$filename"
        ;;
    *.doc)
        if file -bi "$filename" | grep -qi msword; then
            tmpoutput antiword "$filename"
        else
            exit 1
        fi
        ;;
    *.[ao]|*.obj|core|core.*|*.core)
        (readelf -h -l -g "$filename"; objdump -S "$filename") | tmpoutput cat
        ;;
    *.deb)
        tmpoutput dpkg -c "$filename"
        ;;
    *.mp3)
        tmpoutput id3tool "$filename"
        ;;
    *.flac)
        tmpoutput metaflac --list "$filename"
        ;;
    *.ogg)
        tmpoutput ogginfo "$filename"
        ;;
    *.jpg|*.jpeg)
        tmpoutput exif "$filename"
        ;;
    *.png)
        tmpoutput pngmeta --all "$filename"
        ;;
    *.gpg)
        tmpoutput gpg --pinentry-mode=error -d "$filename"
        ;;
    *.ttf)
        tmpoutput ttfdump "$filename"
        ;;
    *.ps)
        tmpoutput ps2txt "$filename"
        ;;
    *.pdf)
        tmpoutput pdftotext "$filename" -
        ;;
    *.rtf)
        tmpoutput unrtf --text --quiet --nopict "$filename"
        ;;
    *.qcow|*.qcow2|*.vdi|*.vhdx|*.vmdk)
        tmpoutput qemu-img info "$filename"
        ;;
    *.sqlite|*.sqlite3)
        tmpoutput sqlite3 -readonly "$filename" .dump
        ;;
    *.plist)
        if file "$filename" | grep -qi binary; then
            tmpoutput plutil -p "$filename"
        else
            exit 1  # Might be text format plist
        fi
        ;;
    *)
        if [ -d "$filename" ]; then
            tmpoutput ls -al "$filename"
            exit 0
        fi
        exit 1
        ;;
esac
