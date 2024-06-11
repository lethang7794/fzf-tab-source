# :fzf-tab:complete:git-(diff|cherry-pick):argument-rest
case $group in
'tree file')
  less ${realpath#--*=}
  ;;
*)
  if [ "$(command -v delta)" ]; then
    git diff $realpath | delta --diff-so-fancy
  else
    git diff --color $realpath
  fi
  ;;
esac
