function change_color_scheme () {
  local mode="$1"
  local vsCodeColorTheme
  case "$mode" in
    light) vsCodeColorTheme="GitHub Light" ;;
    *)     vsCodeColorTheme="Night Owl" ;;
  esac

  # gsed edit-in-place on a symlinked config file: replace <regex> in <file>.
  local edit=(gsed -i --follow-symlinks)

  $edit "s|config-file = themes/.*|config-file = themes/$mode|" \
    "$HOME/.config/ghostty/config"

  # Ghostty has no live config reload, so nudge it via its reload_config keybind
  # (default ⌘⇧,), but only when we're actually inside Ghostty. Needs Ghostty to
  # have macOS Accessibility permission the first time (System Settings prompt).
  if [[ "$TERM_PROGRAM" == "ghostty" ]] && command -v osascript >/dev/null; then
    osascript -e 'tell application "System Events" to keystroke "," using {command down, shift down}' 2>/dev/null
  fi

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
# every node_modules from the main checkout (at all levels — monorepo package
# node_modules too), and copy the local / gitignored files listed in
# .worktreeinclude (e.g. .env) into it.
function _wt_provision () {
  local root="$1" dir="$2" nm rel f n=0 m=0

  # Symlink every node_modules in the main checkout to its counterpart in the
  # worktree. -prune stops the scan descending INTO a node_modules, so nested
  # store paths (node_modules/.pnpm/**/node_modules) are never returned and the
  # scan stays bounded by the source tree. Whole-dir symlinks are correct for
  # pnpm workspaces: a package's relative links resolve from the real location.
  while IFS= read -r nm; do
    rel="${nm#$root/}"
    [[ -e "$dir/$rel" ]] && continue
    mkdir -p "$dir/${rel:h}"
    ln -s "$root/$rel" "$dir/$rel" && (( m++ ))
  done < <(find "$root" -type d -name node_modules -prune)
  (( m )) && print "wt: symlinked $m node_modules dir(s)"

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

# True when $1 (a worktree dir) is a node project we can auto-install: it has a
# package.json AND a recognized lockfile. The lockfile requirement is deliberate
# — `ni` with no lockfile can prompt for which package manager to use, which
# would hang a non-interactive background job.
function _wt_deps_ready () {
  local dir="$1" lf
  [[ -f "$dir/package.json" ]] || return 1
  for lf in pnpm-lock.yaml package-lock.json yarn.lock bun.lockb; do
    [[ -f "$dir/$lf" ]] && return 0
  done
  return 1
}

# Background worker: install deps in the worktree, then post a tmux status
# message to the worktree's sesh session. The session is resolved by path at
# completion (the same match sesh-picker/wtrm use), so it works even though the
# session may not exist yet when the job is launched; if none is found the
# message goes to the active client instead. Runs synchronously — the caller
# backgrounds it.
function _wt_install_worker () {
  local dir="$1" branch="$2" log="$3" msg dur sess
  if (cd "$dir" && ni) >"$log" 2>&1; then
    msg="wt: ✓ deps ready — $branch"; dur=4000
  else
    msg="wt: ✗ ni failed — $branch — see $log"; dur=6000
  fi
  sess=$(sesh list -t -j 2>/dev/null | jq -r --arg p "$dir" '.[] | select(.Path==$p) | .Name' 2>/dev/null)
  if [[ -n "$sess" ]]; then
    tmux display-message -d "$dur" -t "$sess" "$msg" 2>/dev/null
  else
    tmux display-message -d "$dur" "$msg" 2>/dev/null
  fi
}

# Create a git worktree for a repo and open a sesh session in it — no Claude.
#
# The worktree goes in a sibling <repo>.worktrees/<branch> directory (outside the
# repo, so it never shows as untracked). Freshly-created worktrees are provisioned
# like `claude --worktree`: every node_modules (all levels, incl. monorepo package
# node_modules) is symlinked and .worktreeinclude files are copied. It's a plain
# git worktree, so you can still `cd` in and run claude.
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

  # always sync with origin first: remote branches (incl. ones pushed since our last
  # fetch) become discoverable and up to date, and the default branch is fresh for new
  # branches. No-op when offline — the checks below just fall back to whatever's local.
  git -C "$root" fetch --quiet origin 2>/dev/null

  if [[ -d "$dir" ]]; then
    print "wt: worktree already exists → $dir"
  elif git -C "$root" show-ref --quiet --verify "refs/heads/$branch"; then
    git -C "$root" worktree add "$dir" "$branch" || return 1                              # existing local branch
    created=1
  elif git -C "$root" show-ref --quiet --verify "refs/remotes/origin/$branch"; then
    git -C "$root" worktree add --track -b "$branch" "$dir" "origin/$branch" || return 1  # branch on origin
    created=1
  else
    [[ -n "$base" ]] || base=$(git -C "$root" symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null) || base="origin/main"
    git -C "$root" worktree add -b "$branch" --no-track "$dir" "$base" || return 1        # brand-new branch off origin default
    created=1
  fi

  (( created )) && _wt_provision "$root" "$dir"
  sesh connect "$dir"                                                                     # open a shell there — no Claude
}

