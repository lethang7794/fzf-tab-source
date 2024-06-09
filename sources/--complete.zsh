# :fzf-tab:complete:*
# `${realpath#--*=}` aims to handle `--long-option=/the/path/of/a/file`
file=${realpath#--*=}
if [ -d "$file" ]; then
  echo Folder: ${file}
fi
less $file
