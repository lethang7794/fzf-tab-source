# :fzf-tab:complete:(-command-:|command:option-(v|V)-rest)

echo_bash() {
  echo $@ | bat -pl bash
}

tldr-similar() {
  word=$1
  raw=$(tldr --raw --quiet "$word")
  seeAlsoOrSimilarCount=$(echo "$raw" | grep -c -E "See also|Similar to")
  if ((seeAlsoOrSimilarCount > 0)); then
    local seeAlsoOrSimilar
    seeAlsoOrSimilar=$(echo "$raw" | grep -a -E 'See also|Similar to')
    # echo $seeAlsoOrSimilar | grep -oP '`([^`]+)`' | tr -d '`' | xargs -I{} tldr --color=always {} | tail -n +2 | head -n 6 | sed 's/^/  /'
    echo "$seeAlsoOrSimilar" | grep -oP "\`([^\`]+)\`" | sed -E "s/tldr |\`//g" | xargs -I{} sh -c 'tldr --color=always --quiet {} | tail -n +2 | head -n 5 | gum style --border double --padding "1 2"'
  fi
}

case $group in
'external command')
  if bash -c "tldr $word" 1>/dev/null 2>&1; then
    echo_bash "\$ tldr $word"
    eval "tldr --color=always --quiet $word" | tail -n +3
    tldr-similar "$word"
  fi
  if bash -c "$word --help" 1>/dev/null 2>&1; then
    echo_bash "\$ $word --help"
    eval "$word --help" | bat -pl help
  elif bash -c "$word -h" 1>/dev/null 2>&1; then
    echo_bash "\$ $word -h"
    eval "$word -h" | bat -pl help
  elif bash -c "$word help" 1>/dev/null 2>&1; then
    echo_bash "\$ $word help"
    eval "$word help" | bat -pl help
  fi
  echo; echo_bash \$ man $word
  manpage=$(man $word 2>/dev/null)
  if [[ $manpage == "" ]]; then
    echo "No manual entry for $word"
  else
    echo $manpage | head -n 20 | bat -lman
    printf "\n(...)\n\n"
    echo "For more details run 'man $word'"
  fi
  ;;
'executable file')
  less ${realpath#--*=}
  ;;
'builtin command')
  cmd_help_file="/usr/share/zsh/$ZSH_VERSION/help/$word"
  if [ -f $cmd_help_file ]; then
    echo "$ cat $cmd_help_file"
    bat -lman <(echo "# $cmd_help_file" | tail -n +2) $cmd_help_file
    
    section=$(cat "$cmd_help_file" | grep "See the section" | grep -oP "\`\K[^']+")
    zsh_topic=$(cat "$cmd_help_file" | grep "See the section" | grep -oP "(?<=in )\w+")

    if [[ -n "${zsh_topic}" ]]; then
      echo; echo "$ man $zsh_topic"
      man $zsh_topic | bat -l man
    fi

  elif bash -c "help $word" 1>/dev/null 2>&1; then
    bat <(echo_bash \$ help $word) <(bash -c "help $word")
  else
    bat -lman <(echo_bash \$ man $word) <(run-help $word)
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
  bat <(echo $rw "\n") <(bash -c "help $word" 2>/dev/null) 
  echo "\nSee https://www.gnu.org/software/bash/manual/html_node/Reserved-Word-Index.html#Reserved-Word-Index_rw_symbol-2"
  ;;
'shell function')
  # Print default zsh shell functions
  func="/usr/share/zsh/$ZSH_VERSION/functions/$word"
  if [ -f $func ]; then
    bat -lman <(echo "# $func") $func
  fi
  ;;
esac
