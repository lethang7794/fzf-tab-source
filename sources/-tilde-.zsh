# :fzf-tab:complete:-tilde-:
case $group in
user)
  finger $word | bat -pl bash
  ;;
esac
