# AGY Status

> A live [Google Antigravity CLI (`agy`)](https://antigravity.google) status line for your terminal — context usage, cost, model, mode, sandbox, branch, worktree, and more.

[![CI](https://github.com/agy-contrib/agy-status/actions/workflows/ci.yml/badge.svg)](https://github.com/agy-contrib/agy-status/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/agy-contrib/agy-status)](https://github.com/agy-contrib/agy-status/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Antigravity CLI's `statusLine` command fires whenever agent state changes — piping a JSON payload of session telemetry to `stdin`. `agy-status` turns that stream into a compact, Catppuccin-colored status line matching [`claude-contrib/claude-status`](https://github.com/claude-contrib/claude-status).

## How It Works

Antigravity CLI runs your configured `statusLine` command and pipes session state JSON to `stdin`. `agy-status` parses the payload with `jq` and renders each active segment using 24-bit TrueColor ANSI escape codes, joined into a single line.

> **Requires a TrueColor terminal.** Most modern terminals qualify: Ghostty, Kitty, WezTerm, Alacritty, iTerm2, Warp, and Windows Terminal all work out of the box.

> **Running in a container or over SSH?** Make sure these environment variables are set:
>
> - `LANG=C.UTF-8` — needed for Unicode glyphs (Braille progress bar, Nerd Font icons)
> - `COLORTERM=truecolor` — needed for 24-bit color passthrough

## Requirements

- [Antigravity CLI](https://antigravity.google/docs/install) (`agy`)
- [jq](https://jqlang.github.io/jq/) (`jq`)
- A TrueColor terminal with a Nerd Font

## Installation

### Using zinit

Add to your `~/.zshrc`:

```zsh
zinit light agy-contrib/agy-status
```

### Using Nix flakes

```sh
nix profile install github:agy-contrib/agy-status
```

Or in your `flake.nix` inputs:

```nix
inputs.agy-status.url = "github:agy-contrib/agy-status";
```

### Manual (zsh)

```zsh
git clone https://github.com/agy-contrib/agy-status ~/.local/share/agy-status
echo 'source ~/.local/share/agy-status/agy-status.plugin.zsh' >> ~/.zshrc
source ~/.local/share/agy-status/agy-status.plugin.zsh
```

### Manual (bash)

```bash
git clone https://github.com/agy-contrib/agy-status ~/.local/share/agy-status
echo 'export PATH="$HOME/.local/share/agy-status:$PATH"' >> ~/.bashrc
export PATH="$HOME/.local/share/agy-status:$PATH"
```

### Configure Antigravity CLI

Set the status line command in `~/.gemini/antigravity-cli/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "agy-status"
  }
}
```

## What You Get

Each segment is independently styled and only shown when relevant:

| Segment | Example | Description |
| --- | --- | --- |
| Context bar | `⣿⣿⣿⣿⣀⣀⣀⣀⣀⣀ 42%` | 10-char Braille progress bar + percentage; green → yellow → red at 70%/90% |
| Cost | `$0.42` | Estimated session spend in USD — hidden when omitted |
| Model | `Gemini 4 Neon (High)` | Display name of the active model |
| Agent | `⚡ reviewer` | Active custom agent name — hidden for the default agent |
| Mode | `auto` | Execution mode (`auto`, `accept-edits`, `plan`) — hidden in default mode |
| Sandbox | `󰒃` | Shown while the OS terminal sandbox is active |
| Vim | `NORMAL` | Vim prompt mode — hidden unless `editorMode: "vim"` is enabled |
| Activity | `⚡1 󱑓 2` | Running subagent and background task counts — hidden when idle |
| Directory | `  my-project` | Basename of the current working directory |
| Branch | `  main` | Active git branch (long multi-segment branches shorten to `first/…/last`) |
| Worktree | `󰙅  feature-x` | Active linked git worktree name — hidden outside a worktree |
| Docker | `  docker` | Shown inside Docker containers |
| Nix | `  flake · dev` | Shown inside `nix develop` or `nix-shell` |

## Configuration

| Variable | Values | Default | Description |
| --- | --- | --- | --- |
| `AGY_STATUS_THEME` | `catppuccin-mocha` \| `catppuccin-macchiato` \| `catppuccin-frappe` \| `catppuccin-latte` \| `/path/to/custom.json` | `catppuccin-mocha` | Built-in [Catppuccin](https://catppuccin.com) theme or absolute path to a custom theme JSON file |

```sh
export AGY_STATUS_THEME=catppuccin-latte
```

## License

MIT — use it, fork it, extend it.
