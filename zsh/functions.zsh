function change_color_scheme () {
    # "s/colors: \*.*/colors: \*$1/" \
  gsed \
    -i \
    --follow-symlinks \
    "s/~\/.config\/alacritty\/colors\/\b.*.toml/~\/.config\/alacritty\/colors\/$1.toml/" \
    $HOME/.config/alacritty/alacritty.toml

  gsed \
    -i \
    --follow-symlinks \
    "s/vim.opt.background = \".*\"/vim.opt.background = \"$1\"/" \
    $HOME/.config/nvim/lua/nddery/plugins/colorscheme.lua
}

function clean_vim_directories() {
  rm -rf ~/.vimbackup/*
  rm -rf ~/.vimswap/*
  rm -rf ~/.vimviews/*
  rm -rf ~/.vimundo/*
}

function update_zsh_plugins () {
  antibody update
  antibody bundle < $DOTFILES/zsh/plugins.txt > $DOTFILES/zsh/plugins.zsh
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
