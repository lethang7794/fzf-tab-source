# :fzf-tab:complete:((\\|*/|)gem:argument-rest|gem-help:)
echo "$ gem help $word" | bat -pl bash
gem help $word | bat -lhelp
