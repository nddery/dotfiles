#!/usr/bin/env bash
# Heavily inspired by https://github.com/alrra/dotfiles

source 'utils.sh'

ask_for_sudo

# Each step is "prompt label:script to run" (relative to this directory).
declare -a STEPS=(
  'Install/Update Xcode:installs/xcode.sh'
  'Install/Update homebrew:installs/homebrew.sh'
  'Install/Update node:installs/node.sh'
  'Install/Update brew packages & casks:installs/brew_bundle.sh'
  'Install/Update global node modules:installs/node_modules.sh'
  'Symlink dotfiles into place:symlinks.sh'
  'Change shell:installs/shell.sh'
)

for step in "${STEPS[@]}"; do
  label="${step%%:*}"
  script="${step#*:}"

  ask_for_confirmation "$label ?"
  printf '\n'

  if answer_is_yes; then
    print_info "$label"
    "./$script"
    print_in_green '\n  ---\n\n'
  fi
done

print_success "Installation finished"
