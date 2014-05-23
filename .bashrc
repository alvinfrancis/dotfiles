PS1="\[\033[35m\]\t\[\033[m\]-\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]:\$(parse_git_branch)\$ "

PATH=/opt/local/bin:/opt/local/sbin:$PATH
PATH=$PATH:~/Scripts
PATH=$PATH:~/Scripts
PATH=$PATH:~/bin
PATH=$PATH:~/bin/play-2.1.0
export PATH
export EDITOR=/opt/local/bin/vim
export SURFRAW_browser=elinks
export TERM=screen-256color-italic
export MAIL=/Users/alvin/Mail/Inbox && export MAIL
export LANG="C" && export LANG

# TMUX defaults to screen-256color and newsbeuter has an issue with a 256color TERM
alias newsbeuter="TERM=xterm-color newsbeuter"
alias ls="ls -G"
alias qw="surfraw wikipedia"
alias qg="surfraw google"
alias fortunecow="fortune | cowsay"
alias grep="grep --color=auto"
alias vi="vim -u NONE"

# Functions
function parse_git_branch { 
   git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/' 
} 


## Colored output
NORMAL=$(tput sgr0)
GREEN=$(tput setaf 2; tput bold)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)

function red() {
    echo -e "$RED$*$NORMAL"
}
function green() {
    echo -e "$GREEN$*$NORMAL"
}
function yellow() {
    echo -e "$YELLOW$*$NORMAL"
}

# Invoke less termcap to add colored info to bold and underline values of
# termcap
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

