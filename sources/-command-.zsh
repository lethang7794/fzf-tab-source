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
    man $word 2>/dev/null | bat -lman
  fi
  ;;
'executable file')
  less ${realpath#--*=}
  ;;
'builtin command')
  if [ -f "/usr/share/zsh/$ZSH_VERSION/help/$word" ]; then
    bat -lman "/usr/share/zsh/$ZSH_VERSION/help/$word"
  elif bash -c "help $word" 1>/dev/null 2>&1; then
    bash -c "help $word" | bat -lman
  else
    run-help $word | bat -lman
  fi
  ;;
parameter)
  echo ${(P)word}
  ;;
'shell function')
  # TODO: Is there any way to print out the shell function?
  ;;
esac
