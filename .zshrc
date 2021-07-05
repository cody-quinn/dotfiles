autoload -U colors && colors

export VIRTUAL_ENV_DISABLE_PROMPT=1

function gen_prompt {
	[ $VIRTUAL_ENV ] && MINIFIED_VENV=`basename $VIRTUAL_ENV`' ' 
	echo "%B$MINIFIED_VENV%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%c%{$fg[red]%}]%{$reset_color%}$%b "
}

PROMPT=$(gen_prompt)
RPROMPT="%B%b"

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e

# Environment Variables
export PYTHONDONTWRITEBYTECODE=1
export EDITOR=vim

# Generic Aliasing
alias l="exa"
alias ls="exa -l --icons --group-directories-first"
alias la="exa -la --icons --group-directories-first"
alias lt="exa -T -I \"node_modules|venv|Build\""

alias feh="feh $1 -. --auto-rotate"

alias calc="="
function = 
{echo "$@" | bc -l }

alias playlist-dl="youtube-dl $1 --add-metadata -x -o \"%(playlist_index)s %(title)s.%(ext)s\""

alias mpshuffle="mpv $1 --shuffle"

alias pdf=zathura

alias visudo="sudo EDITOR=vim /sbin/visudo"

alias chimken="figlet 'chimken'"

# Automatically enter a python virtual env
# when changing directiories into one that
# contains a python virtual env
function cd() {
  builtin cd "$@"

  if [[ -z "$VIRTUAL_ENV" ]] ; then
    if [[ -d ./venv ]] ; then
      source ./venv/bin/activate
    fi
  else
    parentdir="$(dirname "$VIRTUAL_ENV")"
    if [[ "$PWD"/ != "$parentdir"/* ]] ; then
      deactivate
    fi
  fi

  PROMPT=$(gen_prompt)
}

# Make delete key work
bindkey "\e[3~" delete-char

# Enable plugins
source ~/.local/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

colorscript random

