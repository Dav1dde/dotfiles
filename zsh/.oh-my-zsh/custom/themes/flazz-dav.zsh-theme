if [ "$USER" = "root" ]
then CARETCOLOR="red"
else CARETCOLOR="blue"
fi

ZLE_RPROMPT_INDENT=0

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%}) "

PROMPT='%m%{${fg_bold[magenta]}%} :: %{$reset_color%}%{${fg[green]}%}%3~ $(git_prompt_info)%{${fg_bold[$CARETCOLOR]}%}%#%{${reset_color}%} '

function get_cluster_short() {
  full="$1"
  no_ns="${full#*/}"
  cluster_name="${no_ns%/*}"
  user="${no_ns#*/}"

  case "${cluster_name}" in
  api-x-epa-gemtest-rise-link-at:6443)
    cluster_name=gx
    ;;
  api-epa-gemtest-rise-link-at:6443)
    cluster_name=gdev
    ;;
  manage-ocp-porscheinformatik-cloud:8443)
    cluster_name=poi
    ;;
  nonprod1-manage-ocp-porscheinformatik-cloud:8443)
    cluster_name=poi-np
    ;;
  api-console-openshift-console-apps-ocp-ti-tu-ti-testintra-de:443)
    cluster_name=ti
    ;;
  *)
    ;;
  esac

  # echo "${cluster_name}/${user}"
  echo "${cluster_name}"
}
KUBE_PS1_CLUSTER_FUNCTION=get_cluster_short
KUBE_PS1_PREFIX="["
KUBE_PS1_SUFFIX="]"
KUBE_PS1_SYMBOL_COLOR="cyan"
KUBE_PS1_NS_COLOR="cyan"

function tf_prompt_info() {
    # from the tf plugin
    [[ "$PWD" == ~ ]] && return
    if [ -d .terraform ]; then
      local workspace=$(terraform workspace show 2> /dev/null) || return
      echo "%{$reset_color%}[%{$fg[cyan]%}\U0001f310%{$reset_color%}|%{$fg[cyan]%}${workspace}%{$reset_color%}]"
    fi
}

RPS1='$(vi_mode_prompt_info) ${return_code}$(virtualenv_prompt_info)$(tf_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[cyan]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"

ZSH_THEME_VIRTUALENV_PREFIX="%{$reset_color%}[%{$fg[cyan]%}\U0001f40d%{$reset_color%}|%{$fg[cyan]%}"
ZSH_THEME_VIRTUALENV_SUFFIX="%{$reset_color%}]"

ZSH_THEME_TILLER_PREFIX="%{${fg[blue]}%}[%{$reset_color%}"
ZSH_THEME_TILLER_SUFFIX="%{${fg[blue]}%}]%{$reset_color%}"


MODE_INDICATOR="%{$fg_bold[magenta]%}<%{$reset_color%}%{$fg[magenta]%}<<%{$reset_color%}"

# TODO use 265 colors
#MODE_INDICATOR="$FX[bold]$FG[020]<$FX[no_bold]%{$fg[blue]%}<<%{$reset_color%}"
# TODO use two lines if git
