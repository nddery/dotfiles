function change_color_scheme () {
  local mode="$1"
  local vsCodeColorTheme
  case "$mode" in
    light) vsCodeColorTheme="GitHub Light" ;;
    *)     vsCodeColorTheme="Night Owl" ;;
  esac

  # gsed edit-in-place on a symlinked config file: replace <regex> in <file>.
  local edit=(gsed -i --follow-symlinks)

  $edit "s|colors/.*\.toml|colors/$mode.toml|" \
    "$HOME/.config/alacritty/alacritty.toml"

  $edit "s/vim.opt.background = \".*\"/vim.opt.background = \"$mode\"/" \
    "$HOME/.config/nvim/lua/nddery/plugins/colorscheme.lua"

  $edit "s/\"workbench.colorTheme\": \".*\"/\"workbench.colorTheme\": \"$vsCodeColorTheme\"/" \
    "$HOME/Library/Application Support/Code - Insiders/User/settings.json"
}

function clean_vim_directories() {
  rm -rf ~/.vimbackup/*
  rm -rf ~/.vimswap/*
  rm -rf ~/.vimviews/*
  rm -rf ~/.vimundo/*
}

function update_zsh_plugins () {
  antidote update
}

function play_on_roku () {
  curl \
    -X POST -G "http://192.168.0.12:8060/input/15985" \
    --data-urlencode "t=v" \
    --data-urlencode "u=$1"
}

function reset_logi_mx () {
  PID=`ps aux | grep -i 'MacOS/logioptionsplus_agent' | grep 'launchd' | awk '{print $2}'`
  kill -9 $PID
}

# Create a git worktree for the current repo and open a sesh session in it.
#
# Lays the worktree out the way `claude --worktree` does — a sibling
# <repo>.worktrees/<branch> directory — but never launches Claude. It just drops
# you into a shell there (switching the tmux client if you're already inside
# one). The worktree is a plain git worktree, so `claude` still picks it up if
# you later run it in that directory.
#
# Usage: wt <branch> [base-ref]
#   <branch>    Branch to work on. Checked out into the worktree if it already
#               exists (locally or on origin); otherwise created new.
#   [base-ref]  What a NEW branch starts from. Defaults to a freshly-fetched
#               remote default branch (origin/HEAD), matching `claude --worktree`.
function wt () {
  local branch="$1" base="$2"
  if [[ -z "$branch" ]]; then
    print -u2 "usage: wt <branch> [base-ref]"
    return 1
  fi

  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null) || {
    print -u2 "wt: not inside a git repository"
    return 1
  }

  local dir="${root}.worktrees/${branch}"

  if [[ -d "$dir" ]]; then
    print "wt: worktree already exists → $dir"
  elif git show-ref --quiet --verify "refs/heads/$branch"; then
    git worktree add "$dir" "$branch" || return 1          # existing local branch
  elif git show-ref --quiet --verify "refs/remotes/origin/$branch"; then
    git worktree add --track -b "$branch" "$dir" "origin/$branch" || return 1  # existing remote branch
  else
    if [[ -z "$base" ]]; then                              # new branch off a fresh default branch
      base=$(git symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null) || base="origin/main"
      git fetch --quiet origin "${base#origin/}" 2>/dev/null
    fi
    git worktree add -b "$branch" --no-track "$dir" "$base" || return 1
  fi

  sesh connect "$dir"                                       # open a shell there — no Claude
}

# Remove a worktree created by wt and delete its branch — the cleanup half of
# the workflow (`claude --worktree` does this automatically on a clean exit).
# Safe by default: git refuses if the worktree is dirty or the branch is
# unmerged. Pass -f to force both.
#
# Usage: wtrm <branch> [-f]
function wtrm () {
  local branch="$1" force="$2"
  if [[ -z "$branch" ]]; then
    print -u2 "usage: wtrm <branch> [-f]"
    return 1
  fi
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
    print -u2 "wtrm: not inside a git repository"
    return 1
  }

  # locate the worktree registered for this branch (robust to naming/spaces)
  local dir
  dir=$(git worktree list --porcelain | awk -v b="refs/heads/$branch" '
    /^worktree /{p=substr($0,10)} /^branch /{if($2==b){print p; exit}}')
  if [[ -z "$dir" ]]; then
    print -u2 "wtrm: no worktree found for branch '$branch'"
    return 1
  fi

  # if we're standing inside it, step back to the main worktree first
  local main
  main=$(git worktree list --porcelain | awk '/^worktree /{print substr($0,10); exit}')
  case "$PWD/" in "$dir"/*) cd "$main" ;; esac

  if [[ "$force" == "-f" ]]; then
    git worktree remove --force "$dir" && git branch -D "$branch"
  else
    git worktree remove "$dir" && git branch -d "$branch"
  fi
}
