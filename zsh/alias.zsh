alias vimenc="vim -u ~/.vimrc.encrypted -x"
alias rmds="find . -name '*.DS_Store' -type f -delete"

alias ctags="`brew --prefix`/bin/ctags"
alias mkdir='mkdir -p'
alias tmux="TERM=screen-256color-bce tmux"

alias la='ls -la'
alias ll='ls -l'

alias gti='git'
alias gs='git status'
alias gc='git commit'
alias ga='git add'
alias gb='git branch'
alias gch='git checkout'
alias gl='git log --pretty=format:"%C(yellow)%h %C(blue)%ad%C(red)%d %C(reset)%s%C(green) [%an]" --decorate --date=short'
alias yesterday="git log --since '1 day ago' --oneline --author nddery@gmail.com"

alias xcw="open -a "Xcode" *.xcworkspace"
