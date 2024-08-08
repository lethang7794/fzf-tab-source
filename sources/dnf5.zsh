# :fzf-tab:complete:(\\|*/|)dnf5:*

local level=$(echo "$words" | tr -cd ' ' | wc -c)

# Trim trailing whitespace
local word=$(echo $word | xargs)

# Skip preview for the options
if [[ $word == "-"* ]]; then
  return
fi

# Show parent's help for help sub-command
local prefix="${words% *}"
if [[ $word =~ "help" ]]; then
  if bash -c "$prefix $word" >/dev/null 2>&1; then
    echo "$ $prefix $word" | bat -pl bash
    eval $prefix $word | bat -l help
  fi
  if bash -c "$prefix --help" >/dev/null 2>&1; then
    echo "$ $prefix --help" | bat -pl bash
    eval $prefix --help | bat -l help
  fi
  return
fi

# Sub-command, e.g. dnf5 install
if [ $level = 1 ]; then
  if bash -c "tldr dnf5 $word" >/dev/null 2>&1; then
    echo "$ tldr dnf5 $word"
    tldr --color=always dnf5 $word | tail -n +3
  fi

  echo "$ dnf5 $word --help" | bat -pl bash
  dnf5 $word --help | bat -l help
fi

# Sub-command with nested sub-command, e.g. dnf5 metadata functions
if [ $level = 2 ]; then
  local cmd=$(echo $words | awk '{print $2}')

  if [[ $words =~ " (info|install|reinstall|remove|upgrade|downgrade|list|swap) " ]]; then
    echo "$ dnf5 -C info $word" | bat -pl bash
    dnf5 -C info $word | bat -pl yaml
  fi

  if [[ $words =~ " (mark|group|environment|module|history|repo|advisory|versionlock|system-upgrade|offline-distrosync|offline-upgrade|offline) " ]]; then
    echo "$ dnf5 $cmd $word --help" | bat -pl bash
    dnf5 $cmd $word --help | bat -pl yaml
  fi
fi
