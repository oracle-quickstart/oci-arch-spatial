#!/bin/bash

function log() {
    while IFS= read -r line; do
        DATE=`date '+%Y-%m-%d %H:%M:%S.%N'`
        echo "<$DATE>  $line"
    done
}

log_file="/tmp/bootstrap.log"

# Call init.sh already provided in the image
su - opc -c "/opt/scripts/init.sh"
exit_code=$?
if [ $exit_code -ne 0 ]; then
    echo "Error executing Spatial Studio setup.. Exiting provisioning" | log >> $log_file
    exit 1
fi