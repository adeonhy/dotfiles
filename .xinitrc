#!/bin/sh


if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

/usr/bin/VBoxClient-all

#xrdb -merge ~/.Xresources         # update x resources db

#xscreensaver -no-splash &         # starts screensaver daemon 
#xsetroot -cursor_name left_ptr &  # sets the cursor icon
#sh ~/.fehbg &                     # sets the background image

#exec openbox-session              # starts the window manager

exec startxfce4
#exec startlxde

