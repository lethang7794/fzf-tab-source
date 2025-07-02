# :fzf-tab:complete:(\\|*/|)ollama:*

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

    echo "\$ ollama help"
    echo "\$word: $word"
    ollama help | head -n 150 | rg -A10 -- "$word"

    printf "\n%s:\n  " "For more information, run"
    echo "$prefix help | less --pattern=$word"

    if [[ $prefix != ollama ]]; then
      printf "or:\n  "
      echo "ollama help | less --pattern=$word"
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

# Sub-command, e.g. ollama deploy
if [ $level = 1 ]; then
  if bash -c "tldr ollama $word" >/dev/null 2>&1; then
    echo "$ tldr ollama $word"
    tldr --color=always ollama $word | tail -n +3
  fi

  echo "$ ollama $word --help" | bat -pl bash
  ollama $word --help | bat -l help
fi
