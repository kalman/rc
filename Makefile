RC := $(HOME)/.rc

.PHONY: all profile vim gdbinit gitconfig rc_scripts screenrc

all: profile vim gdbinit gitconfig rc_scripts screenrc

profile:
	rm -f $(HOME)/.profile
	ln -s $(RC)/profile $(HOME)/.profile

vim:
	rm -rf $(HOME)/.vim
	rm -f $(HOME)/.vimrc
	ln -s $(RC)/vim $(HOME)/.vim
	ln -s $(RC)/vimrc $(HOME)/.vimrc

gdbinit:
	rm -f $(HOME)/.gdbinit
	ln -s $(RC)/gdbinit $(HOME)/.gdbinit

gitconfig:
	rm -f $(HOME)/.gitconfig
	ln -s $(RC)/gitconfig $(HOME)/.gitconfig

rc_scripts:
	mkdir -p $(HOME)/local
	rm -f $(HOME)/local/rc_scripts
	ln -s $(RC)/scripts $(HOME)/local/rc_scripts

screenrc:
	ln -f $(RC)/screenrc $(HOME)/.screenrc
