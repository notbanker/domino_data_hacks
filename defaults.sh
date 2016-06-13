#!/usr/bin/env bash

# Example of setting defaults without using Domino env. variables explicitly

USER=$(whoami)
if [[ $OSTYPE == *"linux" ]]      # Running on Domino, refine you use linux at home ;)
then
    default_project="/mnt/${USER}/larry"   
    default_size=full
else
    default_project="/Users/${USER}/project/larry"   # Running on local
    default_size=small
fi

project=${1:-default_project}
sz=${2:-${default_sz}}
