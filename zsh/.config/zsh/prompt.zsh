# PROMPT
emulate -L zsh

source $HOME/.config/zsh/themes/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
source $HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Determine terminal capabilities.
{
  if ! zmodload zsh/langinfo zsh/terminfo ||
     [[ $langinfo[CODESET] != (utf|UTF)(-|)8 || $TERM == (dumb|linux) ]] ||
     (( terminfo[colors] < 256 )); then
    # Don't use the powerline config. It won't work on this terminal.
    local USE_POWERLINE=false
    # Define alias `x` if our parent process is `login`.
    local parent
    if { parent=$(</proc/$PPID/comm) } && [[ ${parent:t} == login ]]; then
      alias x='startx ~/.xinitrc'
    fi
  fi
} 2>/dev/null

# Use 8 colors and ASCII.
source $HOME/.config/zsh/p10k-portable.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=black,bold'
