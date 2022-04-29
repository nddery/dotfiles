function change_color_scheme () {
  gsed \
    -i \
    --follow-symlinks \
    "s/colors: \*.*/colors: \*$1/" \
    $HOME/.config/alacritty/alacritty.yml

  gsed \
    -i \
    --follow-symlinks \
    "s/let g:initial_color_mode=\".*\"/let g:initial_color_mode=\"$1\"/" \
    $HOME/.vimrc
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

function update_vim_plugins () {
  nvim +PlugUpgrade +PlugUpdate +PlugClean
}

function reset_logi_mx () {
  kill `pgrep LogiMgrDaemon`
}
