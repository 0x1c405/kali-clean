#!/bin/bash

sudo apt update && sudo apt upgrade -y

sudo apt install -y i3 i3status alacritty tmux rofi flameshot arandr feh thunar unclutter xclip wget curl git

mkdir -p ~/.config/i3
mkdir -p ~/.config/i3status
mkdir -p ~/.config/rofi
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/tmux

cp .config/i3/config ~/.config/i3/config
cp .config/i3/clipboard_fix.sh ~/.config/i3/clipboard_fix.sh
cp .config/i3status/config ~/.config/i3status/config
cp .config/rofi/config ~/.config/rofi/config
cp .config/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
cp .config/tmux/tmux.conf ~/.config/tmux/tmux.conf
cp .zshenv ~/.zshenv

# TPM (tmux plugin manager) — required by tmux.conf
[ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Append pentest QoL aliases to .zshrc (idempotent)
grep -q "alias sane=" ~/.zshrc 2>/dev/null || cat >> ~/.zshrc <<'EOF'

# Restore TTY after tools (impacket-psexec, etc.) leave it in raw mode
alias sane='stty sane'
EOF

echo "Done. Reboot and pick i3 at the login screen."
echo "Inside tmux, press 'prefix + I' to install plugins (prefix = Ctrl-b by default)."
