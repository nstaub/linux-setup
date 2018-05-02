packages=vim tmux

# Variables above can be overwrite by local configuration
-include Makefile.config

# define paths
CURDIR=$(shell pwd)
APPCONFIG_PATH=$(CURDIR)/appconfig

all: git_init $(packages) finito
	toilet All Done

git_init:
	@echo "submodule update --init --recursive"
	@git submodule update --init --recursive
	@echo 

# For each package do following step: download dependecies,
$(packages):
	@echo Installing "$@"
	@make --no-print-directory -C $(APPCONFIG_PATH)/$@
	@echo 

configure:
	@configure
	# $(foreach package, $(packages), @make -C $(APPCONFIG_PATH)/$(package) install_packages)

finito:
	@echo packages: $(packages)
