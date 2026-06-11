export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

autoload -Uz compinit
compinit
alias g='git'
alias lg='lazygit'
alias vim='nvim'
alias ls='eza --icons'
alias ll='eza -lh --icons --git'
alias la='eza -lah --icons --git'
alias tree='eza --tree --icons'
alias cur='cursor'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''

source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH="$HOME/.local/bin:$PATH"
export HOMEBREW_PREFIX=/opt/homebrew
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

eval "$(zoxide init zsh)"
eval "$(~/.local/bin/mise activate zsh)"
eval "$(starship init zsh)"
