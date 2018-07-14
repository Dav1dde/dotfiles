upl() {
    if [ "$#" -lt 1 ]; then
        >&2 echo "No arguments"
        return 1
    fi

    dest=$(basename $1)
    if [ "$#" -gt 1 ]; then
        dest=$(basename $2)
    fi
    
    scp $1 $UPL_SSH:$UPL_PATH$dest
    ssh $UPL_SSH chmod 644 $UPL_PATH$dest

    if [ -z ${UPL_URL+x} ]; then; else
        echo "$UPL_URL$dest"
    fi
    
    return 0
}
