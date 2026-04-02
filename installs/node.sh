#!/usr/bin/env bash

source utils.sh

main() {
  if ! cmd_exists 'node'; then
    # Installs `n`, which in turn installs node latest version.
    # https://github.com/mklement0/n-install
    curl -L https://bit.ly/n-install | bash
  fi

  print_result $? 'Node'
}

main
