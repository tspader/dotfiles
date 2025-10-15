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

#######
# TUI #
#######
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

sp_tui_newline() {
  printf "\n"
}

sp_tui_met() {
  sp_tui_clear
  sp_color "$SP_BRIGHT_GREEN" "met "
  sp_color "$SP_BRIGHT_CYAN" "$1 "
  shift
  sp_color "$SP_BRIGHT_BLACK" "$* "
}

sp_tui_unmet() {
  sp_tui_clear
  sp_color "$SP_BRIGHT_RED" "unmet "
  sp_color "$SP_BRIGHT_CYAN" "$1 "
  shift
  sp_color "$SP_BRIGHT_BLACK" "$* "
}

sp_tui_fail() {
  sp_tui_clear
  sp_color "$SP_BRIGHT_RED" "fail "
  sp_color "$SP_BRIGHT_CYAN" "$1 "
  shift
  sp_color "$SP_BRIGHT_BLACK" "$* "
}

sp_tui_unknown() {
  sp_tui_clear
  sp_color "$SP_BRIGHT_YELLOW" "unknown "
  sp_color "$SP_BRIGHT_CYAN" "$1 "
  shift
  sp_color "$SP_BRIGHT_BLACK" "$* "
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

sp_tui_hide_cursor() {
  tput civis 2>/dev/null || true;
}

sp_tui_show_cursor() {
  tput cnorm 2>/dev/null || true;
}

sp_source_relative() {
  . "$(dirname "$0")/$1"
}

sp_pad() {
  local text="$1"
  local width="$2"
  printf "%-${width}s" "$text"
}

###########
# MEETERS #
###########
sp_generic_pkg_is_installed() {
  local pkg_name="$1"
  command -v "$pkg_name" > /dev/null 2>&1
}

sp_generic_pkg_install() {
  local pkg_name="$1"
  local repo_url="$2"
  local pkg_dir="$HOME/.local/share/$pkg_name"

  if [ ! -d "$pkg_dir" ]; then
    git clone "$repo_url" "$pkg_dir"
  fi
  cd "$pkg_dir" && makepkg -si --noconfirm
}

sp_interactive_is_met() {
  return 1
}

sp_interactive_meet() {
  # If not a TTY, refuse (we don't want to swallow prompts silently)
  if [ ! -t 1 ]; then
    echo "[debug] Non-interactive environment; skipping interactive session" >&2
    return 1
  fi

  "$@"
}

sp_pacman_is_installed() {
  pacman -Q "$1" > /dev/null 2>&1
}

sp_pacman_install() {
  sudo pacman -S --noconfirm "$1"
}

sp_docker_is_installed() {
  command -v docker > /dev/null 2>&1
}

sp_docker_install() {
  sudo pacman -S --noconfirm docker
}

sp_apt_is_installed() {
  dpkg -s "$1" > /dev/null 2>&1
}

sp_apt_install() {
  sudo apt install "$1"
}

sp_dependency_registry="
generic_pkg     sp_generic_pkg_is_installed sp_generic_pkg_install
pacman          sp_pacman_is_installed      sp_pacman_install
docker          sp_docker_is_installed      sp_docker_install
apt             sp_apt_is_installed         sp_apt_install
interactive     sp_interactive_is_met       sp_interactive_meet    interactive
"


#########################
# DEPENDENCY PROCESSING #
#########################
sp_meet_with_spinner() {
  local type="$1"; shift
  local args_str="$1"; shift
  local meet_fn="$1"; shift
  local frames='|/-\\'
  local i=0
  local tmpfile

  if [ ! -t 1 ]; then
    tmpfile=$(mktemp)
    "$meet_fn" "$@" > "$tmpfile" 2>&1
    local rc=$?
    if [ $rc -ne 0 ] && [ -s "$tmpfile" ]; then
      printf "\n"
      sp_color "$SP_BRIGHT_BLACK" "$(cat "$tmpfile")"
    fi
    rm -f "$tmpfile"
    return $rc
  fi

  tmpfile=$(mktemp)
  sp_tui_hide_cursor

  "$meet_fn" "$@" > "$tmpfile" 2>&1 &
  local pid=$!

  trap 'kill $pid 2>/dev/null; sp_tui_clear; sp_tui_show_cursor; rm -f "$tmpfile"; return 130' INT TERM
  while kill -0 $pid 2>/dev/null; do
    local frame=${frames:i%${#frames}:1}
    sp_tui_home
    sp_tui_unmet "$type" "$args_str"
    sp_color "$SP_BRIGHT_YELLOW" "$frame"
    i=$((i+1))
    sleep 0.1
  done

  wait $pid
  local rc=$?

  sp_tui_clear
  sp_tui_show_cursor

  # Store output for potential display by caller
  if [ -s "$tmpfile" ]; then
    sp_meet_output=$(cat "$tmpfile")
  else
    sp_meet_output=""
  fi
  sp_meet_rc=$rc

  rm -f "$tmpfile"
  return $rc
}

sp_ensure_dependency() {
  local type="$1"
  shift

  local registry_entry=$(echo "$sp_dependency_registry" | grep "^$type[[:space:]]")

  if [ -z "$registry_entry" ]; then
    sp_tui_unknown "$type" "$@"
    sp_tui_newline
    return 1
  fi

  local is_met_fn=$(echo "$registry_entry" | awk '{print $2}')
  local meet_fn=$(echo "$registry_entry" | awk '{print $3}')
  local flag=$(echo "$registry_entry" | awk '{print $4}')

  $is_met_fn "$@"; local status=$?
  if [ $status -eq 0 ]; then
    sp_tui_met "$type" "$@"
    sp_tui_newline
    return 0
  fi

  local meet_rc=0
  if [ "$flag" = "interactive" ]; then
    # Print unmet line first (no spinner) then run interactively
    sp_tui_unmet "$type" "$@"
    sp_tui_newline
    $meet_fn "$@"; meet_rc=$?
  else

    sp_meet_with_spinner "$type" "$*" $meet_fn "$@"; meet_rc=$?
  fi

  $is_met_fn "$@"; local after=$?
  # For debug/interactive kinds we consider a zero exit from meet as success even if not re-checkable.
  if [ $after -eq 0 ] || { [ "$flag" = "interactive" ] && [ $meet_rc -eq 0 ]; }; then
    sp_tui_met "$type" "$@"
    sp_tui_newline
  else
    sp_tui_fail "$type" "$@"
    sp_tui_newline

    if [ $meet_rc -ne 0 ] && [ -n "$sp_meet_output" ]; then
      sp_color "$SP_BRIGHT_BLACK" "  failed with exit code "
      sp_color "$SP_BRIGHT_RED" "$sp_meet_rc"
      sp_tui_newline

      sp_color "$SP_BRIGHT_BLACK" "  $sp_meet_output"
      sp_tui_newline
      exit 1

    fi
  fi
}

#########
# UTILS #
#########
sp_detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    printf '%s' "$ID"
  else
    uname -s | tr '[:upper:]' '[:lower:]'
  fi
}

