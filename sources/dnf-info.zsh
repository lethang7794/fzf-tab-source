# :fzf-tab:complete:dnf-(info|install|reinstall|remove|upgrade|downgrade|list|swap):
dnf -C info $word | bat -pl yaml
