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
