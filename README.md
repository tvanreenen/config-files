# Config Files

My macOS dotfiles and coding-agent playbook, versioned as [GNU Stow](https://www.gnu.org/software/stow/) packages.

This repository combines workstation configuration with reusable agent guidance: global Codex instructions and focused skills for architecture, UI design, code review, pull requests, technical communication, and decision-making.

The agent configuration reflects how I want coding agents to work: understand the repository before changing it, ground technical decisions in current primary documentation, integrate with the existing architecture, and verify observable behavior.

## Agent playbook

The `codex` package installs [global Codex instructions](codex/.codex/AGENTS.md) at `~/.codex/AGENTS.md`. The `agents` package installs reusable skills under `~/.agents/skills`. Keeping them separate allows the baseline instructions and task-specific skills to be installed independently.

Most skills here are original to this repository. They grew from repeated behavioral steering in real agent workflows, with selected ideas adapted from other published skills. Treat them as examples for shaping your own workflows: observe where an agent needs guidance and prefer concise behavioral cues over restating capabilities the model already has.

### Skills

#### Plan and design

- [`$pressure-test`](agents/.agents/skills/pressure-test/SKILL.md) — Challenge a plan or decision to expose assumptions and resolve consequential tradeoffs.
- [`$review-architecture`](agents/.agents/skills/review-architecture/SKILL.md) — Find and evaluate evidence-backed architectural improvements.
- [`$design-architecture`](agents/.agents/skills/design-architecture/SKILL.md) — Design or refactor module responsibilities, interfaces, seams, and dependencies.
- [`$design-ui`](agents/.agents/skills/design-ui/SKILL.md) — Design production-quality web interfaces that fit the product and its existing design system.

#### Review and delivery

- [`$prepare-pr`](agents/.agents/skills/prepare-pr/SKILL.md) — Draft or revise a self-contained PR narrative and publish it when requested.
- [`$manage-stack`](agents/.agents/skills/manage-stack/SKILL.md) — Use GitHub's stack-aware workflow to create, sync, rebase, and merge dependent PRs.
- [`$triage-findings`](agents/.agents/skills/triage-findings/SKILL.md) — Validate and scope code-review findings before deciding what to address, defer, or decline.

#### Communication

- [`$write-in-ste`](agents/.agents/skills/write-in-ste/SKILL.md) — Rewrite selected conversational content in clean, direct ASD-STE100 Simplified Technical English.
- [`$remove-ai-tells`](agents/.agents/skills/remove-ai-tells/SKILL.md) — Remove recognizable AI prose signatures without replacing the writer's voice.

## Stow packages

| Package | Configuration |
| --- | --- |
| `agents` | Reusable [agent skills](agents/.agents/skills) |
| `codex` | Global [Codex instructions](codex/.codex/AGENTS.md) |
| `frame` | [Frame](https://github.com/tvanreenen/frame) window manager |
| `ghostty` | [Ghostty](https://github.com/ghostty-org/ghostty) terminal |
| `nvim` | [Neovim](https://neovim.io/) editor |
| `sketchybar` | [SketchyBar](https://github.com/FelixKratz/SketchyBar) status bar |
| `starship` | [Starship](https://starship.rs/) shell prompt |
| `zshrc` | [Zsh](https://www.zsh.org/) shell configuration |

## Package management

The [Brewfile](Brewfile) declares command-line tools and macOS applications installed with [Homebrew Bundle](https://docs.brew.sh/Brew-Bundle-and-Brewfile).

## Installation

This is a personal configuration repository. Review the packages and existing files in your home directory before linking the complete setup.

Install [Homebrew](https://brew.sh/), clone the repository, and install the declared dependencies and all Stow packages:

```sh
git clone https://github.com/tvanreenen/config-files.git
cd config-files
brew bundle
just stow
```

To install only the agent skills and Codex instructions after installing GNU Stow:

```sh
stow agents
stow codex
```

Individual workstation packages can be linked in the same way, such as `stow nvim`. The repository's `.stowrc` targets the home directory. Run `just --list` to see the remaining setup helpers.

## Machine-specific operations

- [Cloudflare Tunnel service setup and upgrades](docs/cloudflare-tunnel.md)
