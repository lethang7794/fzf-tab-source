# :fzf-tab:complete:(\\|*/|)dnf:*

# debug

local level=$(echo "$words" | tr -cd ' ' | wc -c)

# Trim trailing whitespace
local word=$(echo $word | xargs)

# Skip preview for the options
if [[ $word == "-"* ]]; then
  return
fi

# Sub-command, e.g. dnf install
if [ $level = 1 ]; then
  if bash -c "tldr dnf $word" >/dev/null 2>&1; then
    echo "$ tldr dnf $word"
    tldr --color=always dnf $word | tail -n +3
  fi

  echo "$ dnf $word --help" | bat -pl bash
  dnf $word --help | bat -l help
fi

# Sub-command with nested sub-command, e.g. dnf metadata functions
if [ $level = 2 ]; then
  local cmd=$(echo $words | awk '{print $2}')

  if [[ $words =~ " (info|install|reinstall|remove|upgrade|downgrade|list|swap) " ]]; then
    echo "$ dnf5 -C info $word" | bat -pl bash
    dnf5 -C info $word | bat -pl yaml
  fi

fi
