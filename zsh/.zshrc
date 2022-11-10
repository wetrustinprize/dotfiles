# p10k stuff
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to oh-my-zsh installation
export ZSH=$HOME/.oh-my-zsh

# My visual code editor
export VISUAL=code

# My default code editor
export EDITOR="$VISUAL"

# Alias
  # Better SUDO
  alias sudo='nocorrect sudo -E '

# Custom paths
  ## Yarn bin
  export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

  ## Local bin
  export PATH="$HOME/.local/bin:$PATH"

  ## Vulkan stuff
  export VK_ICD_FILENAMES="/usr/share/vulkan/icd.d/nvidia_icd.json"

# Plugins
plugins=(git)
plugins=(asdf)

source $ZSH/oh-my-zsh.sh

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# Zinit plugins
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light rupa/z
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

[ -f "/home/wetrustinprize/.ghcup/env" ] && source "/home/wetrustinprize/.ghcup/env" # ghcup-envexport PATH=$PATH:/home/wetrustinprize/.spicetify