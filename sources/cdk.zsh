# :fzf-tab:complete:((\\|*/|)cdk):*

local prefix="${words% *}"

# Trim trailing whitespace
local word=$(echo $word | xargs)
local cmd="$prefix $word"

echo "$ $cmd --help"
eval "$cmd --help"
