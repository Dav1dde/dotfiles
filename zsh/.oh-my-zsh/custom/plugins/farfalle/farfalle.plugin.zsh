paste() {
    if [[ -t 0 ]]; then
        if [[ "$#" -eq 1 && -f "$*" ]]; then
            curl -X POST -F "file=@$1" "${FARFALLE_URL}" 2>/dev/null
        else
            echo "Usage: $0 <file>"
            return 1
        fi
    else
        curl -X POST -F "file=@-" "${FARFALLE_URL}" 2>/dev/null
    fi
}
