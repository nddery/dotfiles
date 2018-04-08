#!/usr/bin/env bash
# Heavily inspired by https://github.com/alrra/dotfiles

source 'utils.sh'

ask_for_sudo

###

ask_for_confirmation 'Install/Update Xcode ?'
printf '\n'

if answer_is_yes; then
  print_info 'Install/Update Xcode'
  ./installs/xcode.sh
  print_in_green '\n  ---\n\n'
fi

###

ask_for_confirmation 'Install/Update homebrew ?'
printf '\n'

if answer_is_yes; then
  print_info 'Install/Update homebrew'
  ./installs/homebrew.sh
  print_in_green '\n  ---\n\n'
fi

###

ask_for_confirmation 'Install/Update node ?'
printf '\n'

if answer_is_yes; then
  print_info 'Install/Update node'
  ./installs/node.sh
  print_in_green '\n  ---\n\n'
fi

###

ask_for_confirmation 'Install/Update brew packages ?'
printf '\n'

if answer_is_yes; then
  print_info 'Install/Update brew packages'
  ./installs/brew_packages.sh
  print_in_green '\n  ---\n\n'
fi

###

ask_for_confirmation 'Install/Update brew casks ?'
printf '\n'

if answer_is_yes; then
  print_info 'Install/Update brew casks'
  ./installs/brew_casks.sh
  print_in_green '\n  ---\n\n'
fi

###

ask_for_confirmation 'Install/Update global node modules ?'
printf '\n'

if answer_is_yes; then
  print_info 'Install/Update global node modules'
  ./installs/node_modules.sh
  print_in_green '\n  ---\n\n'
fi

###

ask_for_confirmation 'Install/Update misc (vim-plug, ...) ?'
printf '\n'

if answer_is_yes; then
  print_info 'Install/Update misc'
  ./installs/misc.sh
  print_in_green '\n  ---\n\n'
fi

###

ask_for_confirmation 'Symlink dotfiles into place ?'
printf '\n'

if answer_is_yes; then
  print_info 'Symlink dotfiles into place'
  ./symlinks.sh
  print_in_green '\n  ---\n\n'
fi

###

ask_for_confirmation 'Change shell ?'
printf '\n'

if answer_is_yes; then
  print_info 'Changing shell'
  ./installs/shell.sh
  print_in_green '\n  ---\n\n'
fi

###

print_success "Installation finished"
