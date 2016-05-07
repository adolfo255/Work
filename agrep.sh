

agrep () {
    if [ $# = 0 ]; then
        cat
    else
        pattern="$1"
        shift
        grep -e "$pattern" | agrep "$@"
    fi
}

