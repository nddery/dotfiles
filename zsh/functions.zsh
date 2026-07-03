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

# --- git worktree helpers ---------------------------------------------------

# Resolve a repo argument to the main working tree root of its git repository.
# Accepts a path or a zoxide-known name; empty means the current directory.
# Prints the root path (the caller checks for empty).
function _wt_repo_root () {
  local arg="$1" cand
  if [[ -z "$arg" ]]; then
    cand="$PWD"
  elif [[ -d "$arg" ]]; then
    cand="$arg"
  else
    cand=$(zoxide query -- "$arg" 2>/dev/null)
  fi
  [[ -n "$cand" ]] || return 1
  # the first `git worktree list` entry is always the main working tree
  git -C "$cand" worktree list --porcelain 2>/dev/null | awk '/^worktree /{print substr($0,10); exit}'
}

# Provision a freshly-created worktree the way `claude --worktree` does: symlink
# large shared dirs (node_modules) from the main checkout, and copy the local /
# gitignored files listed in .worktreeinclude (e.g. .env) into it.
function _wt_provision () {
  local root="$1" dir="$2" d f n=0
  local -a link_dirs=(node_modules)

  for d in $link_dirs; do
    if [[ -e "$root/$d" && ! -e "$dir/$d" ]]; then
      ln -s "$root/$d" "$dir/$d" && print "wt: symlinked $d"
    fi
  done

  if [[ -f "$root/.worktreeinclude" ]]; then
    # untracked files matching .worktreeinclude patterns (tracked files aren't
    # listed, so they're never duplicated). Copy only the ones that are also
    # gitignored — like Claude — so provisioned files never show as untracked
    # and don't block `wtrm`'s safe removal later.
    while IFS= read -r f; do
      [[ -z "$f" ]] && continue
      git -C "$root" check-ignore -q -- "$f" || continue
      mkdir -p "$dir/$(dirname "$f")"
      cp -p "$root/$f" "$dir/$f" && (( n++ ))
    done < <(git -C "$root" ls-files --others --ignored --exclude-from="$root/.worktreeinclude")
    (( n )) && print "wt: copied $n file(s) from .worktreeinclude"
  fi
}

# Create a git worktree for a repo and open a sesh session in it — no Claude.
#
# The worktree goes in a sibling <repo>.worktrees/<branch> directory (outside the
# repo, so it never shows as untracked). Freshly-created worktrees are provisioned
# like `claude --worktree`: node_modules is symlinked and .worktreeinclude files
# are copied. It's a plain git worktree, so you can still `cd` in and run claude.
#
# Usage: wt [<repo>] <branch> [base-ref]
#   <repo>      Path or zoxide-known name of the repo. Omit to use the current
#               repo; pass "." explicitly when you also need [base-ref].
#   <branch>    Branch to work on — checked out if it already exists (locally or
#               on origin), otherwise created new.
#   [base-ref]  What a NEW branch starts from (default: freshly-fetched origin/HEAD).
function wt () {
  local repo branch base root dir created=0
  case $# in
    1) branch="$1" ;;
    2) repo="$1"; branch="$2" ;;
    3) repo="$1"; branch="$2"; base="$3" ;;
    *) print -u2 "usage: wt [<repo>] <branch> [base-ref]"; return 1 ;;
  esac
  if [[ -z "$branch" ]]; then
    print -u2 "usage: wt [<repo>] <branch> [base-ref]"
    return 1
  fi

  root=$(_wt_repo_root "$repo")
  if [[ -z "$root" ]]; then
    print -u2 "wt: can't resolve a git repo from '${repo:-$PWD}'"
    return 1
  fi

  dir="${root}.worktrees/${branch}"

  if [[ -d "$dir" ]]; then
    print "wt: worktree already exists → $dir"
  elif git -C "$root" show-ref --quiet --verify "refs/heads/$branch"; then
    git -C "$root" worktree add "$dir" "$branch" || return 1                              # existing local branch
    created=1
  elif git -C "$root" show-ref --quiet --verify "refs/remotes/origin/$branch"; then
    git -C "$root" worktree add --track -b "$branch" "$dir" "origin/$branch" || return 1  # existing remote branch
    created=1
  else
    if [[ -z "$base" ]]; then                                                             # new branch off a fresh default branch
      base=$(git -C "$root" symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null) || base="origin/main"
      git -C "$root" fetch --quiet origin "${base#origin/}" 2>/dev/null
    fi
    git -C "$root" worktree add -b "$branch" --no-track "$dir" "$base" || return 1
    created=1
  fi

  (( created )) && _wt_provision "$root" "$dir"
  sesh connect "$dir"                                                                     # open a shell there — no Claude
}

# Remove a worktree created by wt and delete its branch — the cleanup half of
# the workflow. Safe by default: git refuses if the worktree is dirty or the
# branch is unmerged. Pass -f to force both. Runs from anywhere.
#
# Usage: wtrm [<repo>] <branch> [-f]
function wtrm () {
  local force=0 a root dir repo branch
  local -a pos
  for a in "$@"; do
    if [[ "$a" == "-f" ]]; then force=1; else pos+=("$a"); fi
  done
  case ${#pos} in
    1) branch="$pos[1]" ;;
    2) repo="$pos[1]"; branch="$pos[2]" ;;
    *) print -u2 "usage: wtrm [<repo>] <branch> [-f]"; return 1 ;;
  esac

  root=$(_wt_repo_root "$repo")
  [[ -n "$root" ]] || { print -u2 "wtrm: can't resolve a git repo from '${repo:-$PWD}'"; return 1; }

  # locate the worktree registered for this branch (robust to naming/spaces)
  dir=$(git -C "$root" worktree list --porcelain | awk -v b="refs/heads/$branch" '
    /^worktree /{p=substr($0,10)} /^branch /{if($2==b){print p; exit}}')
  [[ -n "$dir" ]] || { print -u2 "wtrm: no worktree found for branch '$branch'"; return 1; }

  # if we're standing inside it, step back to the main worktree first
  case "$PWD/" in "$dir"/*) cd "$root" ;; esac

  if (( force )); then
    git -C "$root" worktree remove --force "$dir" && git -C "$root" branch -D "$branch"
  else
    git -C "$root" worktree remove "$dir" && git -C "$root" branch -d "$branch"
  fi
}
