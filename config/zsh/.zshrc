# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M$(tty | sed 's/\/dev\/pts\//-/') %{$fg[magenta]%}%2~%{$fg[red]%}]%{$reset_color%}$%b "

# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/zsh/shortcutrc" ] && source "$HOME/.config/zsh/shortcutrc"
[ -f "$HOME/.config/zsh/aliasrc" ] && source "$HOME/.config/zsh/aliasrc"

# History in cache directory:
HISTSIZE=40000
SAVEHIST=40000
HISTFILE=~/.config/zsh/history

export HISTIGNORE="ls:ps:history"

#plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/fzf/key-bindings.zsh 
source /usr/share/fzf/completion.zsh

setopt interactive_comments # comments in cli

#user
export VISUAL=nvim
export EDITOR=nvim
export PATH="$PATH:$(du ~/snl | cut -f2 | tr '\n' ':' | sed 's/:*$//')"
#eval "$(zoxide init zsh)"

# Firefox hardware video acceleration. libva-nvidia-driver.
#export MOZ_DISABLE_RDD_SANDBOX=1
#export LIBVA_DRIVER_NAME=nvidia
