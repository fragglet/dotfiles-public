#!/bin/sh

xrdb ~/.Xresources

for wm in blackbox fluxbox wmaker uxterm xterm; do
    if $wm -version; then
        wmcpuload &
        wmclock &
        (sleep 5; bbpager) &
        exec $wm
    fi
done

# Desperate?
fvwm || icewm || i3 || ctwm || twm || rxvt || urxvt

