if [ -n "$BASH_VERSION" ]; then
  case $- in
  *i*)
    if [ -f "$HOME/.bashrc" ]; then
      . "$HOME/.bashrc"
    fi
    ;;
  esac
fi
