#!/system/bin/sh

ui_print " "
ui_print "===== Swap Manager ====="
ui_print " "

ui_print "Select swap size using volume keys:"
ui_print " "
ui_print "Vol+ = Next option"
ui_print "Vol- = Select option"
ui_print " "

OPTIONS="
512
1024
2048
"

INDEX=1

for SIZE in $OPTIONS; do
    ui_print "[$INDEX] ${SIZE}MB"
    INDEX=$((INDEX + 1))
done

chooseport() {
    while true; do
        EVENT=$(getevent -qlc 1)

        case "$EVENT" in
            *KEY_VOLUMEUP*DOWN*)
                return 1
                ;;
            *KEY_VOLUMEDOWN*DOWN*)
                return 0
                ;;
        esac
    done
}

CURRENT=1

while true; do

    case $CURRENT in
        1) SWAPSIZE=512 ;;
        2) SWAPSIZE=1024 ;;
        3) SWAPSIZE=2048 ;;
    esac

    ui_print " "
    ui_print "Current Selection: ${SWAPSIZE}MB"
    ui_print "Vol+ Next | Vol- Select"

    chooseport

    if [ $? -eq 0 ]; then
        break
    fi

    CURRENT=$((CURRENT + 1))

    [ $CURRENT -gt 3 ] && CURRENT=1
done

mkdir -p /data/adb

cat > /data/adb/swap-manager.conf <<EOF
SWAP_SIZE_MB=$SWAPSIZE
SWAP_FILE=/data/swap.img
SWAPPINESS=100
EOF

ui_print " "
ui_print "Selected swap size: ${SWAPSIZE}MB"
ui_print " "