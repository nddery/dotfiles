# Full compinit (security audit + rebuild dump) at most once a day; otherwise
# load the cached dump and skip the slow audit (compinit -C).
autoload -Uz compinit
zcd=${ZDOTDIR:-$HOME}/.zcompdump
if [[ -f "$zcd" && -z "$(find "$zcd" -mtime +1 2>/dev/null)" ]]; then
  compinit -C -d "$zcd"
else
  compinit -d "$zcd"
fi

zstyle ':completion:*' menu select=1 _complete _ignored _approximate # highlight current selection
zstyle ':completion:*:functions' ignored-patterns '_*' # ignore completion functions

# npm and pnpm ship completion generators, but each spawns Node (~270ms
# combined) on every shell start. Cache the generated output and refresh it
# weekly instead of regenerating it each time.
zcompnode=${ZDOTDIR:-$HOME}/.zcompdump-node.zsh
if [[ ! -f "$zcompnode" || -n "$(find "$zcompnode" -mtime +7 2>/dev/null)" ]]; then
  { command -v npm > /dev/null && npm completion
    command -v pnpm > /dev/null && pnpm completion zsh
  } >| "$zcompnode" 2>/dev/null
fi
source "$zcompnode"

# Socket Firewall (MDM-deployed /etc/zshrc.d/sfw.zsh) aliases pnpm/npm/yarn/etc.
# to `sfw <tool>`. Since COMPLETE_ALIASES is off, zsh expands the alias before
# completing, so `pnpm run <tab>` would complete the command `sfw` (which has no
# completions) and fall back to listing files. Treat sfw as a precommand wrapper
# so the wrapped tool's own completion is used instead.
(( $+commands[sfw] )) && compdef _precommand sfw
