# ————————————————————————————————————————————————————————————————
# PATH & Environment Setup
# ————————————————————————————————————————————————————————————————

# ————————————————————————————————————————————————————————————————
# Homebrew
# - Use brew's official shellenv to set PATH, MANPATH, INFOPATH, etc.
# ————————————————————————————————————————————————————————————————
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export HOMEBREW_NO_ENV_HINTS=1
fi

# ————————————————————————————————————————————————————————————————
# Personal tools (~/.local/bin)
# - Common home for per-user binaries (e.g., uv, uvx, cursor-agent).
# - Put early in PATH so your tools override system defaults when needed.
# ————————————————————————————————————————————————————————————————
export PATH="$HOME/.local/bin:$PATH"

# ————————————————————————————————————————————————————————————————
# Bun
# - JavaScript runtime, package manager, and bundler.
# - Adds bun to PATH and loads shell completions if available.
# ————————————————————————————————————————————————————————————————
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "/Users/tim.vanreenen/.bun/_bun" ] && source "/Users/tim.vanreenen/.bun/_bun"

# ————————————————————————————————————————————————————————————————
# Google Cloud SDK
# - Updates PATH and enables shell command completion for gcloud.
# - Only loads if the SDK is installed at the expected location.
# ————————————————————————————————————————————————————————————————
if [ -f '/Users/tim.vanreenen/Code/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/tim.vanreenen/Code/google-cloud-sdk/path.zsh.inc'; fi
if [ -f '/Users/tim.vanreenen/Code/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/tim.vanreenen/Code/google-cloud-sdk/completion.zsh.inc'; fi

# ————————————————————————————————————————————————————————————————
# Completion System Setup
# ————————————————————————————————————————————————————————————————

# ————————————————————————————————————————————————————————————————
# Completion search paths (fpath)
# - Add all completion directories to fpath before compinit runs.
# - Order matters: more specific completions should come first.
# ————————————————————————————————————————————————————————————————

# Homebrew site-functions (completions for git, just, kubectl, etc.)
if [[ -x /opt/homebrew/bin/brew ]]; then
  fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
fi

# Docker Desktop completions
if [[ -d "$HOME/.docker/completions" ]]; then
  fpath=("$HOME/.docker/completions" $fpath)
fi

# zsh-completions (additional completions)
# - Community-maintained collection of completion scripts for commands
#   that don't ship with completions or need improved completions.
if type brew &>/dev/null && [[ -d "$(brew --prefix)/share/zsh-completions" ]]; then
  fpath=("$(brew --prefix)/share/zsh-completions" $fpath)
fi

# ————————————————————————————————————————————————————————————————
# zsh completion system initialization
# - fpath: search path for zsh functions & completions.
# - De-duplicate, then initialize once.
# - compinit:
#     -i → ignore insecure directories instead of aborting.
#     -C → skip rebuilding the cache if it's still valid (faster startup).
# - ZSH_COMPDUMP stores the compiled completions cache; versioned for safety.
# ————————————————————————————————————————————————————————————————
typeset -U fpath
ZSH_COMPDUMP="${ZSH_COMPDUMP:-$HOME/.zsh/.zcompdump-$ZSH_VERSION}"
autoload -Uz compinit
compinit -i -C

# ————————————————————————————————————————————————————————————————
# Completion cache & matcher options
# - Enable caching and ensure the cache directory exists.
# - matcher-list enables case-insensitive & word-boundary completion.
# ————————————————————————————————————————————————————————————————
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zsh/cache"
[[ -d "$HOME/.zsh/cache" ]] || mkdir -p "$HOME/.zsh/cache"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ————————————————————————————————————————————————————————————————
# Aliases
# ————————————————————————————————————————————————————————————————

alias ls='ls -G'
alias ll='ls -lhG'
alias la='ls -lahG'
alias cl='clear'

# ————————————————————————————————————————————————————————————————
# Interactive Shell Features
# ————————————————————————————————————————————————————————————————

# ————————————————————————————————————————————————————————————————
# Starship prompt
# - Cross-shell prompt that displays git status, language versions, and more.
# - Fast, customizable, and works across different shells.
# - Configuration file: ~/.config/starship.toml (auto-created on first run).
# - Only loads in interactive shells.
# ————————————————————————————————————————————————————————————————
if [[ $- == *i* ]] && command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# ————————————————————————————————————————————————————————————————
# fzf integration (dynamic)
# - Runs only in interactive shells.
# - Adds key bindings:
#   - Ctrl-R: Fuzzy search command history
#   - Ctrl-T: Fuzzy file finder (insert file path into command)
#   - Alt-C: Fuzzy directory changer (cd into selected directory)
# - Enables fuzzy completion support for tab completion.
# - Uses `fzf --zsh` dynamically so it always matches your installed version.
# ————————————————————————————————————————————————————————————————
if [[ $- == *i* ]] && command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# (Optional) customize fzf interface — nice defaults
# export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline"

# ————————————————————————————————————————————————————————————————
# zsh-vi-mode
# - Enhanced vi mode for zsh with better key bindings and features.
# - Provides improved vim-like editing experience in the command line.
# - Must be loaded before zsh-autosuggestions and zsh-syntax-highlighting.
# ————————————————————————————————————————————————————————————————
if [[ -f /opt/homebrew/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]]; then
  source /opt/homebrew/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
fi

# ————————————————————————————————————————————————————————————————
# zsh-autosuggestions
# - Suggests commands as you type based on history and completions.
# - Accept entire suggestion:
#     * Insert mode: Right arrow (→) or End key
#     * Normal mode: 'l' or Right arrow (→) - note: may stay in normal mode
# - Accept one word at a time: Ctrl+Right arrow (→) in insert mode
# - Partial accept: Ctrl+Right arrow in insert mode
# - Must be loaded before zsh-syntax-highlighting.
# ————————————————————————————————————————————————————————————————
if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# ————————————————————————————————————————————————————————————————
# zsh-syntax-highlighting
# - Provides real-time syntax highlighting for commands.
# - Colors valid commands, paths, and highlights errors.
# - Must be loaded last (after all other plugins).
# ————————————————————————————————————————————————————————————————
if [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
