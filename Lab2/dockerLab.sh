#!/bin/bash -e

shared_directory="/flock"
lock_file="/flock/atomic_script"

while true; do
    (
        exec 9>"$lock_file"
        flock 9
        # Find the next available filename
        for i in {001..999}; do
            if [ ! -e "/$shared_directory/$i" ]; then
                filename="$i"
                break
            fi
        done

        flock -u 9
        exec 9>&-

        # Create and write to the file
        echo "$(hostname) - $(date +%s)" > "/$shared_directory/$filename"

        # Sleep for 1 second
        sleep 1

        # Remove the file
        rm "/$shared_directory/$filename"
        
        # Failed to acquire lock, sleep for a short time
        sleep 0.1
        
    )
done