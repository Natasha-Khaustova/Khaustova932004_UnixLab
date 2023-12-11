#!/bin/bash -e

shared_directory="/_data"
lock_file="/tmp/atomic_script.lock"
temp_dir="/tmp/atomic_script_temp"

while true; do
    (
        if flock -n 9; then  # Try to lock
            # Generate random identifier for the container
            container_id=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 10)

            # Find the next available filename
            counter=1
            while true; do
                filename=$(printf "%03d_%s" "$counter" "$container_id")
                if [ ! -e "$shared_directory/$filename" ]; then
                    break
                fi
                ((counter++))
            done

            # Create and write to the file
            echo "Container ID: $container_id" > "$shared_directory/$filename"
            echo "File Number: $counter" >> "$shared_directory/$filename"

            # Sleep for 1 second
            sleep 1

            # Remove the file
            rm "$shared_directory/$filename"
        else
            # Failed to acquire lock, sleep for a short time
            sleep 0.1
        fi
    ) 9>"$lock_file"  # Release the lock
done