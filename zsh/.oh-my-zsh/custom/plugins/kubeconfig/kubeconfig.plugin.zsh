export DEFAULT_KUBECONFIG="$HOME/.kube/config"
export KUBECONFIG_FILES="$HOME/.kube/config.d"

function kubeconfig() {
    export KUBECONFIG=""

    if test -f "${DEFAULT_KUBECONFIG}"; then
        export KUBECONFIG="${DEFAULT_KUBECONFIG}"
    fi

    for config in ${KUBECONFIG_FILES}/*.{yaml,yml}(N); do
        export KUBECONFIG="${config}:${KUBECONFIG}"
    done
}

kubeconfig

