# :fzf-tab:complete:(\\|*/|)hugo:*

local level=$(echo "$words" | tr -cd ' ' | wc -c)

local prefix="${words% *}"

# Trim trailing whitespace
local word=$(echo $word | xargs)
local cmd="$prefix $word"

local global_options=(

)

if [[ $word == "-"* ]]; then
  # Preview only works for the first option, because it's a hard to parse the command without options
  if [[ $prefix == *"--"* ]]; then
    return
  fi

  if [[ $global_options[*] =~ "$word" ]]; then
    echo "\$ hugo help"
    echo "\$word: $word"
    hugo help | head -n 150 | rg -A10 -- "$word"

    printf "\n%s:\n  " "For more information, run"
    echo "$prefix help | less --pattern=$word"

    if [[ $prefix != hugo ]]; then
      printf "or:\n  "
      echo "hugo help | less --pattern=$word"
    fi
  else
    cmd_help=$(eval "$prefix --help")
    echo "\$ $prefix --help"
    echo $cmd_help | rg -A10 -- "$word"

    printf "\n%s:\n  " "For more information, run"
    echo "$prefix --help | less --pattern=$word" | bat -pl bash
  fi

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

# Sub-command, e.g. hugo deploy
if [ $level = 1 ]; then
  if bash -c "tldr hugo $word" >/dev/null 2>&1; then
    echo "$ tldr hugo $word"
    tldr --color=always hugo $word | tail -n +3
  fi

  echo "$ hugo $word --help" | bat -pl bash
  hugo $word --help | bat -l help
fi
