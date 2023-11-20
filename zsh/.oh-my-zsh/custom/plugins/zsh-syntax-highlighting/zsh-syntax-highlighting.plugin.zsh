# This is ugly, my shell skills suck, but it is way too late to google this right now.
# I will come back and fix this, surely. Soon. Note created: November 2023.
if (( ${+ZSH_PLUGIN_ZSH_SYNTAX_HIGHLIGHTING} )); then
    source "${ZSH_PLUGIN_ZSH_SYNTAX_HIGHLIGHTING}"
elif [[ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ -f "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
