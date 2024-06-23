# :fzf-tab:complete:systemctl:*

# System control has 6 types of command:
# - unit command
# - machine command
# - unit file command
# - job command
# - environment command
# - manager state command
# - system command
if [[ $group == *command ]]; then

  # The help entry for a command is already shown in the completion
  # echo "$ systemctl -h"
  # systemctl -h | sed -ne "/^ *$word/,/^\$/p" | head -n 3 | bat --color=always -l help

  echo
  echo "$ man systemctl"
  man systemctl | sed -ne "/^ *$word/,/^$/p" | bat -l help
# else
#   debug
fi
