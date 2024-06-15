# :fzf-tab:complete:(\\|*/|)chezmoi:
if bash -c "chezmoi help $word" >/dev/null 2>&1; then
  chezmoi help $word | bat -pl help
fi
