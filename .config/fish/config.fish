source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
alias dot='git --git-dir=/home/neorcage/.dotfiles/ --work-tree=/home/neorcage'
set last_dot_commit (git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME log -1 --format="%cr" 2>/dev/null)
echo "dotfiles last updated: $last_dot_commit"

set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
pyenv init - | source
