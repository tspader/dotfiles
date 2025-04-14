#
# ~/.bashrc
#

# If not running interactively, don't do anything
alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\ > '

alias ll="ls -la"

BASH_LOCAL="$HOME/.bash_local"
if [ -f ~/.bash_local ]; then
  source $BASH_LOCAL
fi