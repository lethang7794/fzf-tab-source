# :fzf-tab:complete:(\\|*/|)packer:*

local level=$(echo "$words" | tr -cd ' ' | wc -c)

# Trim trailing whitespace
word=$(echo $word | xargs)

# Skip preview for the options
if [[ $word == "-"* ]]; then
  return
fi

# Sub-command, e.g. packer build
if [ $level = 1 ]; then
  if bash -c "packer $word --help" >/dev/null 2>&1; then
    echo "$ packer $word --help" | bat -pl bash
    packer $word --help | bat -l help
  fi
fi

if [ $level = 2 ]; then
  local cmd=$(echo $words | awk '{print $2}')

  # Sub-command with nested sub-command, e.g. packer plugins install
  if [[ $words =~ " (plugins) " ]]; then
    if bash -c "packer $cmd $word --help" >/dev/null 2>&1; then
      echo "$ packer $cmd $word --help" | bat -pl bash
      packer $cmd $word --help | bat -l help
    fi
  fi

fi
