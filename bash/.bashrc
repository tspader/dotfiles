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
# Better defaults
alias mkdir='mkdir -pv'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias rc='source ~/.bashrc && echo "sourced ~/.bashrc"'

if command -v trash >/dev/null 2>&1; then
    alias rm='trash'
fi

if command -v lazygit >/dev/null 2>&1; then
    alias lg='lazygit'
fi

if command -v lsd >/dev/null 2>&1; then
    alias ls='lsd -A'
    alias l='lsd'
    alias ll='lsd -alF'
    alias lt='lsd --tree --depth 2'
    alias lh='lsd -ld .??*'
else
    alias ls='ls --color=auto'
    alias ll='ls -alF --color=auto'
    alias la='ls -A --color=auto'
    alias l='ls -CF --color=auto'
    alias lt='ls --human-readable --size -1 -S --classify --color=auto'
    alias lh='ls -ld .??* --color=auto'
fi

export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

alias n='nvim'
alias tree='tree -a -C'  # Colorized tree (if available)
alias tree3='tree -a -C -L 3'
alias dus='du -sh * | sort -h'  # Directory sizes, sorted
alias duf='du -sh .* * | sort -h'  # Include hidden files
alias h='history'
alias hg='history | grep'
alias hl='history | less'
alias psa='ps aux'
alias psg='ps aux | grep -v grep | grep'
alias topmem='ps aux | sort -nrk 4 | head'  # Top memory consumers
alias topcpu='ps aux | sort -nrk 3 | head'  # Top CPU consumers
alias ports='netstat -tulanp'
alias myip='curl -s ifconfig.me'
alias meminfo='free -h'
alias cpuinfo='lscpu'
alias diskinfo='df -h'
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

get_os_type() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ -n "$WSL_DISTRO_NAME" ]] && command -v clip.exe >/dev/null 2>&1; then
        echo "wsl"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
        echo "windows"
    else
        echo "linux"
    fi
}

clip() {
    local os_type=$(get_os_type)

    case "$os_type" in
        "macos")
            pbcopy
            ;;
        "wsl")
            clip.exe
            ;;
        "windows")
            clip.exe
            ;;
        "linux")
            if command -v xclip >/dev/null 2>&1; then
                xclip -selection clipboard
            elif command -v xsel >/dev/null 2>&1; then
                xsel --clipboard --input
            else
                echo "Error: No clipboard utility found. Install xclip or xsel." >&2
                return 1
            fi
            ;;
        *)
            echo "Error: Unsupported OS type: $os_type" >&2
            return 1
            ;;
    esac
}

paste() {
    local os_type=$(get_os_type)

    case "$os_type" in
        "macos")
            pbpaste
            ;;
        "wsl")
            powershell.exe -command "Get-Clipboard" 2>/dev/null
            ;;
        "windows")
            powershell.exe -command "Get-Clipboard" 2>/dev/null
            ;;
        "linux")
            if command -v xclip >/dev/null 2>&1; then
                xclip -selection clipboard -o
            elif command -v xsel >/dev/null 2>&1; then
                xsel --clipboard --output
            else
                echo "Error: No clipboard utility found. Install xclip or xsel." >&2
                return 1
            fi
            ;;
        *)
            echo "Error: Unsupported OS type: $os_type" >&2
            return 1
            ;;
    esac
}

hex() {
    printf "#%02x%02x%02x" "$1" "$2" "$3"
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
    __fzf_history__() {
        local output
        output=$(
            HISTTIMEFORMAT= history |
            fzf --tac --no-sort --reverse --query "$READLINE_LINE" \
                --preview 'echo {}' \
                --preview-window down:3:wrap \
                --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip -selection clipboard)+abort' \
                --exact |
            sed 's/^ *[0-9]* *//'
        ) || return
        READLINE_LINE="$output"
        READLINE_POINT=${#READLINE_LINE}
    }

    bind -x '"\C-r": __fzf_history__'
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
# BETTER DEFAULTS
# ============================================
export LESS='-R -F -X -i -P %lt-%lb/%L [%f]'
export EDITOR='nvim'
export VISUAL='nvim'
export PYTHONDONTWRITEBYTECODE=1

# ============================================
# LOCAL CUSTOMIZATIONS
# ============================================
# Source local configurations if they exist
if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi


# uv
export PATH="/Users/spader/.local/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
