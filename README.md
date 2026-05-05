# Kali-Clean

Stock-ish Kali i3 setup: i3 + i3blocks, Alacritty (Tokyo Night), tmux, rofi, oh-my-zsh.

## Installation

```
./install.sh
```

Run as a regular (non-root) user. After it finishes, reboot and pick **i3** in the top-right of the login screen.

## What's included

- `.config/i3/config` — i3 window manager, bar at the bottom, DejaVu Sans Mono.
- `.config/i3status/config` — status bar (tun0 / battery / disk / load / memory / clock).
- `.config/alacritty/alacritty.toml` — Tokyo Night palette.
- `.config/tmux/tmux.conf` — minimal status line.
- `.config/rofi/config` — launcher config.
- `.zshenv` — sets `skip_global_compinit=1` so Kali's `/etc/zsh/zshrc` doesn't run `compinit` before oh-my-zsh runs its own. Cuts shell startup roughly 5× (260ms → 50ms on a measured run).
- `alias sane='stty sane'` (appended to `~/.zshrc` by `install.sh`) — `impacket-psexec` / `wmiexec` / `smbexec` put the local TTY in raw mode and don't restore it on Ctrl-C or unclean exit, after which `sudo` and Python `getpass` prompts hang on Enter. Type `sane` blind, hit Enter, fixed.

## Optional: lazy-load pyenv / goenv

If you install pyenv or goenv later, **don't** use the standard init lines (`eval "$(pyenv init -)"`) — each one adds ~100ms to every new shell. Instead, append this to the bottom of `~/.zshrc`:

```zsh
export GOENV_ROOT="$HOME/.goenv"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$GOENV_ROOT/bin:$PYENV_ROOT/bin:$GOENV_ROOT/shims:$PYENV_ROOT/shims:$PATH"

goenv() { unset -f goenv; eval "$(command goenv init -)"; goenv "$@"; }
pyenv() { unset -f pyenv; eval "$(command pyenv init -)"; pyenv "$@"; }
```

The shims stay on `$PATH` so `python` and `go` work instantly; the slow `init` only runs the first time you actually invoke `pyenv` or `goenv` themselves.

## Benchmarking shell startup

```
for i in 1 2 3 4 5; do { time zsh -i -c exit; } 2>&1 | grep total; done
```

Profile what's slow:

```
zsh -ic 'zmodload zsh/zprof; source ~/.zshrc; zprof | head -20'
```
