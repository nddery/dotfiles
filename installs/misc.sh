#!/usr/bin/env bash

source utils.sh

main() {
  # vim-plug, for vim
  if [ ! -f ~/.vim/autoload/plug.vim ]
  then
    execute "curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  fi

  # vim-plug, for neovim
  if [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]
  then
    execute "curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  fi

  if [ ! -f ~/Library/Fonts/Cascadia.ttf ]
  then
    curl -o ~/Library/Fonts/Cascadia.ttf https://github.com/microsoft/cascadia-code/releases/latest/download/Cascadia.ttf
  fi
}

main
