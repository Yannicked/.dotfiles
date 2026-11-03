HISTFILE=~/.histfile  # sizes are set by OMZL::history.zsh
bindkey -e

# Zinit plugin manager (submodule); plugins/snippets live outside the repo
declare -A ZINIT
ZINIT[HOME_DIR]="$HOME/.local/share/zinit"
source "${ZDOTDIR:-$HOME}/.zinit/zinit.zsh"

# rupa/z - directory jumping
zinit light rupa/z

# sindresorhus/pure - prompt
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

# Oh My Zsh libs
zinit snippet OMZL::git.zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::directories.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::theme-and-appearance.zsh

# Oh My Zsh plugins
zinit snippet OMZP::extract
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zstyle :omz:plugins:ssh-agent lazy yes
zinit snippet OMZP::ssh-agent

# fish-like features
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

zinit light MichaelAquilina/zsh-you-should-use

zinit ice as"program" from"gh-r" pick"zsh-patina-*/zsh-patina" atload'eval "$(zsh-patina activate)" && eval "$(zsh-patina completion)"'
zinit light michel-kraemer/zsh-patina

# Initialize completions after all plugins are loaded
autoload -Uz compinit && compinit
zicdreplay

prompt_newline='%666v '
PROMPT=" $PROMPT"

# Pi
export PATH="$HOME/.pi/agent/bin:$PATH"
