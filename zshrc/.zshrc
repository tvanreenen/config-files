# ————————————————————————————————————————————————————————————————
# PATH & Environment Setup
# ————————————————————————————————————————————————————————————————

# ————————————————————————————————————————————————————————————————
# Homebrew
# - Use brew's official shellenv to set PATH, MANPATH, INFOPATH, etc.
# ————————————————————————————————————————————————————————————————
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
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

# ————————————————————————————————————————————————————————————————
# Interactive Shell Features
# ————————————————————————————————————————————————————————————————

# ————————————————————————————————————————————————————————————————
# Vim key bindings
# - Enable vi mode for command-line editing (insert mode by default).
# - Press ESC to enter normal mode, 'i' or 'a' to return to insert mode.
# - In normal mode: h/j/k/l for navigation, 'A' to append at end, etc.
# - Cursor changes: block cursor in normal mode, line cursor in insert mode.
# ————————————————————————————————————————————————————————————————
bindkey -v

# Reduce escape key delay (KEYTIMEOUT is in 1/100 of a second)
# Setting to 1 means 10ms wait time for multi-character sequences
# This makes ESC key response nearly instantaneous
KEYTIMEOUT=1

# Fix ESC key behavior in vicmd mode
# Without this, pressing ESC multiple times can cause issues
noop() { }
zle -N noop
bindkey -M vicmd '\e' noop

# History search bindings (vi-style)
# / for forward search, ? for backward search
bindkey -M vicmd '/' history-incremental-search-forward
bindkey -M vicmd '?' history-incremental-search-backward

# Edit command line in external editor (v in normal mode)
# Opens current command line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Fix Ctrl-U in insert mode (kill-line backward)
# This ensures Ctrl-U works correctly in insert mode
bindkey -M viins '^U' backward-kill-line

# Set vi mode cursor styles for visual feedback
# Only apply cursor changes if terminal supports it
zle-keymap-select() {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    # Block cursor in normal mode
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} == '' ]] || [[ $1 = 'beam' ]]; then
    # Line cursor in insert mode
    echo -ne '\e[5 q'
  fi
}
zle-line-init() {
  zle -K viins
  # Start in insert mode with line cursor
  echo -ne '\e[5 q'
}
zle -N zle-keymap-select
zle -N zle-line-init

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
