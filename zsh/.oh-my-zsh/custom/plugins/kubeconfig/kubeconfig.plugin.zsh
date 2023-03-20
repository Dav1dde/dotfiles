export DEFAULT_KUBECONFIG="$HOME/.kube/config"
export KUBECONFIG_FILES="$HOME/.kube/config.d"

function kubeconfig() {
    export KUBECONFIG="${DEFAULT_KUBECONFIG}"

    for config in ${KUBECONFIG_FILES}/*.{yaml,yml}(N); do
        export KUBECONFIG="${KUBECONFIG}:${config}"
    done
}

kubeconfig

