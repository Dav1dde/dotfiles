
function ocp() {
    oc project $@
    let r=$?
    if [ $r -ne 0 ]; then
        return 1
    fi
    if [ ! -z "$@" ]; then
        export TILLER_NAMESPACE="$@"
    else
        export TILLER_NAMESPACE="$(oc project -q)"
    fi
}

function tiller_prompt_info() {
    [[ -n "${TILLER_NAMESPACE}" ]] || return
    echo "${ZSH_THEME_TILLER_PREFIX:=[}${TILLER_NAMESPACE:t}${ZSH_THEME_TILLER_SUFFIX:=]}"
}

