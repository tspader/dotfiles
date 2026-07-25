# Check window size after each command
shopt -s checkwinsize

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Append to the Bash history file, don't overwrite
shopt -s histappend

# Case-insensitive globbing
shopt -s nocaseglob

# Extended globbing patterns
shopt -s extglob

# Include hidden files in pathname expansion
shopt -s dotglob

# Enable recursive globbing with **
shopt -s globstar 2>/dev/null
