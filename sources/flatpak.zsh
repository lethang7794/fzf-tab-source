# :fzf-tab:complete:(\\|*/|)flatpak:*

# Trim trailing whitespace
local word=$(echo $word | xargs)

local level=$(echo "$words" | tr -cd ' ' | wc -c)

# Trim trailing whitespace
local word=$(echo $word | xargs)

# Skip preview for the options
if [[ $level == 1 ]] && [[ $word == "-"* ]]; then
  return
fi

# e.g. flatpak CMD
if [ $level = 1 ]; then
  if bash -c "tldr flatpak $word" >/dev/null 2>&1; then
    echo "$ tldr flatpak $word"
    tldr --color=always flatpak $word | tail -n +3
  fi

  echo "$ flatpak $word --help" | bat -pl bash
  flatpak $word --help | bat -l help
fi

# e.g. dnf info PACKAGE
if [ $level = 2 ]; then
  local cmd=$(echo $words | awk '{print $2}')

  if [[ $word == "-"* ]]; then
    flatpak $cmd --help | bat -l help
    return
  fi

  if [[ $words =~ " (info) " ]]; then
    echo "\$ flatpak info $word"
    flatpak info $word | bat -pl yaml
  fi
fi

# e.g. dnf install fedora PACKAGE
if [[ $level = 3 ]]; then
  if [[ $words =~ " (install|remote-info) " ]]; then
    local remote=$(echo $words | awk '{print $3}')

    echo "\$ flatpak remote-ls $remote | grep "$word"" | bat -pl bash
    flatpak remote-ls $remote | grep "$word"
    echo
    echo "\$ flatpak remote-info $remote $word" | bat -pl bash
    flatpak remote-info $remote $word | bat -pl yaml
  fi
fi
