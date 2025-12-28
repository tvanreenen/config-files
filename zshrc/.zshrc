# ————————————————————————————————————————————————————————————————
# Homebrew
# - Use brew’s official shellenv to set PATH, MANPATH, INFOPATH, etc.
# - Add Homebrew’s zsh site-functions so completions (git, just, kubectl, etc.)
#   are automatically discovered before compinit runs.
# ————————————————————————————————————————————————————————————————
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
fi

# ————————————————————————————————————————————————————————————————
# Personal tools (~/.local/bin)
# - Common home for per-user binaries (e.g., uv, uvx, cursor-agent).
# - Put early in PATH so your tools override system defaults when needed.
# ————————————————————————————————————————————————————————————————
export PATH="$HOME/.local/bin:$PATH"

# ————————————————————————————————————————————————————————————————
# Docker Desktop completions
# - Docker drops zsh completion files here; add only if the directory exists.
# ————————————————————————————————————————————————————————————————
if [[ -d "$HOME/.docker/completions" ]]; then
  fpath=("$HOME/.docker/completions" $fpath)
fi

# ————————————————————————————————————————————————————————————————
# zsh completion system
# - fpath: search path for zsh functions & completions.
# - De-duplicate, then initialize once.
# - compinit:
#     -i → ignore insecure directories instead of aborting.
#     -C → skip rebuilding the cache if it’s still valid (faster startup).
# - ZSH_COMPDUMP stores the compiled completions cache; versioned for safety.
# ————————————————————————————————————————————————————————————————
typeset -U fpath
ZSH_COMPDUMP="${ZSH_COMPDUMP:-$HOME/.zsh/.zcompdump-$ZSH_VERSION}"
autoload -Uz compinit
compinit -i -C

# ————————————————————————————————————————————————————————————————
# Completion cache & matcher options
# - Enable caching and ensure the cache directory exists.
# - Optional matcher-list enables case-insensitive & word-boundary completion.
# ————————————————————————————————————————————————————————————————
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zsh/cache"
[[ -d "$HOME/.zsh/cache" ]] || mkdir -p "$HOME/.zsh/cache"

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
# Google Cloud SDK
# - Updates PATH and enables shell command completion for gcloud.
# - Only loads if the SDK is installed at the expected location.
# ————————————————————————————————————————————————————————————————
if [ -f '/Users/tim.vanreenen/Code/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/tim.vanreenen/Code/google-cloud-sdk/path.zsh.inc'; fi
if [ -f '/Users/tim.vanreenen/Code/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/tim.vanreenen/Code/google-cloud-sdk/completion.zsh.inc'; fi

# ————————————————————————————————————————————————————————————————
# Bun
# - JavaScript runtime, package manager, and bundler.
# - Adds bun to PATH and loads shell completions if available.
# ————————————————————————————————————————————————————————————————
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "/Users/tim.vanreenen/.bun/_bun" ] && source "/Users/tim.vanreenen/.bun/_bun"
