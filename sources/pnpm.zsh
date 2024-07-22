# :fzf-tab:complete:(\\|*/|)pnpm:*

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
  if bash -c "$prefix --help" >/dev/null 2>&1; then
    echo "$ $prefix --help" | bat -pl bash
    eval $prefix --help | bat -l help
  fi
  return
fi

# Sub-command, e.g. pnpm install
if [ $level = 1 ]; then
  if bash -c "tldr pnpm $word" >/dev/null 2>&1; then
    echo "$ tldr pnpm $word"
    tldr --color=always pnpm $word | tail -n +3
  fi

  echo "$ pnpm help $word" | bat -pl bash
  pnpm help $word | bat -l help
fi

# Sub-command with nested sub-command, e.g. pnpm cache add
if [ $level = 2 ]; then
  local cmd=$(echo $words | awk '{print $2}')

  if [[ $words =~ " (config|env|store|server|licenses) " ]]; then
    local cmd=$(echo $words | awk '{print $2}')

    echo "$ pnpm help $cmd" | bat -pl bash
    pnpm help $cmd | bat -l help
  fi

  if [[ $words =~ " (help) " ]]; then
    echo "$ pnpm help $word" | bat -pl bash
    pnpm help $word | bat -l help
  fi

fi
