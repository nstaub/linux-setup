packages=vim tmux

# Variables above can be overwrite by local configuration
-include Makefile.config

# define paths
CURDIR=$(shell pwd)
APPCONFIG_PATH=$(CURDIR)/appconfig

# call make in the subdirectory of a submodule
NESTED_MAKE=@make --no-print-directory -C $(APPCONFIG_PATH)/$@

.ONESHELL:

all: git_init $(packages) finish
	toilet All Done

git:
	sudo apt-get -y install git

git_init: git
	echo "Updating submodules"
	git git pull
	git submodule update --init --recursive
	echo 

dialog:
	cd /tmp
	rm -rf dialog
	mkdir dialog
	cd dialog
	wget http://invisible-island.net/datafiles/release/dialog.tar.gz
	tar -xvzf dialog.tar.gz
	cd `ls -d */`
	pwd
	./configure
	make
	sudo make install

configure: dialog
	./configure.sh

dependencies:
	sudo apt-get -y update
	sudo apt-get -y remove vim-*
	sudo apt-get -y install cmake cmake-curses-gui ruby git sl htop git indicator-multiload figlet toilet gem ruby build-essential tree exuberant-ctags libtool automake autoconf autogen libncurses5-dev python3-dev python2.7-dev libc++-dev clang-3.8 clang-format openssh-server pandoc xclip xsel python-git vlc pkg-config pdftk python3-setuptools ffmpeg sketch
	sudo apt-get -y install exfat-fuse exfat-utils

tmux:
	$(NESTED_MAKE)

vim:
	$(NESTED_MAKE)

tmuxinator:
	$(NESTED_MAKE)

ranger:
	$(NESTED_MAKE)

athame: vim
	$(NESTED_MAKE)

urvxt: i3
	$(NESTED_MAKE)

latex:
	$(NESTED_MAKE)

finish:
	@echo finished installing packages: $(packages)
