#!/usr/bin/env bash

source utils.sh

main() {
  if ! cmd_exists 'brew'; then
    printf "\n" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    #  └─ simulate the ENTER keypress
  fi

  print_result $? 'Homebrew'
}

main
