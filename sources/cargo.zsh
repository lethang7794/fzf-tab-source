# :fzf-tab:complete:(\\|*/|)cargo:argument-1

if bash -c "tldr cargo-${word}" 1>/dev/null 2>&1; then
  cat <(echo "\$ tldr cargo-${word}") <(eval "tldr --color=always cargo-${word}")
else
  cargo help $word | bat -lhelp
fi
