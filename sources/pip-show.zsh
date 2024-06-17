# :fzf-tab:complete:(\\|*/|)pip-:*

echo \$ pip show $word
pip show $word | bat -lyaml
