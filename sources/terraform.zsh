# :fzf-tab:complete:(\\|*/|)terraform:*

local level=$(echo "$words" | tr -cd ' ' | wc -c)

# Trim trailing whitespace
local word=$(echo $word | xargs)

# Skip preview for the options
if [[ $word == "-"* ]]; then
  return
fi

# Sub-command, e.g. terraform apply
if [ $level = 1 ]; then
  if bash -c "tldr terraform $word" >/dev/null 2>&1; then
    echo "$ tldr terraform $word"
    tldr --color=always terraform $word | tail -n +3
  fi

  echo "$ terraform $word --help" | bat -pl bash
  terraform $word --help | bat -l help
fi

# Sub-command with nested sub-command, e.g. terraform metadata functions
if [ $level = 2 ]; then
  local cmd=$(echo $words | awk '{print $2}')

  if [[ $words =~ " (metadata|providers|state|workspace) " ]]; then
    echo "$ terraform $cmd $word --help" | bat -pl bash
    terraform $cmd $word --help | bat -l help
  fi

fi
