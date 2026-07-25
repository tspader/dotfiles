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

is_sshfs() {
    if [[ "$PWD" != "$_sshfs_cache_pwd" ]]; then
        _sshfs_cache_pwd="$PWD"
        if mount | command grep -q "$(pwd).*fuse.sshfs"; then
            _sshfs_cache_result=0
        else
            _sshfs_cache_result=1
        fi
    fi
    return "$_sshfs_cache_result"
}

git_branch() {
    is_sshfs && return
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || return
    [[ -n "$branch" ]] && printf ' (%s)' "$branch"
}

# Function to set prompt based on exit status
set_prompt() {
    local EXIT="$?"

    history -a

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

PROMPT_COMMAND="set_prompt"
export -n PROMPT_COMMAND 2>/dev/null
