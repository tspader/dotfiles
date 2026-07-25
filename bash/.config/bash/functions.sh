# Create directory and cd into it
m() {
    mkdir -p "$1" && cd "$1"
}

spot() {
  case "$1" in
    new|go|keep)
      local out
      out="$(command spot path "$@")" || return
      if [[ -n "$out" ]]; then
        cd "$out"
      fi
      ;;
    *) command spot "$@" ;;
  esac
}
tmp() {
  local base="$HOME/source/.tmp"
  \mkdir -p "$base"
  cd "$(mktemp --directory --tmpdir="$base" aXXXXXXXX)"
  chmod -R 0700 .
  if [[ $# -eq 1 ]]; then
    \mkdir -p "$1"
    cd "$1"
  fi
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

ff() {
  find . -type f -name "*$1*"
}

fd() {
  find . -type d -name "*$1*"
}

backup() {
  cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
}

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
