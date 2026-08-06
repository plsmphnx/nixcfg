clip() { printf "\033]52;c;$(echo -n "$1" | base64 | tr -d '\n')\a"; }
cmd_show --clip "$@"
