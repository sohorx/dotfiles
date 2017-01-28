# enforce correct locales from beginning
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES=C
# XDG
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_RUNTIME_DIR="$HOME/.runtime"
# XDG_CONFIG 
export GIMP2_DIRECTORY="$XDG_CONFIG_HOME/gimp"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export MPLAYER_HOME="$XDG_CONFIG_HOME/mplayer"
export WEECHAT_HOME="$XDG_CONFIG_HOME/weechat"
# gtk+
#export GTK_IM_MODULE_FILE="/etc/gtk-2.0/gtk.immodules"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
# XDG_RUNTIME
export TMUX_TMPDIR="$XDG_RUNTIME_DIR/tmux"
export RXVT_SOCKET="$XDG_RUNTIME_DIR/urxvt/urxvt-$(hostname)"
# fix gtk+ noisy warnings and errors
#export GTK_IM_MODULE=xim #--> scim make firefox segfault
# fix gtk2 noisy warnings and errors
# export GDK_NATIVE_WINDOWS=true -> make gtk3 segfault
# IBUS
#export GTK_IM_MODULE=ibus
#export QT_IM_MODULE=ibus
#export XMODIFIERS=@im=ibus
# Start IBUS deamon
#ibus-daemon -drx
# Time set
ntpd -qg & # set os to ntp time
hwclock --systohc # set os time on hardware clock
# Remove anoying beep (should already be blacklisted)
rmmod pcspkr
# Disable bell (tehe)
xset -b
# Set X configuration (term, dpi,...)
xrdb merge ~/.config/Xresource/Xresources
# Hide the useless mouse when it doesn't move
unclutter -idle 1 -jitter 2 -root &
# change key rate
xset r rate 185 50
# Enable zapping (C-A-<Bksp> kills X)
setxkbmap -option terminate:ctrl_alt_bksp
# remap keys
xmodmap ~/.config/Xmodmap
# start urxvt daemon
urxvtd --quiet --opendisplay --fork
# notifycation daemon
dunst &
# music player daemon
mpd
# set font
sh $XDG_CONFIG_HOME/feh/bg
# start rtorrent in a tmux session
sh ~/bin/launch.rtorrent
# xmonad doest not set cursor style
xsetroot -cursor_name left_ptr
# compositor (-b == daemon version)
#compton -f -O 0.1 -I 0.04 -m 0.88 -b
compton --config ~/.config/compton.conf &> /dev/null &

#exec i3
# exec dbus-launch i3
exec xmonad
