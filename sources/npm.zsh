# :fzf-tab:complete:(\\|*/|)npm:*

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

# Sub-command, e.g. npm install
if [ $level = 1 ]; then
  if bash -c "tldr npm $word" >/dev/null 2>&1; then
    echo "$ tldr npm $word"
    tldr --color=always npm $word | tail -n +3
  fi

  echo "$ npm $word --help" | bat -pl bash
  npm $word --help | bat -l help
  echo
  echo "$ npm help $word" | bat -pl bash
  npm help $word | bat -l help
fi

# Sub-command with nested sub-command, e.g. npm cache add
if [ $level = 2 ]; then
  local cmd=$(echo $words | awk '{print $2}')

  if [[ $words =~ " (cache|config|dist-tag|hook|org|owner|pkg|profile|team|token) " ]]; then
    local cmd=$(echo $words | awk '{print $2}')

    echo "$ npm help $cmd" | bat -pl bash
    npm help $cmd | bat -l help
  fi

  if [[ $words =~ " (help) " ]]; then
    echo "$ npm help $word" | bat -pl bash
    npm help $word | bat -l help
  fi

fi
