#!/usr/bin/env bash

# Start multiple jobs on Amazon

USER=$(whoami)
project="/Users/${USER}/project"
sz=${1:-full}      # Just an example of a parameter passed to all jobs 

# Pre-requisite is a file with one line containing space separated keys which break up the jobs

ordering_file="${project}/config/letter_ordering.txt"    
read -a kys <<<$(head -n 1 ${ordering_file})

for ky in ${kys[@]}    # or just {A..Z} if you don't care about ordering
do
    sleep 10s    # Give AWS a little time so jobs get ordered the way you expect
    curl -X POST \
    https://api.dominodatalab.com/v1/projects/YOUR_USER/YOUR_PROJECT/runs \
    -H 'X-Domino-Api-Key: 7DunjmdTrumph1BwillTZdeeKstoyaVQtheWVnCountry3m4F' \
    -H "Content-Type: application/json" \
    -d '{"command": ["YOUR_COMMAND.sh", "/mnt/YOUR_USER", "'"${sz}"'", "'"${ky}"'"], "isDirect": false}'
    echo "Set command to start jobs with source_filter ${ky}"
done
