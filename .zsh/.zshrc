# Language
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Completion
autoload -Uz compinit
compinit -C
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''

# Pure
autoload -U promptinit
promptinit
prompt pure

# Alias
alias g='git'
alias lg='lazygit'
alias vim='nvim'
alias ls='eza --icons'
alias ll='eza -lh --icons --git'
alias la='eza -lah --icons --git'
alias tree='eza --tree --icons'
alias tm='tmux'

# Plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Claude
export CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL=1

# Execute
eval "$(zoxide init zsh)"
eval "$(mise activate zsh)"
