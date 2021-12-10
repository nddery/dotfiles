#!/usr/bin/env bash

source utils.sh

# package:options
declare -a PACKAGES=(
  # GNU core utilities (those that come with OS X are outdated)
  # Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
  'coreutils'
  'moreutils'
  # GNU `find`, `locate`, `updatedb`, `xargs`, and `sed` are `g`-prefixed
  'findutils'
  'gnu-sed'
  'gnupg'

  'ack'
  'fzf'
  'getantibody/tap/antibody'
  'git'
  'gnupg'
  'grc'
  'htop'
  'htop-osx'
  'jq'
  'pinentry-mac'
  'rbenv'
  'the_silver_searcher'
  'tmux'
  'wget:--enable-iri'
  'z'
  'zsh'

  'neovim'
  'vim:--override-system-vi'

  'yarn:--ignore-dependencies'

)

main() {
  local i=''
  local -a parts=()
  local package=''

  execute "brew update --all" "Updated Homebrew"
  execute "brew upgrade `brew outdated`" "Upgraded outdated packages"

  for i in ${PACKAGES[@]}; do
    parts=(${i//:/ })
    package="${parts[0]}"

    if [ ${#parts[@]} -gt 1 ]; then
      package="$package ${parts[1]}"
    fi

    brew_install "${parts[0]}" "${package}"
  done

  execute "brew cleanup" "Removed outdated versions from the cellar"
}

main
