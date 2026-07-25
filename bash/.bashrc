# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

BASH_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/bash"

source "$BASH_CONFIG/history.sh"
source "$BASH_CONFIG/prompt.sh"
source "$BASH_CONFIG/aliases.sh"
source "$BASH_CONFIG/functions.sh"
source "$BASH_CONFIG/shell-options.sh"
source "$BASH_CONFIG/completion.sh"
source "$BASH_CONFIG/keybindings.sh"
source "$BASH_CONFIG/fzf.sh"
source "$BASH_CONFIG/man.sh"
source "$BASH_CONFIG/env.sh"
source "$BASH_CONFIG/local.sh"
source "$BASH_CONFIG/path.sh"
source "$BASH_CONFIG/direnv.sh"
source "$BASH_CONFIG/nvm.sh"
source "$BASH_CONFIG/dotllm.sh"
source "$BASH_CONFIG/atuin.sh"
