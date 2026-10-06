if command -v lazygit >/dev/null 2>&1; then
    alias lg='lazygit'
fi

if command -v lsd >/dev/null 2>&1; then
    alias ls='lsd -A'
    alias l='lsd'
    alias ll='lsd -alF'
    alias lh='lsd -ld .??*'
    lt() {
        local dir="${1:-.}"
        local depth="${2:-2}"
        lsd -A --tree --depth "$depth" --group-dirs first "$dir"
    }
else
    alias ls='ls --color=auto'
    alias ll='ls -alF --color=auto'
    alias la='ls -A --color=auto'
    alias l='ls -CF --color=auto'
    alias lh='ls -ld .??* --color=auto'
    lt() {
        local dir="${1:-.}"
        local depth="${2:-2}"
        tree -a -C -L "$depth" --dirsfirst "$dir"
    }
fi

if command -v sqlit >/dev/null 2>&1; then
  sqlite() {
    sqlit --file-path $1 --db-type sqlite
  }
fi

export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

alias mkdir='mkdir -pv'
alias grep='rg'
alias diff='diff --color=auto'
alias erc='$EDITOR ~/.bashrc'
alias rc='source ~/.bashrc && echo "sourced ~/.bashrc"'
alias mk='mkdir -pv'
alias rf='rm -rf'
alias uz='ouch decompress'
alias z='zellij'
alias za='zellij a'
alias n='nvim'
alias dot='cd ~/.dotfiles && nvim'
alias y='yazi'
alias o='opencode'
c() {
  local sp=~/.claude/system.md
  if [[ -f $sp ]]; then
    claude --dangerously-skip-permissions --system-prompt-file "$sp" "$@"
  else
    claude --dangerously-skip-permissions "$@"
  fi
}
alias co='codex --dangerously-bypass-approvals-and-sandbox'
alias g='gdb --args'
alias e='direnv allow'
alias d='dotllm'
alias dl='dotllm link'
dw() { dotllm which "$1" | tr -d '\n' | clip; }
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
