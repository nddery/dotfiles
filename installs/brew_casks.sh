#!/usr/bin/env bash

source utils.sh

# package:options
declare -a PACKAGES=(
  'firefox'
  'google-chrome'

  'alacritty'
  'android-file-transfer'
  'spotify'
  'vlc'
  'dropbox'
  'rowanj-gitx'
  'caffeine'

  'qlcolorcode'
  'qlimagesize'
  'qlmarkdown'
  'qlprettypatch'
  'qlstephen'
  'quicklook-csv'
  'quicklook-json'

  'font-cascadia'
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

  if ! brew info brew-cask &>/dev/null; then
    brew_install "brew-cask" "caskroom/cask/brew-cask"
  else
    print_success "Installed the homebrew-cask tool"
  fi

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
