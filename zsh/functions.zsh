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

function movie_to_central() {
  FILE=$(basename $1)
  rsync -avP $1 central@192.168.0.101:/Data/Public/Movies
  ssh central@192.168.0.101 'sudo chmod -R 0777 /Data/Public/Movies/$FILE'
}

function update_zsh_plugins () {
  antibody bundle < $DOTFILES/zsh/plugins.txt > $DOTFILES/zsh/plugins.zsh
}

function rebuild_alacritty () {
  cd ~/Git/alacritty
  cargo build --release
  make app
  cp -r target/release/osx/Alacritty.app /Applications/Alacritty.app
}
