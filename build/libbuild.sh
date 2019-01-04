git_dirty() {
    official="$1"
    project="$2"

    if test "$official" = "1"
    then
        if test ! -z "$(git status --porcelain)"
        then
            git status
            echo ""
            echo ""
            echo ""
            echo "git status is not clean"
            exit 1
        fi
    fi
}




