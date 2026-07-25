# Increase history size
export HISTSIZE=10000
export HISTFILESIZE=20000

# Append to history, don't overwrite
shopt -s histappend

# Save multi-line commands as one command
shopt -s cmdhist

# Ignore duplicate commands and commands starting with space
export HISTCONTROL=ignoreboth:erasedups

# Add timestamp to history
export HISTTIMEFORMAT="%F %T "
