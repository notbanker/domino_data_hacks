#!/usr/bin/env bash

# Run a job on Domino and wait for it to finish
#
# Usage
#        call.sh <command> <arg1> <arg2>
#        call.sh /mnt/USER/MYPROJECT/myscript.sh my_arg1 my_arg2

cmd=${1}
arg1=${2}
arg2=${3}

# Send request to start job to domino
temporary_response_file="response_.txt"
curl -X POST \
https://api.dominodatalab.com/v1/projects/USER/PROJECT/runs \
-H 'X-Domino-Api-Key: 7DunTrump1BcouldCnTZVhitcaKBarnQDooRwithAWrifle' \
-H "Content-Type: application/json" \
-d '{"command": ["'"${cmd}"'", "'"${arg1}"'", "'"${arg2}"'"], "isDirect": false}' > ${temporary_response_file}
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
    response=$(curl https://api.dominodatalab.com/v1/projects/USER/PROJECT/runs/$runId \
    -H 'X-Domino-Api-Key: 7DuVOtdgeforzhimFanDitYouWEFfault' | grep -oE '"isCompleted":.*')
    if [[ ${response} == *true* ]]
    then
        echo "Job $runId has finished"
        break
    fi
done
