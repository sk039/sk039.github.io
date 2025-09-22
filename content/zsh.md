+++
title = "ZSH：THE Z SHELL"
date = 2022-08-28
[taxonomies]
categories = ["应用"]
tags = ["zsh"]
+++

## 配置

```zsh
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"
export PATH=/opt/toolchains/gcc-linaro-12.0.1-2022.02-x86_64_aarch64-linux-gnu/bin:$PATH
export PATH=/opt/toolchains/mips-loongson-gcc8-linux-gnu-2021-02-08/bin:$PATH
export PATH=/opt/node-v14.17.3-linux-x64/bin:$PATH
export PATH=$HOME/.bin:$PATH
export PATH=$HOME/.bin/latexindent.pl-3.12:$PATH
#export PATH=/usr/local/texlive/2022/bin/x86_64-linux:$PATH
#export PATH=$PATH:$HOME/.platformio/penv/bin
DEBFULLNAME="Ke Sun"
DEBEMAIL="sunke@kylinos.cn"
export DEBEMAIL DEBFULLNAME
export EDITOR='vim'
export XDG_CONFIG_HOME=$HOME/.config

# Use ESC to edit the current command line:
# https://bugfactory.io/blog/z-shell-tip-edit-current-command-line-with-vim/
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\033' edit-command-line

# Font:
# https://github.com/JetBrains/JetBrainsMono
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

# .zshrc reference to:
# https://github.com/lmintmate/zshrc
# https://github.com/ricbra/zsh-config
#
# Setting for menu selection in completion
zstyle ':completion:*' menu select
# List the completion matches in rows instead of columns
setopt list_rows_first
# Show a menu for completion instead of putting all the
# filenames that satisfy the conditions of the glob on the command
setopt glob_complete
# Enable LS_COLORS for the completion of files and directories
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Append commands to the history file as soon as they are executed.
setopt inc_append_history
# Don’t add a duplicate of the previous command into history.
setopt histignoredups
# Try to correct the spelling of commands
setopt correct
# https://github.com/robbyrussell/oh-my-zsh/issues/449
setopt no_nomatch

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# Load powerlevel10k theme
zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k

# Load pure theme
#zinit ice pick"async.zsh" src"pure.zsh" # with zsh-async library that's bundled with it.
#zinit light sindresorhus/pure

# Load starship theme
#zinit ice as"command" from"gh-r" \ # `starship` binary as command, from github release
#          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \ # starship setup at clone(create init.zsh, completion)
#          atpull"%atclone" src"init.zsh" # pull behavior same as clone, source init.zsh
#zinit light starship/starship

# A.
setopt promptsubst

# B.
zinit wait lucid for \
        OMZL::git.zsh \
  atload"unalias grv" \
        OMZP::git

# C.
zinit wait'!' lucid for \
    OMZL::prompt_info_functions.zsh

zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
    zsh-users/zsh-completions

# D.
zinit wait lucid for \
      zdharma-continuum/fast-syntax-highlighting \
      OMZP::colored-man-pages \
  as"completion" \
        OMZP::docker/_docker \
  as"completion" is-snippet\
        $(rustc --print sysroot)/share/zsh/site-functions/_cargo \
  atload"_zsh_autosuggest_start; bindkey '  ' autosuggest-accept" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
        OMZP::extract \
	OMZL::history.zsh

zinit wait lucid for \
	agkozak/zsh-z \
	zdharma-continuum/history-search-multi-word \
	https://gist.githubusercontent.com/hightemp/5071909/raw/ \
	https://github.com/ohmyzsh/ohmyzsh/raw/master/plugins/command-not-found/command-not-found.plugin.zsh \
	amyreese/zsh-titles

#zinit ice proto"https"
#zinit light zinit-zsh/z-a-man

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
```

## 插件

### 插件管理器

https://zdharma-continuum.github.io/zinit/wiki/

### 常用插件

https://project-awesome.org/unixorn/awesome-zsh-plugins

https://github.com/amyreese/zsh-titles


