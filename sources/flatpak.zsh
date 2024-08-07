# :fzf-tab:complete:(\\|*/|)flatpak:
# echo $word $group $realpath
# case $group in
# argument)
#   flatpak $word --help
#   ;;
# esac

# Trim trailing whitespace
local word=$(echo $word | xargs)

if [[ "${word}" == *"."* ]]; then
  flatpak info $word | bat -pl yaml
else
  flatpak $word --help
fi
