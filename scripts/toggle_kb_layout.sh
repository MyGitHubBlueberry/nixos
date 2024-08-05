layout=$(setxkbmap -query | awk '/layout/{print $2}')

case $layout in
    us)
        setxkbmap ua
        ;;
    ua)
        setxkbmap us
        ;;
    *)
esac
