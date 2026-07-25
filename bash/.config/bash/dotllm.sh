ref() { cd "$(dotllm which "$1")"; }
_ref() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "$(dotllm completions --names 2>/dev/null)" -- "${cur}") )
}
complete -F _ref ref

# @dotllm_completions
# Installed by the dotllm CLI
[ -f "/home/spader/.local/share/dotllm/completions.bash" ] && source "/home/spader/.local/share/dotllm/completions.bash"