# Remove a worktree created by wt, delete its branch, and close the sesh session
# it opened — the cleanup half of the workflow. Safe by default: git refuses if
# the worktree is dirty or the branch is unmerged. Pass -f to force both. Runs
# from anywhere; with no <branch> it removes the worktree you're standing in.
#
# Usage: wtrm [<repo>] [<branch>] [-f]
function wtrm () {
  local force=0 a root dir repo branch sesh_name
  local -a pos
  for a in "$@"; do
    if [[ "$a" == "-f" ]]; then force=1; else pos+=("$a"); fi
  done
  case ${#pos} in
    0) branch=$(git symbolic-ref --short -q HEAD) \
         || { print -u2 "wtrm: not on a branch here — name one: wtrm <branch>"; return 1; } ;;
    1) branch="$pos[1]" ;;
    2) repo="$pos[1]"; branch="$pos[2]" ;;
    *) print -u2 "usage: wtrm [<repo>] [<branch>] [-f]"; return 1 ;;
  esac

  root=$(_wt_repo_root "$repo")
  [[ -n "$root" ]] || { print -u2 "wtrm: can't resolve a git repo from '${repo:-$PWD}'"; return 1; }

  # locate the worktree registered for this branch (robust to naming/spaces)
  dir=$(git -C "$root" worktree list --porcelain | awk -v b="refs/heads/$branch" '
    /^worktree /{p=substr($0,10)} /^branch /{if($2==b){print p; exit}}')
  [[ -n "$dir" ]] || { print -u2 "wtrm: no worktree found for branch '$branch'"; return 1; }
  [[ "$dir" != "$root" ]] || { print -u2 "wtrm: '$branch' is the main working tree — refusing to remove it"; return 1; }

  # find the tmux session sesh opened here (match by path, like sesh-picker)
  # before its directory disappears from under it
  if command -v jq >/dev/null 2>&1; then
    sesh_name=$(sesh list -t -j 2>/dev/null | jq -r --arg p "$dir" '.[] | select(.Path==$p) | .Name' 2>/dev/null)
  fi

  # if we're standing inside it, step back to the main worktree first
  case "$PWD/" in "$dir"/*) cd "$root" ;; esac

  local rc=0
  if (( force )); then
    git -C "$root" worktree remove --force "$dir" || return 1
    git -C "$root" branch -D "$branch" || rc=$?
  else
    git -C "$root" worktree remove "$dir" || return 1
    git -C "$root" branch -d "$branch" || rc=$?   # keeps the "unmerged" refusal visible
  fi

  # close its sesh session last: killing it ends this shell if we ran from
  # inside, and detach-on-destroy=off (tmux.conf) hops the client to another
  # session — so wtrm doubles as "leave the worktree" in that case.
  if [[ -n "$sesh_name" ]]; then
    tmux kill-session -t "$sesh_name" 2>/dev/null
  fi
  return $rc
}
