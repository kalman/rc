RC := $(HOME)/.rc

.PHONY: all profile vim gdbinit

all: profile vim gdbinit

profile:
	rm -rf $(HOME)/.profile
	ln -s $(RC)/profile $(HOME)/.profile

vim:
	rm -rf $(HOME)/.vim
	rm -rf $(HOME)/.vimrc
	ln -s $(RC)/vim $(HOME)/.vim
	ln -s $(RC)/vimrc $(HOME)/.vimrc

gdbinit:
	rm -rf $(HOME)/.gdbinit
	ln -s $(RC)/gdbinit $(HOME)/.gdbinit
