# :fzf-tab:complete:(\\|*/|)yq:*

# Skip the options
if [[ $word == "-"* ]]; then
  return
elif [[ $group == "completions" ]]; then
  echo \$ yq $word --help
  yq $word --help
else
  debug
fi
