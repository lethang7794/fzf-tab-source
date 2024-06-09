# :fzf-tab:complete:(\\|*/|)brew:argument-1

if bash -c "tldr $word" 1>/dev/null 2>&1; then
  cat <(echo "\$ tldr $word") <(eval "tldr --color=always $word") <(echo)
  hr
fi

cat <(echo "\$ brew $word --help") <(eval "brew $word --help")
