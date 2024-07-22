# :fzf-tab:complete:(\\|*/|)go:*

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

# Sub-command, e.g. go install
if [ $level = 1 ]; then
  if bash -c "tldr go $word" >/dev/null 2>&1; then
    echo "$ tldr go $word"
    tldr --color=always go $word | tail -n +3
  fi

  echo "$ go help $word" | bat -pl bash
  go help $word | bat -l help
fi

# Sub-command with nested sub-command, e.g. go mod download
if [ $level = 2 ]; then
  local cmd=$(echo $words | awk '{print $2}')

  if [[ $words =~ " (mod|work) " ]]; then
    local cmd=$(echo $words | awk '{print $2}')

    echo "$ go help $cmd $word" | bat -pl bash
    go help $cmd $word | bat -l help
  fi

  if [[ $words =~ " (help) " ]]; then
    echo "$ go help $word" | bat -pl bash
    go help $word | bat -l help
  fi

fi
