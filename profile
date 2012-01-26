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
export PS1='\[\033[01;32m\]# $(__hostname)\[\033[01;34m\] \w \[\033[31m\]$(__git_ps1 "(%s)")\n\[\033[01;32m\]> \[\033[00m\]'

export GOROOT="$HOME/local/go"
export EDITOR="vim"
export SVN_LOG_EDITOR="$EDITOR"

export PATH="$HOME/local/bin:$PATH"
export PATH="$HOME/local/rc_scripts:$PATH"
export PATH="$HOME/local/depot_tools:$PATH"
export PATH="$GOROOT/bin:$PATH"

#
# General
#

fn()      { find . -name "$@"; }
c()       { cd -P "$@"; }
ll()      { l -l "$@"; }
la()      { l -A "$@"; }
lla()     { l -lA "$@"; }
v()       { vim -p "$@"; }
e()       { vim -p "$@"; }
wg()      { wget --no-check-certificate -O- "$@"; }
grr()     { grep -rn --color --exclude='.svn' "$@"; }
s()       { screen -DR "$@"; }
prepend() { sed "s|^|$1" "$@"; }

vl() {
  file=`echo "$1" | cut -d: -f1`
  line=`echo "$1" | cut -d: -f2`
  v "$file" +"$line"
}

#
# Git
#

source "$HOME/.rc/git_completion"

g()    { git "$@"; }
gch()  { git checkout "$@"; }
gb()   { git branch "$@" | grep -v '^  __' | grep -v ' master$'; }
gd()   { git diff "$@"; }
gs()   { git status "$@"; }
gc()   { git commit "$@"; }
gst()  { git status "$@"; }
gl()   { git log "$@"; }
gr()   { git rebase "$@"; }
gp()   { git pull "$@"; }
gls()  { git ls-files "$@"; }
gm()   { git merge "$@"; }
ga()   { git add "$@"; }
gchm() { git checkout master "$@"; }
gdnm() { git diff --numstat master "$@"; }
gdns() { git diff --name-status "$@"; }
gds()  { git diff --stat "$@"; }
glf()  { git ls-files "$@"; }
gmb()  { git merge-base "$@"; }
gg()   { git grep "$@"; }

complete -o default -o nospace -F _git_branch gb
complete -o default -o nospace -F _git_branch ghide
complete -o default -o nospace -F _git_checkout gch
complete -o default -o nospace -F _git_checkout gchr
complete -o default -o nospace -F _git_diff changed
complete -o default -o nospace -F _git_diff gd
complete -o default -o nospace -F _git_diff gdns
complete -o default -o nospace -F _git_diff gds
complete -o default -o nospace -F _git_merge_base gmb
complete -o default -o nospace -F _git_log gl
complete -o default -o nospace -F _git_rebase gr

unmerged() {
  git status -s | grep '^[AUD][AUD] ' | cut -f2 -d' '
}

gC() {
  gc -m `gcb` "$@"
}

gcb() {
  git branch | grep '^*' | cut -f2- -d' '
}

gbase() {
  branch=`gcb`
  gmb $branch origin/trunk
}

gtry() {
  tag=`date +%H:%M`
  revision=`gl | grep src@ | head -n1 | sed -E 's/.*src@([0-9]+).*/\1/g'`
  g try -n "`gcb`-$tag" -r "$revision" "$@"
}

ghide() {
  if [ -z "$1" ]; then
    echo "ERROR: no branch(es) supplied"
    return
  fi
  for branch in "$@"; do
    gb "$branch" -m "__`date +%F`__$branch"
  done
}

changed() {
  base="$1"
  if [ -z "$base" ]; then
    base=`gbase`
  fi
  gdns "$base" | cut -f2
}

gdiff() {
  base="$1"
  if [ -z "$base" ]; then
    base=`gbase`
  fi
  gd "$base"
}

gchr() {
  oldBranch=`gcb`
  branch="$1"
  if [ -z "$branch" ]; then
    echo "ERROR: no branch supplied"
    return
  fi
  gch "$branch"
  gr "$oldBranch"
}

gfind() {
  gls "*/$1"
}

gsquash() {
  g reset `gbase`
  ga chrome
  gC
}

#
# Chromium/WebKit
#

bw()   { build-webkit "$@"; }
rwt()  { run-webkit-tests "$@"; }
nrwt() { new-run-webkit-tests "$@"; }
rl()   { run-launder "$@"; }
pc()   { prepare-ChangeLog --merge-base `git merge-base master HEAD` "$@"; }

lkgr() {
  curl http://chromium-status.appspot.com/lkgr
}

export CRDIR="$HOME/chromium"
cdc() {
  c "${CRDIR}${1}"
}
export WKDIR="$HOME/chromium/third_party/WebKit"
cdw() {
  c "$WKDIR"
}

# For while I work on extension settings.
export s="chrome/browser/extensions/settings"

wkup() {
  git fetch && git svn rebase
  # && update-webkit --chromium
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

crbr() {
  if [ -z "$1" ]; then
    echo "Usage: $0 TESTNAME args..."
    return 1
  fi

  local testname="$1"
  shift

  crclang "$testname" && "b/$testname" "$@"
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

greplace() {
  from="$1"
  to="$2"

  if [ -z "$from" -o -z "$to" ]; then
    echo "greplace from to <args>"
    return 1
  fi

  shift 2

  for f in `gg -l "$@" "$from"`; do
    echo "Replacing in $f"
    sed -i "s/$from/$to/g" "$f"
  done
}
