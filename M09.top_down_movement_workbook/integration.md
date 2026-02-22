# Claude Code - JetBrains Rider Integration

## Installation

1. Go to **Settings > Plugins**
2. Search for "Claude Code" and install the beta plugin
3. Restart Rider
4. Make sure the Claude Code CLI is already installed

## Usage

- **Cmd+Esc** — Launch Claude Code as a tool window inside Rider
- **Cmd+Option+K** — Insert file references (`@filename#L1-99`) into prompts
- `/ide` — Run from an external terminal to connect to your open Rider instance

## Features

- Automatic selection context sharing from the editor
- Code changes displayed in Rider's diff viewer
- Auto-sharing of diagnostic errors (lint, syntax issues)
- File reference shortcuts for attaching files to prompts

## Configuration

Go to **Settings > Tools > Claude Code [Beta]** to configure the Claude command path and other options.

## Troubleshooting

If **Esc** doesn't work to interrupt Claude, go to **Settings > Tools > Terminal** and uncheck "Move focus to the editor with Escape".
