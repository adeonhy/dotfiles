##=============================
## UNIX command setting
##=============================
# less setting 
# http://qiita.com/delphinus/items/b04752bb5b64e6cc4ea9
export LESS='-g -i -M -R -S -W -z-4 -x4'

##=============================
## rbenv
##=============================
if [ -d ${HOME}/.rbenv  ] ; then
  PATH=${HOME}/.rbenv/shims:${PATH}
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
## nodebrew
##=============================
export PATH=$HOME/.nodebrew/current/bin:$PATH

##=============================
## java8
##=============================
test -x /usr/libexec/java_home && JAVA8_HOME=`/usr/libexec/java_home -v "1.8" -F`
if [ $? -eq 0 ]; then
  export JAVA8_HOME
fi

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
## MacVim
##=============================
vim=/Applications/MacVim.app/Contents/MacOS/Vim
view=/Applications/MacVim.app/Contents/MacOS/view
if [ -x $vim ]; then
  alias vi=$vim
  alias vim=$vim
  alias view=$view
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

##=============================
## added by Anaconda3 4.2.0 installer
##=============================
export PATH="/Users/hy/anaconda3/bin:$PATH"
