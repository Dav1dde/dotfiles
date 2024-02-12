# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="flazz-dav"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
#COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

_fzf_compgen_path() {
  fd --hidden --no-ignore --follow -E ".git" -E ".hg" -E ".svn" -E "node_modules" -E "target" -E "dist" -E "__pycache__" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --no-ignore --follow -E ".git" -E ".hg" -E ".svn" -E "node_modules" -E "target" -E "dist" -E "__pycache__"  . "$1"
}

export FARFALLE_URL="https://p.dav1d.de"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git pip virtualenv archlinux fasd fzf colorize tmux sudo systemd extract zsh-syntax-highlighting virtualenvwrapper kubeconfig farfalle dotenv)

source $ZSH/oh-my-zsh.sh

export JAVA_HOME=/usr/lib/jvm/default/
export PATH="/home/dav1d/.cargo/bin:$PATH"

# User configuration
export PYPY_IRC_TOPIC=1
export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/src

export SAVEHIST=500000
export HISTSIZE=500000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_NO_FUNCTIONS
setopt INC_APPEND_HISTORY

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"
export MAKEFLAGS="-j 8"

export NODE_OPTIONS=--max_old_space_size=8192

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

source ~/.zsh_alias

# Environment specific overrides which are not checked in
if [[ -f "${HOME}/.zshrc.env" ]]; then
  source "${HOME}/.zshrc.env"
fi

eval "$(starship init zsh)"
