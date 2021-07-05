#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Environment Variable to fix Java Sway apps
export _JAVA_AWT_WM_NONREPARENTING=1

# Adding in some environment variables for Qt & GTK
export QT_AUTO_SCREEN_SET_FACTOR=0
export QT_SCALE_FACTOR=1
export QT_FONT_DPI=96

#export QT_QPA_PLATFORMTHEME=qt5ct

# Starting applications & DWM
killall picom; picom &

~/.fehbg &
dwmblocks &
exec dwm
