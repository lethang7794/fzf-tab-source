# :fzf-tab:complete:mise:*

# Skip the option
if [[ $word == --* ]]; then
  return
fi

# Workaround: Detect mise alias CMD
if [[ $desc == *alias* && ! $desc == *"Manage aliases" ]]; then
  echo "$ mise alias $word --help"
  mise alias $word --help | bat -pl help
  return
fi

# Workaround: Detect mise backends CMD
if [[ $desc == *backend* && ! $desc == *"Manage backends" ]]; then
  echo "$ mise backends $word --help"
  mise backends $word --help | bat -pl help
  return
fi

# Workaround: Detect mise cache CMD
if [[ $desc == *cache* && ! $desc == *"Manage the mise cache" ]]; then
  echo "$ mise cache $word --help"
  mise cache $word --help | bat -pl help
  return
fi

# Workaround: Detect mise config CMD

# Workaround: Detect mise plugins
if [[ $desc == *plugin* && ! $desc == *"Manage plugins" && ! $desc == *"latest"* ]]; then
  echo "$ mise plugins $word --help"
  mise plugins $word --help | bat -pl help
  return
fi

if bash -c "mise $word --help" 1>/dev/null 2>&1; then
  echo "$ mise $word --help"
  mise $word --help | bat -pl help
fi
