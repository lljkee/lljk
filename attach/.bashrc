#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1="\[\033[1;32m\][\$(date +%H:%M)][\u@\h:\w]$\[\033[0m\] "
