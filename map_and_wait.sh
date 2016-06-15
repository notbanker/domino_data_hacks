#!/usr/bin/env bash

# Run many jobs on Domino and wait for them to finish
#
# Usage
#        map.sh <project> <command> <sz>    (sz is an example parameter, the same for all tasks)

USER=$(whoami)
project=${1:-"/Users/${USER}/project"}      # Supply  /mnt/YOUR_USER   if running from AWS
cmd=${2:-YOUR_COMMAND.sh}                   # Here YOUR_COMMAND expects three arguments:
                                            #          1. Path to project 
                                            #          2. A parameter common to all jobs 
                                            #          3. A parameter not commmon to all jobs 
                                            # The last is used to carve up the tasks. It is a mask. 
                                            # If this doesn't work for your command, just modify the REST call below
                                            
sz=${3:-full}

ordering_file="${project}/config/letter_ordering.txt"      # Expects a file with one row, space separated. 
read -a ordering <<<$(head -n 1 ${ordering_file})

runIds=()
for source_filter in ${ordering[@]}
do
    response_file="response_${x}.txt"
    curl -X POST \
    https://api.dominodatalab.com/v1/projects/YOUR_USER/YOUR_PROJECT/runs \
    -H 'X-Domino-Api-Key: 7DunjmTrudGmpKVisAgunzNutterF' \
    -H "Content-Type: application/json" \
    -d '{"command": ["/mnt/YOUR_USER/YOUR_PATH/'"${cmd}"'", "/mnt/YOUR_USER", "'"${sz}"'", "'"${source_filter}"'"], "isDirect": false}' > ${response_file}
    echo "Sent command to start jobs with source_filter ${source_filter}."

    # Hack out the runId - you might prefer to use jq if you have it installed.
    runId_quoted=$(grep -oE '"runId":"(.*)",' ${response_file} | cut -d: -f2)
    runId=${runId_quoted:1:${#runId_quoted}-3}
    echo "The runId is ${runId}"
    runIds+=($runId)
    rm ${response_file}

    # Give them time so the ordering is roughly correct
    if [[ ${sz} == "small" ]]
    then
        sleep 5s
    else
        sleep 30s
    fi
done

# Now poll until the runs are done

finished_runs=""
while true;
do
    sleep 1m
    status="finished"
    for runId in ${runIds[@]}
    do
        if [[ ${finished_runs} == *"$runId"* ]]
        then
            #echo "No need to check $runId again"
            : # No need to check again after it has finished
        else
            #echo "Polling $runId"
            response=$(curl https://api.dominodatalab.com/v1/projects/YOUR_USER/YOUR_PROJECT/runs/$runId \
            -H 'X-Domino-Api-Key: 7DunjmIbhopeWKTrumVpgDieszAFterrWXibleWQEdeath' | grep -oE '"isCompleted":.*')
            if [[ ${response} == *false* ]]
            then
                #echo "Job $runId has not finished"
                status="running"
            elif [[ ${response} == *true* ]]
            then
                echo "Job $runId has finished"
                finished_runs="$finished_runs $runId"
            else
                echo "We have a problem"
            fi
        fi
    done

    if [[ ${status} == "finished" ]]
    then
        echo "All finished"
        break
    fi
done
