#!/bin/bash

source ./pipeline-commands.sh

declare -r RED="\033[0;31m"
declare -r GREEN="\033[0;32m"
declare -r END="\033[0m"

curDate=$(date "+%Y-%m-%d")
updatedFile="./pipeline-$curDate.json"

checkJQ

checkFile $1

cp $1 $updatedFile

deleteMetadata $updatedFile

updateVersion $updatedFile

while [ "$#" -gt 0 ]; do
  case "$1" in
    --branch)                  updateSourceConfiguration $updatedFile "Branch" $2; shift 2;;
    --owner)                   updateSourceConfiguration $updatedFile "Owner" $2; shift 2;;
    --poll-for-source-changes) updateSourceConfiguration $updatedFile "PollForSourceChanges" $2; shift 2;;
    --configuration)           updateBuildConfiguration $updatedFile $2; shift 2;;
    
    *) shift 1;;
  esac
done

echo "File $updatedFile has been generated"


