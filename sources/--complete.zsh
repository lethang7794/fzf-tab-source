# :fzf-tab:complete:*
# `${realpath#--*=}` aims to handle `--long-option=/the/path/of/a/file`
# file=${realpath#--*=}
# echo $file
# bat $file 2>/dev/null || less $file

# file=${realpath#--*=}
# if [ -d $file ]; then
#   tree -C -L 1 $file
# else
#   bat --style=header,header-filesize "$file"
# fi

file=${realpath#--*=}
mime=$(file -bL --mime-type "$file")
category=${mime%%/*}
kind=${mime##*/}
if [ -d "$file" ]; then
  # tree -C -L 1 $file
  eza --git -h --color=always --icons "$file" --tree --level=1
elif [ "$category" = image ]; then
  echo "$file"
  # yes '' | sed "$((FZF_PREVIEW_LINES - 1))q"
  kitten icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x$((FZF_PREVIEW_LINES - 1))@0x0 $file
  # exiftool "$file"
elif [[ "$kind" == *"vnd.openxmlformats-officedocument.spreadsheetml.sheet" ]] ||
  [[ "$kind" == *"vnd.ms-excel" ]]; then
  in2csv "$file" | xsv table | bat -ltsv --color=always
elif [ "$category" = text ]; then
  # bat --color=always "$file"
  bat --color=always --style=header "$file"
else
  lesspipe.sh "$file" | bat --color=always
fi
