autoload -U compinit && compinit
zstyle ':completion:*' menu select=1 _complete _ignored _approximate # highlight current selection
zstyle ':completion:*:functions' ignored-patterns '_*' # ignore completion functions
