# :fzf-tab:complete:mise:*

local level=$(echo "$words" | tr -cd ' ' | wc -c)

# Trim trailing whitespace
local word=$(echo $word | xargs)

# Skip the option
if [[ $word == "-"* ]]; then
  return
fi

# Level 1 command, e.g. mise install
if [ $level = 1 ]; then
  if [[ $word =~ "help" ]]; then
    echo "$ mise $cmd $word" | bat -pl bash
    mise $cmd $word | bat -l help
  else
    echo "$ mise $word --help"
    mise $word --help
  fi
fi

# Level 2, e.g. mise backends
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
fi
