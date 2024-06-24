# :fzf-tab:complete:(\\|*/|)mod(info|probe):argument-1
case $group in
'module file')
  [[ -f $realpath ]] && modinfo $realpath | bat -lyaml || less $realpath
  ;;
module(|' alias'))
  modinfo "$word" | bat -lyaml
  ;;
esac
