#!/usr/bin/env bash

# Run a job on Domino and wait for it to finish
#
# Usage
#        call.sh <command> <arg1> <arg2>
#        call.sh /mnt/USER/MYPROJECT/myscript.sh my_arg1 my_arg2

USER=$(whoami)
cmd=${1}
arg1=${2}
arg2=${3}

# Send request to start job to domino
temporary_response_file="response_.txt"
curl -X POST \
https://api.dominodatalab.com/v1/projects/n581512/larry/runs \
-H 'X-Domino-Api-Key: 7DunjmdG3h1BZCTZVoc8eKaVQnWVn3m4dUinvEQqRoCzMAYeqR27LVMSUbWKVgzF' \
-H "Content-Type: application/json" \
-d '{"command": ["'"${cmd}"'", "/mnt/n581512", "'"${arg1}"'", "'"${arg2}"'"], "isDirect": false}' > ${temporary_response_file}
echo "Sent command to start jobs with arg1 ${arg1} and arg2 ${arg2}."
runId_quoted=$(grep -oE '"runId":"(.*)",' ${temporary_response_file} | cut -d: -f2)
runId=${runId_quoted:1:${#runId_quoted}-3}
echo "The runId is ${runId}"
rm ${temporary_response_file}

# Now poll until done
while true;
do
    sleep 60s
    echo "Polling ..."
    response=$(curl https://api.dominodatalab.com/v1/projects/n581512/larry/runs/$runId \
    -H 'X-Domino-Api-Key: 7DunjmdG3h1BZCTZVoc8eKaVQnWVn3m4dUinvEQqRoCzMAYeqR27LVMSUbWKVgzF' | grep -oE '"isCompleted":.*')
    if [[ ${response} == *true* ]]
    then
        echo "Job $runId has finished"
        break
    fi
done
