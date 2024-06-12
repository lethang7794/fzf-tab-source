# :fzf-tab:complete:((\\|*/|)git|git-help):argument-1

bold=$(tput bold)
normal=$(tput sgr0)

if bash -c "tldr git $word" >>/dev/null 2>&1; then
  echo "$ tldr ${bold}git $word"
  tldr --color=always git $word | tail -n +3
fi

echo "$ ${bold}git help $word"
git help $word | bat -lhelp
