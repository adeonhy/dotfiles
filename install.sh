#!/bin/bash
set -e -o pipefail

function link() {
  dir=$(cd $(dirname $0);pwd)
  link_from=$dir/$1
  if [ -z $2 ]; then
    link_to=$HOME/$1
  else
    link_to=$HOME/$2
  fi

  if [ -e $link_to ]; then
    echo $link_to exists.
  else
    ln -s $link_from $link_to
    echo $link_from '->' $link_to
  fi
}

## zsh
link .zshrc
link .zshenv
link zsh .zsh

## vim
link vim/.vimrc .vimrc
link vim/.gvimrc .gvimrc
link vim .vim
link vim/.dein.toml .dein.toml
link vim/.dein_lazy.toml .dein_lazy.toml

## git
link .git
link .gitconfig
link .gitignore

## others
link .peco
link .tigrc
link .tmux.conf.arch .tmux.conf
link .xremap

