autoload -U compinit && compinit
zstyle ':completion:*' menu select=1 _complete _ignored _approximate # highlight current selection
zstyle ':completion:*:functions' ignored-patterns '_*' # ignore completion functions

# npm and pnpm each ship their own completion generator; source them
# dynamically rather than vendoring the generated output (same idiom as
# `fzf --zsh` in zshrc).
command -v npm > /dev/null && source <(npm completion 2> /dev/null)
command -v pnpm > /dev/null && source <(pnpm completion zsh 2> /dev/null)
