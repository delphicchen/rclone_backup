 #!/bin/bash

prerequire1="inotifywait"
monitor_DIR=" ** "   # replace the  ** with the full path of monitored folder (like /mnt/sda/)
remote_DIR=" ** " # replace the ** with the full path of rclone remote folder ( ex. cloudserver:/Photos/)
if ! command -v $prerequire1
then
    /usr/bin/echo "you have to install following apps first: inotify-tools"
    /usr/bin/echo "would you want to install it automatically?(y/n)"
    read choice
    case $choice in 
        y) sudo apt update && sudo apt install -y inotify-tools  ;;
        n) /usr/bin/echo "exiting..." ;;
        *) /usr/bin/echo "invalid choice...exiting..."
    esac
else
    while true
    do
#        echo "loop start at $(date +%F) $(date +%X)"
        while  /usr/bin/inotifywait -r --timeout 3600 -e create $monitor_DIR
        do
            logfile="/var/log/rclone_log/$(date +%F).log"
            /usr/bin/echo -e "File sync to onedrive at:\n$(date +%F) $(date +%X)" >>$logfile
            /usr/bin/sleep 1800
            /usr/bin/rclone copy -v $monitor_DIR $remote_DIR &>>$logfile 
        done
#        echo "loop finish at $(date +%F) $(date +%X)"
    done
fi
