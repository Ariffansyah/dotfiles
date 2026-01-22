# --- 1. Environment Variables ---
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin:$HOME/.config/composer/vendor/bin:$HOME/.bun/bin:/home/arp/.dotnet/tools:$PATH"
export BUN_INSTALL="$HOME/.bun"
export LIBVIRT_DEFAULT_URI="qemu:///system"
export GEMINI_API_KEY="" # Add your key here if needed
export NODE_EXTRA_CA_CERTS="$HOME/.local/share/mkcert/rootCA.pem"

# --- 2. Plugin Manager (Antigen) ---
source ~/.antigen.zsh

antigen use oh-my-zsh

antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
# Note: manual command_not_found_handler is used below, so no antigen bundle needed here
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

antigen apply

# --- 3. Prompt (Starship) ---
# We use Starship instead of 'antigen theme robbyrussell'
eval "$(starship init zsh)"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- 4. Custom Functions ---

# Arch Linux Command Not Found Handler
function command_not_found_handler {
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"
    local entries=( ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1" 2>/dev/null)"} )
    if (( ${#entries[@]} )) ; then
        printf "${bright}$1${reset} may be found in the following packages:\n"
        local pkg
        for entry in "${entries[@]}" ; do
            local fields=( ${(0)entry} )
            if [[ "$pkg" != "${fields[2]}" ]]; then
                printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%s\n' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
    return 127
}

# AUR Helper Detection & Installer
if pacman -Qi yay &>/dev/null; then
   aurhelper="yay"
elif pacman -Qi paru &>/dev/null; then
   aurhelper="paru"
fi

function in {
    local -a inPkg=("$@")
    local -a arch=()
    local -a aur=()
    for pkg in "${inPkg[@]}"; do
        if pacman -Si "${pkg}" &>/dev/null; then
            arch+=("${pkg}")
        else
            aur+=("${pkg}")
        fi
    done
    [[ ${#arch[@]} -gt 0 ]] && sudo pacman -S "${arch[@]}"
    [[ ${#aur[@]} -gt 0 ]] && ${aurhelper} -S "${aur[@]}"
}

# --- 5. Aliases ---
alias c='clear'
alias l='eza -lh --icons=auto'
alias ls='eza -1 --icons=auto'
alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
alias ld='eza -lhD --icons=auto'
alias lt='eza --icons=auto --tree'
alias un='$aurhelper -Rns'
alias up='$aurhelper -Syu'
alias pl='$aurhelper -Qs'
alias pa='$aurhelper -Ss'
alias pc='$aurhelper -Sc'
alias po='$aurhelper -Qtdq | $aurhelper -Rns -'
alias vc='code'
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'

alias winup='podman-compose --file ~/winapps/compose.yaml up'
alias windown='podman-compose --file ~/winapps/compose.yaml down'
alias winrestart='podman-compose --file ~/winapps/compose.yaml restart'
alias mkdir='mkdir -p'

# --- 6. Tool Completions & Init ---
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# LAZYGIT - Use multiple config files
export LG_CONFIG_FILE="$HOME/.config/lazygit/lazycommit/config.yml,\
$HOME/.config/lazygit/config.yml"

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
