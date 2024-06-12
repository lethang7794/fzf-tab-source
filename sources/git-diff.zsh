# :fzf-tab:complete:git-(diff|cherry-pick):argument-rest
# case $group in
# 'tree file')
#   less ${realpath#--*=}
#   ;;
# *)
#   :
#   ;;
# esac

if [ "$(command -v diff-so-fancy)" ]; then
  git diff $realpath | diff-so-fancy
else
  git diff --color $realpath
fi

## delta wrap features is hard to read
# git diff $realpath | delta --side-by-side
