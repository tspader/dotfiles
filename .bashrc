#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

export PATH=$PATH:/home/spader/.local/bin
export PATH=/opt/gcc-arm-none-eabi-6-2017-q2-update/bin:$PATH
export PATH=/home/spader/programming/ardupilot/ardupilot/Tools/autotest:$PATH

source ~/.bash_local
