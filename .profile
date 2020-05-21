# If not running interactively, don't do anything.
case $- in
    *i*) ;;
    *) return ;;
esac

if [ "${BASH-no}" != "no" ]; then
    # We're in a login bash shell invoked as "sh".
    source ~/.shellrc
fi
