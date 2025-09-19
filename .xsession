#!/bin/sh

mate-power-manager &
nm-applet &

xrdb ~/.Xresources

# Bell: C8, short
xset b 50 4186 25

if [ "${VNCDESKTOP:-not-vnc}" = not-vnc ]; then
    xmodmap - <<END
      ! Caps Lock as Control
      clear Lock
      keycode 66 = Control_L
      add Control = Control_L

      ! Natural scrolling
      pointer = 1 2 3 5 4 7 6 8 9 10 11 12 13 14 15 16
END
fi

for wm in blackbox fluxbox wmaker uxterm xterm; do
    if $wm -version; then
        if [ "$wm" = blackbox ]; then
            bbkeys &
        else
            wmclock &
        fi
        wmacpi -r -s 2 &
        wmapm &
        wmcpuload &
        (sleep 5; bbpager) &
        exec $wm
    fi
done

# Desperate?
fvwm || icewm || i3 || ctwm || twm || rxvt || urxvt

