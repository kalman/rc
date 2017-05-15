#!/bin/bash

#
# Undo stuff before sourcing anything
#

for a in l ll la; do
  if alias -p | grep $a &>/dev/null; then
    unalias $a &>/dev/null
  fi
done

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

# Blue is 34m, green is 32m, red is 31m. They used to be 01;3Xm, I can't remember what 01; is for.
export PS1='\[\033[34m\]\w \[\033[31m\]$(__git_ps1 "(%s)")\n\[\033[01;32m\]> \[\033[00m\]'

export EDITOR="vim"
export SVN_LOG_EDITOR="$EDITOR"

export PATH="$HOME/local/bin:$PATH"
export PATH="$HOME/local/rc_scripts:$PATH"
export PATH="$HOME/local/depot_tools:$PATH"
export PATH="$HOME/local/npm-global/bin:$PATH"
export PATH="$HOME/goma:$PATH"
export PATH="/usr/bin:$PATH"
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

#
# General
#

fn()      { find . -name "$@"; }
c()       { cd -P "$@"; }
ll()      { l -l "$@"; }
la()      { l -A "$@"; }
lla()     { l -lA "$@"; }
v()       { vim -p "$@"; }
e()       { vim -p $(echo $@ | sed 's/:/ +/'); }
wg()      { wget --no-check-certificate -O- "$@"; }
grr()     { grep -rn --color --exclude='.svn' "$@"; }
s()       { screen -DR "$@"; }
prepend() { sed "s|^|$1" "$@"; }
sx()      { ssh -Y "$@"; }

vl() {
  file=`echo "$1" | cut -d: -f1`
  line=`echo "$1" | cut -d: -f2`
  v "$file" +"$line"
}

#
# Android
#

export ANDROID_HOME="${HOME}/Library/Android/sdk"
export PATH="${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools"

#
# Go
#

export GOPATH="$HOME/src/go"
export NOMS_VERSION_NEXT=1

cdg() {
  c "$GOPATH/src"
}

#
# Git
#

source "$HOME/.rc/git_completion"

complete -o default -o nospace -F _git_branch changed
complete -o default -o nospace -F _git_branch cherry-pick
complete -o default -o nospace -F _git_branch gb
complete -o default -o nospace -F _git_branch gcb
complete -o default -o nospace -F _git_branch ghide
complete -o default -o nospace -F _git_checkout gch
complete -o default -o nospace -F _git_checkout gchr
complete -o default -o nospace -F _git_diff gd
complete -o default -o nospace -F _git_diff gdt
complete -o default -o nospace -F _git_diff gdns
complete -o default -o nospace -F _git_diff gds
complete -o default -o nospace -F _git_merge_base gmb
complete -o default -o nospace -F _git_log gl
complete -o default -o nospace -F _git_rebase gr

g()    { git "$@"; }
ga()   { git add "$@"; }
gb()   { git branch "$@"; }
gbD()  {
  read -p 'Are you sure? [y/N] ' -n1 READ;
  if [ "$READ" == 'y' ]; then git branch -D "$@"; fi
}
gc()   { git commit "$@"; }
gcaa() { gc -a --amend; }
gch()  { git checkout "$@"; }
gcp()  { git cherry-pick "$@"; }
gd()   { git diff "$@"; }
gdns() { git diff --name-status "$@"; }
gds()  { git diff --stat "$@"; }
gdt()  { git difftool "$@"; }
gg()   { git grep "$@"; }
gl()   { git log "$@"; }
gls()  { git ls-files "$@"; }
gm()   { git merge "$@"; }
gmb()  { git merge-base "$@"; }
gnb()  { git new-branch "$@"; }
gp()   { git pull "$@"; }
gr()   { git rebase "$@"; }
gs()   { git status "$@"; }

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
  gmb `gcb` master
}

gtry() {
  g cl try
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

gclean() {
  current_date=`date +%F | tr -d -`
  for branch in `git branch | grep -E '__[0-9-]+__'`; do
    branch_date=`echo "$branch" | grep -Eo '__[0-9-]+__' | tr -d _-`
    if [ $branch_date -lt $(( $current_date - 100 )) ]; then
      read -N 1 -p "Delete $branch [N/y] "
      echo
      if [ "$REPLY" = y ]; then
        git branch -D "$branch"
        echo
      fi
    fi
  done

  read -N 1 -p "Run \"git gc\" [N/y] "
  echo
  if [ "$REPLY" = y ]; then
    git gc
  fi
}

changed() {
  base="$1"
  if [ -z "$base" ]; then
    base=`gbase`
  fi
  gdns "$base" | cut -f2
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

gf() {
  gls "*/$1"
}

greplace() {
  from="$1"
  to="$2"

  shift 2

  for f in `gg -l "$@" "$from"`; do
    echo "Replacing in $f"
    sedi $SED_I_SUFFIX "s%$from%$to%g" "$f"
  done
}

gclu() {
  g cl upload `gbase` "$@"
}

gh() {
  git for-each-ref --sort=committerdate refs/heads --format='%(refname:short)'
}

jsonp() {
  python -m json.tool
}
