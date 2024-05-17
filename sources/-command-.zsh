# :fzf-tab:complete:(-command-:|command:option-(v|V)-rest)
case $group in
'external command')
  if bash -c "tldr $word" >>/dev/null 2>&1; then
    eval "tldr --color=always $word"
  elif bash -c "$word --help" >>/dev/null 2>&1; then
    eval "$word --help" | bat -pl help
  elif bash -c "$word -h" >>/dev/null 2>&1; then
    eval "$word -h" | bat -pl help
  elif bash -c "$word help" >>/dev/null 2>&1; then
    eval "$word help" | bat -pl help
  else
    run-help $word | bat -lman
  fi
  ;;
'executable file')
  less ${realpath#--*=}
  ;;
'builtin command')
  run-help $word | bat -lman
  ;;
parameter)
  echo ${(P)word}
  ;;
'shell function')
  # TODO: Is there any way to print out the shell function?
  ;;
esac
