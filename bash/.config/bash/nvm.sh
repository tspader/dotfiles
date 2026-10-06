export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    _load_nvm() {
        unset -f nvm node npm npx _load_nvm
        \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    }
    for _cmd in nvm node npm npx; do
        eval "${_cmd}() { _load_nvm; ${_cmd} \"\$@\"; }"
    done
    unset _cmd
fi
