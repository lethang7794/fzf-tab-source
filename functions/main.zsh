# define some functions to avoid any error that these programs don't exist
(($+commands[bat])) || bat() {command cat $@}
(($+commands[mdcat])) || mdcat() {command cat $@}
(($+commands[pygmentize])) || pygmentize() {command cat $@}
(($+commands[delta])) || delta() {command cat $@}
# https://github.com/Freed-Wu/fzf-tab-source/issues/6
(($+commands[less])) && [ -x ~/.lessfilter ] &&
  less() {~/.lessfilter $@ || command less $@} || (($+commands[less])) ||
    less() {command ls -l $@}
(($+commands[finger])) || (($+commands[pinky])) &&
  finger() {command pinky $@} || finger() {command whoami}
(($+commands[pandoc])) || pandoc() {command cat ${@[-1]}}
(($+commands[grc])) || grc() {eval ${@[2,-1]}}
(($+commands[jq])) || jq() {echo ';'}
if ((! $+commands[emojify])); then
  (($+commands[pyemojify])) && emojify() {command pyemojify $@} ||
    emojify() {perl -pe' '$([ -f ~/.gitmoji/gitmojis.json ] && ${src:h:h}/bin/gitmoji.jq ~/.gitmoji/gitmojis.json || :)}
fi

# dictionary $ZINIT cannot be passed
PLUGINS_DIR=${ZINIT[PLUGINS_DIR]}

. $src
