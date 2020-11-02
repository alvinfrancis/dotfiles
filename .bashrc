PS1="\[\033[35m\]\t\[\033[m\]-\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]:\$(parse_git_branch)\$ "
eval "$(starship init bash)"

PATH=$PATH:~/bin
PATH=$PATH:~/go/bin
PATH=$PATH:~/.cargo/bin
PATH=$PATH:~/.local/bin
PATH=$PATH:~/Github/fuzzyterm/

export BOOT_JVM_OPTIONS="-XX:MaxPermSize=128m -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled"
export HISTFILESIZE=999999
shopt -s histappend

export PATH
export EDITOR=vim
export MAIL=/Users/alvin/Mail/Inbox && export MAIL
export LANG=en_US.utf8

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

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    export DISPLAY=localhost:0.0
    # Start the docker machine
    export VBOX_MSI_INSTALL_PATH='/c/Program Files/Oracle/VirtualBox/'
    pushd '/c/Program Files/Docker Toolbox/' > /dev/null
    # ./start.sh exit
    # Get env variables from docker-machine, convert paths, ignore comments, and strip double quotes. 
    $(./docker-machine.exe env --shell bash 2> /dev/null | sed 's/C:/\/c/' | sed 's/\\/\//g' | sed 's:#.*$::g' | sed 's/"//g' ) 
    popd > /dev/null
    # Change /mnt/c/ to /c/ in current working directory path
    cd $(pwd | sed 's/\/mnt\/c\//\/c\//')
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Theming
    # refresh theme colors to match current wallpaper
    function rwal {
        gsettings get org.gnome.desktop.background picture-uri | sed "s;^'file://\(.*\)';\1;" | xargs -I {} wal -i {} -a 80 --backend colorz
    }
    if ! [ -z "$BASH_VERSION" -o -z "$PS1" -o -n "$last_command_started_cache" ]; then
        . /usr/share/undistract-me/long-running.bash
        notify_when_long_running_commands_finish_install
    fi
fi
