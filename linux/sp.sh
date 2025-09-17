SP_BLACK='\033[30m'
SP_RED='\033[31m'
SP_GREEN='\033[32m'
SP_YELLOW='\033[33m'
SP_BLUE='\033[34m'
SP_MAGENTA='\033[35m'
SP_CYAN='\033[36m'
SP_WHITE='\033[37m'
SP_BRIGHT_BLACK='\033[90m'
SP_BRIGHT_RED='\033[91m'
SP_BRIGHT_GREEN='\033[92m'
SP_BRIGHT_YELLOW='\033[93m'
SP_BRIGHT_BLUE='\033[94m'
SP_BRIGHT_MAGENTA='\033[95m'
SP_BRIGHT_CYAN='\033[96m'
SP_BRIGHT_WHITE='\033[97m'
SP_RESET='\033[0m'
SP_CLEAR_LINE=$'\r\033[K'

sp_color() {
  local color="$1"
  local text="$2"
  printf "${color}%s${SP_RESET}" "$text"
}

sp_tui_clear() {
  printf "%s" "$SP_CLEAR_LINE";
}

sp_tui_home() {
  printf "\r"
}

sp_tui_new_line() {
  printf "\n"
}

sp_source_relative() {
  . "$(dirname "$0")/$1"
}
