##=============================
## UNIX command setting
##=============================
# less setting 
# http://qiita.com/delphinus/items/b04752bb5b64e6cc4ea9
export LESS='-g -i -M -R -S -W -z-4 -x4'

##=============================
## go
##=============================
if [ -d ${HOME}/go  ] ; then
  GOPATH=${HOME}/go
  export GOPATH

  PATH=${HOME}/go/bin:${PATH}
  export PATH
fi

##=============================
## rbenv
##=============================
if [ -d ${HOME}/.rbenv  ] ; then
  PATH=${HOME}/.rbenv/bin:${HOME}/.rbenv/shims:${PATH}
  export PATH
  eval "$(rbenv init -)"
fi

##=============================
## rubygems in archlinux
##=============================
case "$(uname)" in
  "Linux")
    GEMPATH="`ruby -e 'print Gem.user_dir'`/bin"
    if [ -d $GEMPATH  ] ; then
      PATH=${GEMPATH}:${PATH}
      export PATH
    fi
    export TERM=xterm-256color
    ;;
esac

##=============================
## NVM
##=============================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

##=============================
## nodebrew
##=============================
export PATH=$HOME/.nodebrew/current/bin:$PATH

##=============================
## java8
##=============================
# test -x /usr/libexec/java_home && JAVA8_HOME=`/usr/libexec/java_home -v "1.8" -F`
# if [ $? -eq 0 ]; then
  # export JAVA8_HOME
# fi

##=============================
## gnu command
##=============================
case "$(uname)" in
  "Darwin")
    PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
    PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    export PATH
    ;;
esac

##=============================
# Add GHC 7.10.2 to the PATH, via https://ghcformacosx.github.io/
##=============================
export GHC_DOT_APP="/Applications/ghc-7.10.2.app"
if [ -d "$GHC_DOT_APP" ]; then
  export PATH="${HOME}/.local/bin:${HOME}/.cabal/bin:${GHC_DOT_APP}/Contents/bin:${PATH}"
fi

##=============================
## conscript (run scala file)
##=============================
export CONSCRIPT_HOME="$HOME/.conscript"
export CONSCRIPT_OPTS="-XX:MaxPermSize=512M -Dfile.encoding=UTF-8"
export PATH=$CONSCRIPT_HOME/bin:$PATH

##=============================
## peco
##=============================
case "$(uname)" in
  "Darwin" | "Linux")
    function peco-select-history() {
      local tac
      if which tac > /dev/null; then
        tac="tac"
      else
        tac="tail -r"
      fi
      BUFFER=$(history -n 1 |uniq | \
        eval $tac | \
        peco --query "$LBUFFER")
      CURSOR=$#BUFFER
      zle clear-screen
    }
    zle -N peco-select-history
    bindkey '^r' peco-select-history
    ;;
  "Linux")
    ##=============================
    ## zsh history
    ## https://github.com/b4b4r07/history
    ##=============================
    # ZSH_HISTORY_FILTER_OPTIONS="--filter-branch --filter-dir"
    ZSH_HISTORY_KEYBIND_GET="^r"
    ZSH_HISTORY_KEYBIND_ARROW_UP="^p"
    ZSH_HISTORY_KEYBIND_ARROW_DOWN="^n"

    #source ~/.zsh/history/init.zsh
    ;;
esac

function peco-z-search
{
  which peco z > /dev/null
  if [ $? -ne 0 ]; then
    echo "Please install peco and z"
    return 1
  fi
  local res=$(z | sort -rn | cut -c 12- | peco)
  if [ -n "$res" ]; then
    BUFFER+="cd $res"
    zle accept-line
  else
    return 1
  fi
}
zle -N peco-z-search
bindkey '^f' peco-z-search

function peco-kill(){
    proc=`ps aux | peco`
    pid=`echo "$proc" | awk '{print $2}'`
    echo "kill pid:$pid. [$proc]"
    kill $pid
}
alias pkill='peco-kill'

##=============================
## ghq/peco
##=============================
alias g='cd $(ghq root)/$(ghq list | peco)'

##=============================
## added by Anaconda3 4.2.0 installer
##=============================
export PATH="/Users/hy/anaconda3/bin:$PATH"

##=============================
## Disable spring(rails)
##=============================
# export DISABLE_SPRING=1

##=============================
## peco on git checkout
## https://qiita.com/ymm1x/items/a735e82244a877ac4d23
##=============================
alias gc='git branch -a --sort=-authordate | cut -b 3- | perl -pe '\''s#^remotes/origin/###'\'' | perl -nlE '\''say if !$c{$_}++'\'' | grep -v -- "->" | peco | xargs git checkout'

alias gph='git push origin HEAD'
alias gphf='git push -f origin HEAD'
alias gp='git pull'

##=============================
## for noin
##=============================
export RAILS_DB_HOST='127.0.0.1'
export RAILS_ES_HOST='127.0.0.1'

##=============================
## for chrome-remote-desktop
##=============================
export CHROME_REMOTE_DESKTOP_DEFAULT_DESKTOP_SIZES='1920x1080'

##=============================
## for Google Cloud SDK
##=============================

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/hy/Library/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/hy/Library/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/hy/Library/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/hy/Library/google-cloud-sdk/completion.zsh.inc'; fi
