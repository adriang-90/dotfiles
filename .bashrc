#!/usr/bin/env bash

# if tmux is executable and not inside a tmux session, then try to attach.
# if attachment fails, start a new session
[ -x "$(command -v tmux)" ] \
  && [ -z "${TMUX}" ] \
  && { tmux attach || tmux; } >/dev/null 2>&1

# @0xADADA’s bash prompt, inspired by gf3’s "Sexy" bash Prompt and vim-airline

function __prompt {
  if [[ ${COLORTERM} = gnome-* && ${TERM} = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM=gnome-256color
  elif infocmp rxvt-unicode-256color >/dev/null 2>&1; then
    export TERM=rxvt-unicode-256color
  elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM=xterm-256color
  fi

  # Prompt prefix, use `$` for successful exit code, `!` for error.
  PREFIX_0=''
  PREFIX_1='!'

  if tput setaf 1 &> /dev/null; then
    tput sgr0
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
      BLACK=$(tput setaf 235)
      BLACK1=$(tput setaf 237)
      BLACK1_BG=$(tput setab 237)
      BLACK2=$(tput setaf 239)
      BLACK2_BG=$(tput setab 239)
      RED=$(tput setaf 124)
      RED_BG=$(tput setab 124)
      GRAY=$(tput setaf 246)
      GRAY_BG=$(tput setab 246)
      WHITE=$(tput setaf 223)
      ORANGE_BG=$(tput setab 208)
    else
      BLACK=$(tput setaf 0)
      BLACK1=$(tput setaf 0)
      BLACK1_BG=$(tput setab 0)
      BLACK2=$(tput setaf 0)
      BLACK2_BG=$(tput setab 0)
      RED=$(tput setaf 1)
      RED_BG=$(tput setab 1)
      GRAY=$(tput setaf 7)
      GRAY_BG=$(tput setab 7)
      WHITE=$(tput setaf 7)
      ORANGE_BG=$(tput setab 3)
    fi
  fi

  function git_state_color {
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
      local STATE=237
      local RED_BG=124
      local ORANGE_BG=208
    else
      local STATE=0
      local RED_BG=1
      local ORANGE_BG=3
    fi
    # check for unstaged changes
    if ! git diff --quiet --ignore-submodules --cached; then
      STATE="${RED_BG}"  # Unstaged changes (not yet added)
    fi
    # check for untracked files
    if [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
      STATE="${RED_BG}"  # New files (not yet added)
    fi
    # check for uncommitted changes in the index
    if ! git diff-files --quiet --ignore-submodules --; then
      STATE="${ORANGE_BG}"  # Changes detected (not yet committed)
    fi
    printf '%s' "${STATE}"
  }

  function git_branch {
    local BRANCH
    BRANCH="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
                    git rev-parse --short HEAD 2> /dev/null || \
                    printf "(unknown)")"
    local COLORCODE
    COLORCODE=$(git_state_color)
    local BG_COLOR
    BG_COLOR=$(tput setab "${COLORCODE}")
    local FG_COLOR
    FG_COLOR=$(tput setaf "${COLORCODE}")
    local TXT_COLOR
    TXT_COLOR="${GRAY}"

    # If the BG_COLOR isn't "clean", change text color to black (more contrast)
    if [[ ${COLORCODE} != '237' && ${COLORCODE} != '0' ]]; then
      TXT_COLOR="${BLACK}"
    fi
    # Explain magic of \001 and \002 http://mywiki.wooledge.org/BashFAQ/053
    printf '\001%s\002\001%s\002 \001%s\002 %s \001%s\002\001%s\002' \
      "${BG_COLOR}" "${BLACK2}" "${TXT_COLOR}" "${BRANCH}" "${RESET}" "${FG_COLOR}"
  }

  function prompt_git {
    # Check CWD is a git repository
    if git rev-parse --is-inside-work-tree &> /dev/null; then
      git_branch
    else
      # Print a blank segment
      printf '\001%s\002\001%s\002 \001%s\002\001%s\002' \
        "${BLACK1_BG}" "${BLACK2}" "${RESET}" "${BLACK1}"
    fi
  }

  function status_prefix {
    # Check the exit code of the previous command and display different
    # colors in the prompt accordingly.
    if (( EXIT_CODE == 0 )); then
      printf '\001%s\002%s\001%s\002 ' "${WHITE}" "${PREFIX_0}" "${RESET}"
    else
      printf '\001%s\002[%s]%s\001%s\002 ' \
        "${RED}" "${EXIT_CODE}" "${PREFIX_1}" "${RESET}"
    fi
  }

  function init_prompt {
    EXIT_CODE="$?"
    PS1=""
    PS1+="\001${GRAY_BG}\002\001${BLACK}\002\u@\001${BOLD}\002\001${BLACK}\002\h " # user@host
    PS1+="\001${BLACK2_BG}\002\001${GRAY}\002 \W \001${RESET}\002"                # ~
    PS1+="\$(prompt_git)"                                                          # <git branch>
    PS1+="\$(status_prefix)"                                                       # $
  }

  PROMPT_COMMAND=init_prompt
}

__prompt
unset __prompt

# Aliases
alias zets='cd /home/babel/gh_repos/zettelsss'
alias ls='ls -h --color=auto'
alias tmux="tmux -2"
alias add="git add"
alias commits="git commit -S -m"
alias c="clear"
alias status="git status"
alias commit="git commit -m"
alias rmi="/home/babel/gh_repos/scripts/docker/removei.sh"
alias rmc="/home/babel/gh_repos/scripts/docker/stopc_removec.sh"
alias discord="discord --ignore-gpu-blocklist --disable-features=UseOzonePlatform --enable-features=VaapiVideoDecoder --use-gl=desktop --enable-gpu-rasterization --enable-zero-copy --no-sandbox"
alias db="docker build"
set -o vi
alias gomodpdf="go mod graph | modgv | dot -Tps2 -o graph.ps && ps2pdf graph.ps graph.pdf"
alias pl_kb="setxkbmap -layout pl"
alias zombies="ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head"
alias hidden_bear="du -hsx * | sort -rh | head -10"

#PATHS
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export GO111MODULE=on
export CLOUDSDK_PYTHON=python2

alias mkz="mkdir $(date -u +%Y%m%d%H%M%S "$@") \
  && cd "$@" "


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/babel/google-cloud-sdk/path.bash.inc' ]; then . '/home/babel/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/babel/google-cloud-sdk/completion.bash.inc' ]; then . '/home/babel/google-cloud-sdk/completion.bash.inc'; fi

# Export for signing commits
export GPG_TTY=$(tty)
bind -x '"\C-f":"fzf"'
alias k=kubectl
complete -o default -F __start_kubectl k
