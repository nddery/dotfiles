#!/usr/bin/env bash

source utils.sh

main() {
  execute "brew update" "Updated Homebrew"
  execute "brew bundle --file=installs/Brewfile" "Installed packages from Brewfile"
  execute "brew upgrade" "Upgraded outdated packages"
  execute "brew cleanup" "Removed outdated versions"
}

main
