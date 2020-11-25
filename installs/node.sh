#!/usr/bin/env bash

source utils.sh

main() {
  if ! cmd_exists 'node'; then
    # Installs `n`, which in turn installs node latest version.
    # https://github.com/tj/n#installation
    curl -L https://git.io/n-install | bash
  fi

  print_result $? 'Node'
}

main
