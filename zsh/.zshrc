####################
#       P10K       #
####################
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet


####################
#     OH-MY-ZSH    #
####################
export ZSH=$HOME/.oh-my-zsh

####################
#     OH-MY-ZSH    #
#      PLUGINS     #
####################
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
plugins=(git)

source $ZSH/oh-my-zsh.sh

####################
#       ZINIT      #
####################
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

####################
#       ZINIT      #
#      PLUGINS     #
####################
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light rupa/z

zinit ice depth=1; zinit light romkatv/powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

####################
#     BINDINGS     #
####################

export VISUAL=code # My visual code editor
export EDITOR="nevim" # My default code editor

####################
#      PATHS       #
####################
alias sudo='nocorrect sudo -E ' # Better SUDO

####################
#      PATHS       #
####################
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH" ## Yarn bin

export PATH="$HOME/.local/bin:$PATH" ## Local bin

####################
#    AUTO TMUX     #
####################
if [ "$TMUX" = "" ]; then tmux; fi
