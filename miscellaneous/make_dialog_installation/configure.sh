#!/bin/bash

OUTFILE="/tmp/dialog_out"
MAKEFILE_CONFIG="Makefile.config"

rm "$OUTFILE"

dialog \
  --backtitle "Select packages to install" \
  --title "CHECKLIST BOX" "$@" \
  --clear \
  --colors \
  --checklist "some text" 30 50 20 \
    "vim" "text editor" on \
    "tmux" "terminal multiplexer" on \
    "tmuxinator" "tmux session manager" on \
    "ranger" "terminal file explorer" on \
    "i3" "tiling window manager" on \
    "vimiv" "vim-like image viewer" on \
    "zathura" "vim-like pdf viewer" on \
    "latex" "latex support" off \
    "athame" "vim integration for bash and zsh" off \
    "zsh" "shell (bash alternative)" off 2> "$OUTFILE" 

BASIC_PACKAGES=$(cat "$OUTFILE")

echo $BASIC_PACKAGES

# create the Makefile.config file

rm $MAKEFILE_CONFIG

echo "packages=$BASIC_PACKAGES" >> $MAKEFILE_CONFIG
