#!/bin/bash

#
# Platform specific (first because some stuff in here relies on it)
#

case `uname` in
  Darwin) source $HOME/.rc/profile_Darwin ;;
  Linux)  source $HOME/.rc/profile_Linux ;;
esac

#
# Paths etc
#

# Mac gets crappy hostname sometimes.
__hostname() {
  hostname -s | sed -E 's/dhcp-(.*)$/mac/'
}
export PS1='\[\033[01;32m\]$(__hostname)\[\033[01;34m\] \w\[\033[31m\]$(__git_ps1 "(%s)") \[\033[00m\]'

export GOROOT="$HOME/local/go"
export EDITOR="vim"
export SVN_LOG_EDITOR="$EDITOR"

export PATH="$HOME/local/bin:$PATH"
export PATH="$HOME/local/depot_tools:$PATH"
export PATH="$HOME/src/chromium/src/third_party/WebKit/Tools/Scripts:$PATH"
export PATH="$GOROOT/bin:$PATH"

#
# General
#

alias fn='find . -name'
alias cd='cd -P'
alias c=cd
alias l=ls
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -lA'
alias v=vim
alias vp='vim -p'
alias vs='vim -S'
alias wg='wget --no-check-certificate -O-'
alias grep='grep --color'
alias grr="grep -rn --color --exclude='.svn'"
alias s="screen -DR"
alias prepend='sed "s|^|$1"'

vl() {
  file=`echo "$1" | cut -d: -f1`
  line=`echo "$1" | cut -d: -f2`
  v "$file" +"$line"
}

#
# Git
#

source "$HOME/.rc/git_completion"

alias g="git"
alias gch="git checkout"
alias gb="git branch"
alias gd="git diff"
alias gs="git status"
alias gc="git commit"
alias gst="git status"
alias gl="git log"
alias gr="git rebase"
alias gp="git pull"
alias gls="git ls-files"
alias gm="git merge"
alias ga="git add"
alias gchm="git checkout master"
alias gdnm="git diff --numstat master"
alias gdns="git diff --name-status"
alias glf="git ls-files"
alias gmb="git merge-base"
alias gg="git grep"

complete -o default -o nospace -F _git_checkout gch
complete -o default -o nospace -F _git_branch gb
complete -o default -o nospace -F _git_rebase gr

unmerged() {
  git status -s | grep '^[AUD][AUD] ' | cut -f2 -d' '
}

gcb() {
  gb | grep '^*' | cut -f2- -d' '
}

gbase() {
  branch=`gcb`
  gmb $branch origin/trunk
}

changed() {
  gdns `gbase` | cut -f2
}

#
# Chromium/WebKit
#

alias cdw="cd $HOME/chromium/third_party/WebKit"
alias cdc="cd $HOME/chromium"
alias bw=build-webkit
alias rwt=run-webkit-tests
alias nrwt=new-run-webkit-tests
alias lkgr='curl http://chromium-status.appspot.com/lkgr'
alias rl=run-launder
alias pc='prepare-ChangeLog --merge-base `git merge-base master HEAD`'

wkup() {
  git fetch && git svn rebase
  # && update-webkit --chromium
}

crup() {
  old_dir=`pwd`

  cdw
  if [ `gcb` != gclient ]; then
    echo 'WARNING: WebKit not on gclient.  It will not be synced.'
  fi

  cdc

  echo; echo "Updating Chromium..."
  git pull

  if [ -n "$1" ]; then
    version="$1"
  else
    lkgr=`lkgr 2>/dev/null`
    version=`gl --grep=src@$lkgr | head -n1 | cut -f2- -d' '`
  fi
  echo; echo "Resetting to $version"
  git reset --hard "$version"

  echo; echo "Syncing non-WebKit deps..."
  gclient sync -fDj 32

  if [ `gcb` == gcilent ]; then
    echo; echo "Syncing WebKit..."
    cdw
    git pull origin master
    cdc
    tools/sync-webkit-git.py
    cdw
    git reset --hard
  fi

  echo; echo "Done."
  cd "$old_dir"
}

crpatch() {
  # TODO: make sure there are no changes between this branch and origin/trunk

  if [ -z "$1" ]; then
    echo "Usage: crpatch HOST [BRANCH]"
    return 1
  fi
  host="$1"

  if [ -n "$2" ]; then
    branch="$2"
  else
    branch=`ssh $host "cd chromium; git symbolic-ref HEAD"`
    branch="${branch##refs/heads/}"
  fi

  version=`ssh $host "cd chromium; git merge-base $branch origin/trunk"`
  crup $version

  echo; echo "Patching changes from $branch..."
  ssh $host "cd chromium; git diff $version" | patch -p1
  echo; echo "Done."
}

crsync() {
  if [ -z "$1" ]; then
    echo "Usage: crpatch HOST"
    return 1
  fi
  host="$1"

  old_dir=$PWD
  for dir in chrome net; do
    cdc
    cd $dir
    rsync -avzC \
      --include '*.cc' \
      --include '*.cpp' \
      --include '*.gyp' \
      --include '*.gypi' \
      --include '*.h' \
      --include '*.html' \
      --include '*.js' \
      --include '*.proto' \
      --include '*.py' \
      $host:chromium/$dir/ .
  done
  cd $old_dir
}

po() {
  old_dir=`pwd`
  if [ -d "$1" ]; then
    cd "$1"
  elif [ -f "$1" ]; then
    cd `dirname "$1"`
  else
    echo "Couldn't find file or directory $1"
    return 1
  fi

  print_owners() {
    if [ -f OWNERS ]; then
      echo "=== `pwd`"
      cat OWNERS
      echo
    fi
  }

  while [ `pwd` != "$old_dir" -a `pwd` != / ]; do
    print_owners
    cd ..
  done
  print_owners

  unset print_owners
  cd "$old_dir"
}
