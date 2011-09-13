RC := $(HOME)/.rc

.PHONY: all profile vim gdbinit gitconfig

all: profile vim gdbinit

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
