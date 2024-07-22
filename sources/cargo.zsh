# :fzf-tab:complete:(\\|*/|)cargo:*

local level=$(echo "$words" | tr -cd ' ' | wc -c)

# Trim trailing whitespace
local word=$(echo $word | xargs)

# Skip preview for the options
if [[ $word == "-"* ]]; then
  return
fi

# Show parent's help for help sub-command
local prefix="${words% *}"
if [[ $word =~ "help" ]] && ! [[ $words =~ "cargo help " ]]; then
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

# Sub-command, e.g. cargo install
if [ $level = 1 ]; then
  if bash -c "tldr cargo $word" >/dev/null 2>&1; then
    echo "$ tldr cargo $word"
    tldr --color=always cargo $word | tail -n +3
  fi

  echo "$ cargo help $word" | bat -pl bash
  cargo help $word | bat -l help
fi

# Sub-command with nested sub-command, e.g. cargo config get
if [ $level = 2 ]; then
  local cmd=$(echo $words | awk '{print $2}')

  if [[ $words =~ " (config) " ]]; then
    local cmd=$(echo $words | awk '{print $2}')

    echo "$ cargo $cmd $word --help" | bat -pl bash
    cargo $cmd $word --help | bat -l help
  fi

  if [[ $words =~ " (help) " ]]; then
    echo "$ cargo $word --help" | bat -pl bash
    cargo $word --help | bat -l help
    echo
    echo "$ cargo help $word" | bat -pl bash
    cargo help $word | bat -l help
  fi

fi
