# :fzf-tab:complete:(\\|*/|)tofu:*

local level=$(echo "$words" | tr -cd ' ' | wc -c)

# Trim trailing whitespace
local word=$(echo $word | xargs)

# Skip preview for the options
if [[ $word == "-"* ]]; then
  return
fi

# Sub-command, e.g. tofu apply
if [ $level = 1 ]; then
  if bash -c "tldr tofu $word" >/dev/null 2>&1; then
    echo "$ tldr tofu $word"
    tldr --color=always tofu $word | tail -n +3
  fi

  echo "$ tofu $word --help" | bat -pl bash
  tofu $word --help | bat -l help
fi

# Sub-command with nested sub-command, e.g. tofu metadata functions
if [ $level = 2 ]; then
  local cmd=$(echo $words | awk '{print $2}')

  if [[ $words =~ " (metadata|providers|state|workspace) " ]]; then
    echo "$ tofu $cmd $word --help" | bat -pl bash
    tofu $cmd $word --help | bat -l help
  fi

fi
