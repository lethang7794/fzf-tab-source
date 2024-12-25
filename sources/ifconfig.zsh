# :fzf-tab:complete:(\\|*/|)ifconfig:*

# Trim trailing whitespace
local word=$(echo $word | xargs)

ifconfig $word | bat -lbash