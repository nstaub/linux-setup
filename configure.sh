#!/bin/bash

DIALOG=dialog

##{ DIALOG OUTPUT VALUES

DIALOG_OK=0
DIALOG_CANCEL=1
DIALOG_HELP=2
DIALOG_EXTRA=3
DIALOG_ITEM_HELP=4
DIALOG_ESC=255

SIG_NONE=0
SIG_HUP=1
SIG_INT=2
SIG_QUIT=3
SIG_KILL=9
SIG_TERM=15

##}

OUTFILE="/tmp/dialog_out"
MAKEFILE_CONFIG="Makefile.config"

# get the path to this script
MY_PATH=`dirname "$0"`
MY_PATH=`( cd "$MY_PATH" && pwd )`

rm "$OUTFILE"

##{ CHOOSE THE COMPONENTS

dialog \
  --backtitle "Select packages to install" \
  --title "CHECKLIST BOX" "$@" \
  --colors \
  --checklist "Select components for installation. If you change your mind, additional components can be installed by running:\n\n
                      \Zbmake component_name\Zn" 30 70 20 \
    "vim" "text editor" on \
    "tmux" "terminal multiplexer" on \
    "tmuxinator" "tmux session manager" on \
    "ranger" "terminal file explorer" on \
    "i3" "tiling window manager" on \
    "vimiv" "vim-like image viewer" on \
    "zathura" "vim-like pdf viewer" on \
    "latex" "latex development support" off \
    "athame" "vim integration to bash and zshell" off \
  2> "$OUTFILE"
BASIC_PACKAGES=$(cat "$OUTFILE")
echo "BASIC_PACKAGES: $BASIC_PACKAGES"

##}

##{ YES/NO FORM
# ## USE ATHAME?

# dialog \
#   --title "Use ATHAME" \
#   --colors \
#   --yesno "Do you want to use \ZbATHAME\Zn by default?" 15 61
# if [ "$?" == "0" ]; then
#   USE_ATHAME=1
# else
#   USE_ATHAME=0
# fi
##}

##{ ADDITIONAL SETTINGS AND PARAMETERS

returncode=0
while test $returncode != 1 && test $returncode != 250
do

  DEFAULT_GIT_PATH=`( cd "$MY_PATH/../" && pwd )`

  exec 3>&1
  value=`dialog --ok-label "Submit" \
      --backtitle "Default .bashrc settings" \
      --colors \
      --form "What should be the default .bashrc additions?" \
      30 70 0 \
        "Git path:"    1   1	  "$DEFAULT_GIT_PATH"           1   15   30    30        \
  2>&1 1>&3`
  returncode=$?
  exec 3>&-
        # label        y   x    item              y   x    flen  ilen

	case $returncode in
	$DIALOG_CANCEL)
		"$DIALOG" \
		--backtitle "$backtitle" \
		--yesno "Really quit?" 10 30
		case $? in
		$DIALOG_OK)
			break
      echo finished
			;;
		$DIALOG_CANCEL)
			returncode=99
			;;
		esac
		;;
	$DIALOG_OK)
    break
		;;
	$DIALOG_ERROR)
		echo "ERROR!$value"
		exit
		;;
	$DIALOG_ESC)
		echo "ESC pressed."
		exit
		;;
	*)
		echo "Return code was $returncode"
		exit
		;;
	esac
done

##}

##{ YES/NO DIALOG ON SETTINGS

dialog \
  --backtitle "Fill in the settingsj" \
  --title "CHECKLIST BOX" "$@" \
  --colors \
  --checklist "Choose your settings:\n\n
  \Zb\ZuRun Tmux\Zn {1, 0}: tmux will start atomatically with new terminal\n\n
  \Zb\ZuUse athame\Zn {1, 0}: when Athame is installed, this will make it run" 30 70 20 \
    "Run tmux" "run tmux in terminal automatically" on \
    "Use athame" "enable athame in .bashrc" off 2> "$OUTFILE"
BASIC_PACKAGES=$(cat "$OUTFILE")

##}

echo $BASIC_PACKAGES

# create the Makefile.config file

rm $MAKEFILE_CONFIG

echo "packages=$BASIC_PACKAGES" >> $MAKEFILE_CONFIG
echo "use_athame=$USE_ATHAME" >> $MAKEFILE_CONFIG
