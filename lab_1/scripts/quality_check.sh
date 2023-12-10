#!/bin/bash

declare -r appPath="./../../../shop-angular-cloudfront"
declare -r compressedFile="./dist/client-app.zip"

declare -r RED="\033[0;31m"
declare -r GREEN="\033[0;32m"
declare -r NC="\033[0m"

export CHROME_BI=N/usr/bin/google-chrome

cd $appPath

npm run lint

lintResult=$?

npm run test-no-watch

testResult=$?

npm audit

auditResult=$?

echo
echo "--- RESULTS ---"
echo

if [ $lintResult -eq 0 ]; then 
	echo -e "${GREEN} Lint task is passed ${NC}"
else 
	echo -e "${RED} Lint task is FAILED ${NC}"
fi

if [ $testResult -eq 0 ]; then
        echo -e "${GREEN} Test task is passed ${NC}"
else
        echo -e "${RED} Tests task is FAILED ${NC}"
fi

if [ $auditResult -eq 0 ]; then
        echo -e "${GREEN} Audit task is passed ${NC}"
else
        echo -e "${RED} Audit task is FAILED ${NC}"
fi


