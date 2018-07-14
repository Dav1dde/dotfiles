vp() {
    if [ -t 0 ]; then
        if [ "$#" -eq 1 ]; then
            if [ -f "$*" ]; then
                echo $(curl -X PUT -F "file=@$1" $VP_URL 2>/dev/null)
            else
                echo $(echo "$*" | curl -X PUT -F "data=<-" $VP_URL 2>/dev/null)
            fi
        else
            echo "No Arguments"
        fi
    else
        echo $(curl -X PUT -F "file=@-" $VP_URL 2>/dev/null)
    fi
}
