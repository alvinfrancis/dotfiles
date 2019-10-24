PS1="\[\033[35m\]\t\[\033[m\]-\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]:\$(parse_git_branch)\$ "

PATH=/opt/local/lib/postgresql94/bin:/opt/local/bin:/opt/local/sbin:$PATH
PATH=$PATH:~/Scripts
PATH=$PATH:~/Scripts
PATH=$PATH:~/bin
PATH=$PATH:~/bin/play-2.2.0
PATH=$PATH:~/Github/fuzzyterm/
PATH=$PATH:~/bin/gradle-1.6/bin
PATH=$PATH:~/bin/android-sdk-macosx/tools
PATH=$PATH:~/bin/android-sdk-macosx/platform-tools
PATH=$PATH:~/bin/clojurescript/bin

export BOOT_JVM_OPTIONS="-XX:MaxPermSize=128m -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled"
export HISTFILESIZE=999999
shopt -s histappend

export PATH
export EDITOR=vim
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
if [[ $- == *i* ]]; then
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
fi


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

# Temp
alias fuzzy='/Users/alvin/Github/fuzzyterm/fuzzyterm'
alias fvim='fuzzy -c vim'
alias gitd='git branch -r | awk '"'"'{print $1}'"'"' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '"'"'{print $1}'"'"''

function fcd {
   fcdpipe=/tmp/fcdfifo
   # create a named pipe
   if [[ ! -p $fcdpipe ]]; then
      mkfifo $fcdpipe
   fi

   # echo selection to named pipe
   # (process must be backgrounded or it will block)
   fuzzyterm --background --output $fcdpipe

   # check fuzzyterm exit code
   if [[ $? -ne 0 ]]; then
      rm $fcdpipe
   else
      # cd using the selection piped into the named pipe
      read directory <$fcdpipe
      cd "$directory"
   fi
}

function youdl {
   youtube-dl --max-quality mp4 $1 && terminal-notifier -message "Finished downloading youtube video"
}

function youdl_min {
   youtube-dl --format mp4 $1 && terminal-notifier -message "Finished downloading youtube video"
}

function with_notify {
   $@ && terminal-notifier -message "$1 success" || terminal-notifier -message "$1 fail"
}

alias notify=terminal-notifier
source /etc/bash_completion.d/password-store

function pman {
   man -t $* | ps2pdf - - | open -f -a /Applications/Preview.app
}
