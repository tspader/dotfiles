# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ============================================
# HISTORY CONFIGURATION
# ============================================
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

# Store history immediately after each command
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# ============================================
# COLORED PROMPT CONFIGURATION
# ============================================
# Color codes
# RED='\[\033[0;31m\]'
# GREEN='\[\033[0;32m\]'
# YELLOW='\[\033[0;33m\]'
# BLUE='\[\033[0;34m\]'
# PURPLE='\[\033[0;35m\]'
# CYAN='\[\033[0;36m\]'
# WHITE='\[\033[0;37m\]'
# BOLD_RED='\[\033[1;31m\]'
# BOLD_GREEN='\[\033[1;32m\]'
# BOLD_YELLOW='\[\033[1;33m\]'
# BOLD_BLUE='\[\033[1;34m\]'
# RESET='\[\033[0m\]'

BLACK='\[\033[0;30m\]'
RED='\[\033[0;31m\]'
GREEN='\[\033[0;32m\]'
YELLOW='\[\033[0;33m\]'
BLUE='\[\033[0;34m\]'
PURPLE='\[\033[0;35m\]'
CYAN='\[\033[0;36m\]'
WHITE='\[\033[0;37m\]'
# Even softer colors using dim (2) instead of bold (1)
DIM_RED='\[\033[2;31m\]'
DIM_GREEN='\[\033[2;32m\]'
DIM_YELLOW='\[\033[2;33m\]'
DIM_BLUE='\[\033[2;34m\]'
DIM_CYAN='\[\033[2;36m\]'
# Light colors (90-97 range) - these are softer than the bright variants
LIGHT_RED='\[\033[0;91m\]'
LIGHT_GREEN='\[\033[0;92m\]'
LIGHT_YELLOW='\[\033[0;93m\]'
LIGHT_BLUE='\[\033[0;94m\]'
LIGHT_PURPLE='\[\033[0;95m\]'
LIGHT_CYAN='\[\033[0;96m\]'
RESET='\[\033[0m\]'

# Function to get git branch (if in a git repo)
git_branch() {
    git branch 2>/dev/null | grep -e '^*' | sed 's/^..\(.*\)/ (\1)/'
}

# Function to set prompt based on exit status
set_prompt() {
    local EXIT="$?"
    PS1=""
    
    # Show exit status if non-zero
    if [ $EXIT != 0 ]; then
        PS1+="${LIGHT_RED}[${EXIT}]${RESET} "
    fi
    
    # User@host
    if [[ ${EUID} == 0 ]]; then
        PS1+="${GREEN}\u@\h${RESET}"
    else
        PS1+="${GREEN}\u@\h${RESET}"
    fi
    
    # Working directory
    PS1+=":${CYAN}\w${RESET}"
    
    # Git branch (if applicable)
    PS1+="${YELLOW}$(git_branch)${RESET}"
    
    # Prompt symbol
    PS1+=" > "
}

# Set PROMPT_COMMAND to update prompt
PROMPT_COMMAND="set_prompt${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# ============================================
# USEFUL ALIASES
# ============================================
# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'

# Better defaults
alias mkdir='mkdir -pv'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'

# ls aliases with color
alias ls='ls --color=auto'
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias lt='ls --human-readable --size -1 -S --classify --color=auto'
alias lh='ls -ld .??* --color=auto'  # Show hidden files only

export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# Quick directory listing
alias tree='tree -a -C'  # Colorized tree (if available)
alias dus='du -sh * | sort -h'  # Directory sizes, sorted
alias duf='du -sh .* * | sort -h'  # Include hidden files

# History shortcuts
alias h='history'
alias hg='history | grep'
alias hl='history | less'

# Process management
alias psa='ps aux'
alias psg='ps aux | grep -v grep | grep'
alias topmem='ps aux | sort -nrk 4 | head'  # Top memory consumers
alias topcpu='ps aux | sort -nrk 3 | head'  # Top CPU consumers

# Network
alias ports='netstat -tulanp'
alias myip='curl -s ifconfig.me'

# System info
alias meminfo='free -h'
alias cpuinfo='lscpu'
alias diskinfo='df -h'

# Timestamps
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias today='date +"%Y-%m-%d"'

# ============================================
# USEFUL FUNCTIONS
# ============================================
# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract archives
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Find files in current directory
ff() {
    find . -type f -name "*$1*"
}

# Find directories in current directory
fd() {
    find . -type d -name "*$1*"
}

# Create backup of file with timestamp
backup() {
    cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
}

# Show PATH in readable format
path() {
    echo -e ${PATH//:/\\n}
}

calc() {
    echo "scale=3; $*" | bc -l
}

clip() {
   pbcopy < "$1"
}

hex() {
    printf "#%02x%02x%02x\n" "$1" "$2" "$3"
}

# ============================================
# SHELL OPTIONS
# ============================================
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

# ============================================
# BETTER TAB COMPLETION
# ============================================
# Perform file completion in a case insensitive fashion
bind "set completion-ignore-case on"

# Treat hyphens and underscores as equivalent
bind "set completion-map-case on"

# Display matches for ambiguous patterns at first tab press
bind "set show-all-if-ambiguous on"

# Immediately add a trailing slash when autocompleting symlinks to directories
bind "set mark-symlinked-directories on"

# ============================================
# HISTORY SEARCH WITH ARROW KEYS
# ============================================
# Use up/down arrows to search history based on current input
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Use Ctrl+R for reverse history search (usually default)
bind '"\C-r": reverse-search-history'

# ============================================
# FZF HISTORY SEARCH
# ============================================
# Check if fzf is installed
if command -v fzf >/dev/null 2>&1; then
    # Better history search with fzf
    __fzf_history__() {
        local output
        output=$(
            HISTTIMEFORMAT= history | 
            fzf --tac --no-sort --reverse --query "$READLINE_LINE" \
                --preview 'echo {}' \
                --preview-window down:3:wrap \
                --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip -selection clipboard)+abort' \
                --scheme=history | 
            sed 's/^ *[0-9]* *//'
        ) || return
        READLINE_LINE="$output"
        READLINE_POINT=${#READLINE_LINE}
    }
    
    # Bind Ctrl+R to fzf history search
    bind -x '"\C-r": __fzf_history__'

    # FZF default options for better appearance
    export FZF_DEFAULT_OPTS='
        --height 75% 
        --layout=reverse 
        --pointer=">"
        --info=hidden
        --color=fg:#c0c0c0,bg:-1,hl:#5f87af
        --color=fg+:#ffffff,bg+:#262626,hl+:#5fd7ff
        --color=info:#afaf87,prompt:#5f87af,pointer:#af5fff
        --color=marker:#87ff00,spinner:#af5fff,header:#87afaf
    '
fi

# ============================================
# COLORED MAN PAGES
# ============================================
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# ============================================
# BETTER LESS DEFAULTS
# ============================================
export LESS='-R -F -X -i -P %lt-%lb/%L [%f]'

# ============================================
# EDITOR CONFIGURATION
# ============================================
# Set default editor (change to your preference)
export EDITOR='vi'
export VISUAL='vi'

# ============================================
# LOCAL CUSTOMIZATIONS
# ============================================
# Source local configurations if they exist
if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
