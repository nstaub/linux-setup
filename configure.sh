#!/bin/bash

OUTFILE="/tmp/dialog_out"
MAKEFILE_CONFIG="Makefile.config"

rm "$OUTFILE"

## BASIC COMPONENTS

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

## USE ATHAME?

dialog \
  --title "Use ATHAME" \
  --clear "$@" \
  --colors \
  --yesno "Do you want to use \ZbATHAME\Zn by default?" 15 61
if [ "$?" == "0" ]; then
  USE_ATHAME=1
else
  USE_ATHAME=0
fi

echo $BASIC_PACKAGES

# create the Makefile.config file

rm $MAKEFILE_CONFIG

echo "packages=$BASIC_PACKAGES" >> $MAKEFILE_CONFIG
echo "use_athame=$USE_ATHAME" >> $MAKEFILE_CONFIG
