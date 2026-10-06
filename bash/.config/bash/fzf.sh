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

    # bind -x '"\C-r": __fzf_history__'
fi
