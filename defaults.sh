#!/usr/bin/env bash

# Example of setting defaults without using Domino env. variables explicitly

USER=$(whoami)
if [[ $OSTYPE == *"darwin" ]]      # Running on local - adjust as needed
then
    default_project="/Users/${USER}/project/larry"   
    default_size=small
else
    default_project="/mnt/${USER}/larry"   
    default_size=full
fi

project=${1:-default_project}
sz=${2:-${default_sz}}
