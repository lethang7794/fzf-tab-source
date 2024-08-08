# :fzf-tab:complete:mise:*

local level=$(echo "$words" | tr -cd ' ' | wc -c)
local prefix="${words% *}"
local word="${word% *}"

# Show command's help for --help or -h option
if [[ $word == "-"* ]]; then
  if [[ $word == "--help" ]] || [[ $word == "-h" ]]; then
    if bash -c "$prefix $word" >/dev/null 2>&1; then
      echo "$ $prefix $word"
      eval $prefix $word | bat -l help
    fi
  fi
  return
fi

# Level 1 command, e.g. mise install
if [ $level = 1 ]; then
  if [[ $word =~ "help" ]]; then
    echo "$ mise $word" | bat -pl bash
    mise $word | bat -l help
  else
    echo "$ mise $word --help"
    mise $word --help
  fi
fi

# Level 2, e.g. mise backends ls
if [ $level = 2 ]; then
  local cmd=$(echo $words | awk '{print $2}')

  if [[ $words =~ " (alias|backends|cache|config|plugins) " ]]; then
    if [[ $word =~ "help" ]]; then
      echo "$ mise $cmd $word" | bat -pl bash
      mise $cmd $word | bat -l help
    else
      echo "$ mise $cmd $word --help" | bat -pl bash
      mise $cmd $word --help | bat -l help
    fi
  fi

  if [[ $words =~ " (help) " ]]; then
    echo "$ mise help $word" | bat -pl bash
    mise help $word | bat -l help
  fi
fi
