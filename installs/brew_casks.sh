#!/usr/bin/env bash

source utils.sh

# package:options
declare -a PACKAGES=(
  'firefox'
  'google-chrome'

  'alacritty'
  'spotify'
  'vlc'

  'qlcolorcode'
  'qlimagesize'
  'qlmarkdown'
  'qlprettypatch'
  'qlstephen'
  'quicklook-csv'
  'quicklook-json'

  'font-cascadia-code'
)

main() {
  local i=''
  local -a parts=()
  local package=''

  # Install casks in /Application instead of ~/Applications
  export HOMEBREW_CASK_OPTS="--appdir=/Applications"

  execute "brew update --all" "Updated Homebrew"
  execute "brew upgrade `brew outdated`" "Upgraded outdated packages"
  execute "brew tap homebrew/cask-fonts"

  for i in ${PACKAGES[@]}; do
    parts=(${i//:/ })
    package="${parts[0]}"

    if [ ${#parts[@]} -gt 1 ]; then
      package="$package ${parts[1]}"
    fi

    brew_install "${parts[0]}" "${package}" "cask"
  done

  execute "brew cask cleanup" "Removed outdated versions from the cellar"
}

main
