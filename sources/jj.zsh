# :fzf-tab:complete:(jj|jj*):*

local root_cmd="jj"
local level=$(echo "$words" | tr -cd ' ' | wc -c)
local prefix="${words% *}"
local word="${word% *}"

# debug

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

# Level 1 command, e.g. $root_cmd install
if [ $level = 1 ]; then
  if [[ $word =~ "help" ]]; then
    echo "$ $root_cmd $word" | bat -pl bash
    $root_cmd $word | bat -l help
  else
    echo "$ $root_cmd $word --help"
    $root_cmd $word --help
  fi
fi

# Level 2, e.g. $root_cmd help commit
if [ $level = 2 ]; then
  local cmd=$(echo $words | awk '{print $2}')

  if [[ $words =~ " (help) " ]]; then
    echo "$ $root_cmd help $word" | bat -pl bash
    $root_cmd help $word | bat -l help
  fi
fi
