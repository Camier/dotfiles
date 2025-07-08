# Setup fzf
# ---------
if [[ ! "$PATH" == */home/miko/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/miko/.fzf/bin"
fi

source <(fzf --zsh)
