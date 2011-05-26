.PHONY: all profile vim

all: profile vim

profile:
	rm -rf $(HOME)/.profile
	ln -s $(HOME)/.rc/profile $(HOME)/.profile

vim:
	rm -rf $(HOME)/.vim
	rm -rf $(HOME)/.vimrc
	ln -s $(HOME)/.rc/vim $(HOME)/.vim
	ln -s $(HOME)/.rc/vimrc $(HOME)/.vimrc
