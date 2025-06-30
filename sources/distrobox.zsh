# :fzf-tab:complete:(\\|*/|)distrobox:*

local level=$(echo "$words" | tr -cd ' ' | wc -c)

local prefix="${words% *}"

# Trim trailing whitespace
local word=$(echo $word | xargs)
local cmd="$prefix $word"

local global_options=(

)

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

# Sub-command, e.g. distrobox deploy
if [ $level = 1 ]; then
  if bash -c "tldr distrobox $word" >/dev/null 2>&1; then
    echo "$ tldr distrobox $word"
    tldr --color=always distrobox $word | tail -n +3
  fi

  echo "$ distrobox $word --help" | bat -pl bash
  distrobox $word --help | bat -l help
fi
