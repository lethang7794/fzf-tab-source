# :fzf-tab:complete:(\\|*/|)just:*

case $group in
'just commands')
  just -n --color=never $word | bat -pl Makefile
  ;;
'variables')
  just --evaluate $word | bat -pl bash
  ;;
file)
  less ${realpath#--*=}
  ;;
esac
