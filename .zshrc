if [ -e ~/.profile ] ;then
    source ~/.profile
fi

if [ -e ~/.zshenv ] ;then
    source ~/.zshenv
fi


PROMPT="[%n@%m]%% "
# RPROMPT="`get-branch-name` %~"
SPROMPT="correct: %R -> %r? "

export LANG=ja_JP.UTF-8

autoload -U compinit
compinit

PATH=~/bin:$PATH
# history settings
HISTFILE=~/.zsh_history
HISTSIZE=6000000
SAVEHIST=6000000
setopt hist_ignore_dups
setopt share_history

# other zsh settings
setopt auto_cd
setopt auto_pushd
setopt list_packed
setopt nolistbeep

bindkey -e

# exterminal settings
# autoload predict-on
# predict-on

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
zstyle ':completion:*' list-colors ''

alias gosh="rlwrap -b '(){}[],#\";| ' gosh"
alias rrun="rlwrap -b '(){}[],#\";| ' ros run"

alias gtoa='git opena'
alias gto='git open'

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

case "$(uname)" in
    "Linux")
    ##for GNU ls
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias vi='vim'

    export JAVA_HOME=/usr/lib/jvm/default
    export PATH=$PATH:$JAVA_HOME/bin
    ;;

    "FreeBSD")
    alias ls='ls -G'
    ;;

    "Darwin")
    alias ls='ls -FG'
    alias gvim='open -a MacVim'
    alias fcd='source fcd.sh'
    vim=/Applications/MacVim.app/Contents/MacOS/Vim
    view=/Applications/MacVim.app/Contents/MacOS/view
    if [ -x $vim ]; then
      alias vi=$vim
      alias vim=$vim
      alias view=$view
    fi

    g() {
        open -a 'Google Chrome' http://www.google.co.jp/search\?q=$*
    }
    ;;
    
esac

###########for z#############
_Z_CMD=z

if [ -e ~/.zsh/z.sh ] ;then
    source ~/.zsh/z.sh
fi

precmd() {
      _z --add "$(pwd -P)"
}

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

function tmux-peco {
  which peco z > /dev/null
  if [ $? -ne 0 ]; then
    tmux $@
  fi
  local res=$(tmux ls | peco)
  local session=$(echo $res | cut -f 1 -d :)
  tmux attach -t $session
}
#############################

###########for code_sarch#############
function peco_code_search() {
  ag "$@" . | peco --exec 'awk -F : '"'"'{print "+" $2 " " $1}'"'"' | xargs less -N '
}
zle -N peco_code_search
bindkey '^g' peco_code_search

###########for RPROMPT#############
# vcs_infoロード    
autoload -Uz vcs_info    
# PROMPT変数内で変数参照する    
setopt prompt_subst    
# #
# vcsの表示    
zstyle ':vcs_info:*' formats '%s][* %F{green}%b%f'    
zstyle ':vcs_info:*' actionformats '%s][* %F{green}%b%f(%F{red}%a%f)'    
# プロンプト表示直前にvcs_info呼び出し    
precmd() { vcs_info }    
# プロンプト表示    
RPROMPT='[${vcs_info_msg_0_}]:%~ ' 

#########ログ自動取得 for tmux ########
# https://memo.laughk.org/2014/12/09/tmux-ssh-logging.html
if [[ $TERM = screen ]] || [[ $TERM = screen-256color ]] ; then
  LOGDIR=$HOME/Documents/term_logs
  LOGFILE=$(hostname)_$(date +%Y-%m-%d_%H%M%S_%N.log)
  [ ! -d $LOGDIR ] && mkdir -p $LOGDIR
  tmux  set-option default-terminal "screen" \; \
    pipe-pane        "cat >> $LOGDIR/$LOGFILE" \; \
    # display-message  "Started logging to $LOGDIR/$LOGFILE"
fi
  # tmux  set-option default-terminal "screen" \; \
    # run-shell        "[ ! -d $HOME/.tmuxlog/#W/$(date +%Y-%m/%d) ] && mkdir -p $HOME/.tmuxlog/#W/$(date +%Y-%m/%d)" \; \
    # pipe-pane        "cat >> $HOME/.tmuxlog/#W/$(date +%Y-%m/%d/%H%M%S.log)" \; \
    # display-message  "Started logging to $HOME/.tmuxlog/#W/$(date +%Y-%m/%d/%H%M%S.log)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /home/hy/.nvm/versions/node/v4.3.2/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /home/hy/.nvm/versions/node/v4.3.2/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /home/hy/.nvm/versions/node/v4.3.2/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /home/hy/.nvm/versions/node/v4.3.2/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
