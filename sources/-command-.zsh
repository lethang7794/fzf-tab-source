# :fzf-tab:complete:(-command-:|command:option-(v|V)-rest)
case $group in
'external command')
  if bash -c "tldr $word" 2>/dev/null; then
    eval "tldr $word"
  elif bash -c "$word --help" 2>/dev/null; then
    eval "$word --help" | bat -pl help
  elif bash -c "$word -h" 2>/dev/null; then
    eval "$word -h" | bat -pl help
  elif bash -c "$word help" 2>/dev/null; then
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
