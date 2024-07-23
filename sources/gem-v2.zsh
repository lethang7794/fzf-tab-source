# :fzf-tab:complete:((\\|*/|))gem-v2:

# Current input level
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
  return
fi

# Sub-command, e.g. gem install
if [ $level = 1 ]; then
  if bash -c "tldr gem $word" >/dev/null 2>&1; then
    echo "$ tldr gem $word"
    tldr --color=always gem $word | tail -n +3
  fi

  echo "$ gem $word --help" | bat -pl bash
  gem $word --help | bat -l help
fi

# Sub-command with nested argument, e.g. gem help build
if [ $level = 2 ]; then
  local cmd=$(echo $words | awk '{print $2}')

  if [[ $words =~ " (help) " ]]; then
    echo "$ gem help $word" | bat -pl bash
    gem help $word | bat -l help
  fi

  if [[ $words =~ " (check|contents|dependency|environment) " ]]; then
    echo "$ gem $cmd $word" | bat -pl bash
    gem $cmd $word
  fi

  if [[ $words =~ " (install|uninstall|update|lock|fetch|open|yank|owner|unpack) " ]]; then
    echo "$ gem info $word" | bat -pl bash
    gem info $word | bat -pl yaml
  fi

fi
