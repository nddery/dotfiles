function change_color_scheme () {
  sed \
    --in-place \
    --follow-symlinks \
    '/colors:\ \*/c\colors:\ \*'$1 \
    $HOME/.config/alacritty/alacritty.yml
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

function rebuild_alacritty () {
  cd ~/Git/alacritty
  git pull origin master
  cargo build --release
  make app
  cp -r target/release/osx/Alacritty.app /Applications/Alacritty.app
}

function play_on_roku () {
  curl \
    -X POST -G "http://192.168.0.105:8060/input/15985" \
    --data-urlencode "t=v" \
    --data-urlencode "u=$1"
}
