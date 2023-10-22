#!/bin/bash

declare -i treshold=$((1024**2)) 

if [[ ! -z $1 ]]; then
	treshold=$1
fi

declare -i freeDiskSpace=$(df --total --output=avail | tail -n 1)

echo -n 'Free disk space control: '

if [[ $freeDiskSpace -lt $treshold ]]; then
	echo -e "\033[1;31mfree disk space $freeDiskSpace Kb < $treshold Kb\033[0m"
else
	echo -e "\033[1;32mOk\033[0m"
fi


