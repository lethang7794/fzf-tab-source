# :fzf-tab:complete:(-command-:|command:option-(v|V)-rest)
case $group in
'external command')
  if bash -c "tldr $word" 1>/dev/null 2>&1; then
    cat <(echo "\$ tldr $word") <(eval "tldr --color=always $word")
  elif bash -c "$word --help" 1>/dev/null 2>&1; then
    bat -pl help <(echo "\$ $word --help") <(eval "$word --help")
  elif bash -c "$word -h" 1>/dev/null 2>&1; then
    bat -pl help <(echo "\$ $word -h") <(eval "$word -h")
    # eval "$word -h" | bat -pl help
  elif bash -c "$word help" 1>/dev/null 2>&1; then
    bat -pl help <(echo "\$ $word help") <(eval "$word help")
    # eval "$word help" | bat -pl help
  else
    bat -lman <(echo \$ man $word) <(man $word 2>/dev/null)
  fi
  ;;
'executable file')
  less ${realpath#--*=}
  ;;
'builtin command')
  cmd="/usr/share/zsh/$ZSH_VERSION/help/$word"
  if [ -f $cmd ]; then
    bat -lman <(echo "# $cmd") $cmd
  elif bash -c "help $word" 1>/dev/null 2>&1; then
    bat <(echo \$ help $word) <(bash -c "help $word")
  else
    bat -lman <(echo \$ man $word) <(run-help $word)
  fi
  ;;
parameter)
  echo ${(P)word}
  ;;
alias)
  # alias is not inherited, cannot access them here
  ;;
'reserved word')
  rw=$(info bash Indexes "Reserved Word Index" | grep "* $word:" | awk '{print $2,$3}')
  echo $rw "\n\nSee https://www.gnu.org/software/bash/manual/html_node/Reserved-Word-Index.html#Reserved-Word-Index_rw_symbol-2"
  ;;
'shell function')
  # Print default zsh shell functions
  func="/usr/share/zsh/$ZSH_VERSION/functions/$word"
  if [ -f $func ]; then
    bat -lman <(echo "# $func") $func
  fi
  ;;
esac
