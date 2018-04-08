#!/usr/bin/env bash

source utils.sh

main() {
  # Change shell to zsh if not already like so
  if [ $(echo $SHELL) != '/bin/zsh' ]
  then
    execute "chsh -s /bin/zsh" "Changed login shell to Zsh"
  fi

  print_result $? 'Shell changed '
}

main
