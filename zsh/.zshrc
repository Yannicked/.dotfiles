# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/yannick/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Zinit plugin manager (submodule)
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

# fish-like features
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search

zinit ice as"program" from"gh-r" pick"zsh-patina-*/zsh-patina" atload'eval "$(zsh-patina activate)"'
zinit light michel-kraemer/zsh-patina

export SSH_ASKPASS="/usr/bin/ksshaskpass"
export GIT_ASKPASS="/usr/bin/ksshaskpass"

prompt_newline='%666v '
PROMPT=" $PROMPT"
