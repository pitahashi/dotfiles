export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

autoload -Uz compinit
autoload -U colors && colors
compinit

autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats ' (%b)'

setopt PROMPT_SUBST
PROMPT='%F{green}%n@%m%f %F{blue}%~%f${vcs_info_msg_0_} 
> '
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

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL=1
eval "$(zoxide init zsh)"
eval "$(mise activate zsh)"
