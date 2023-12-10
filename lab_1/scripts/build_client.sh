#!/bin/bash

declare -r appPath="./../../../shop-angular-cloudfront"
declare -r compressedFile="./dist/client-app.zip"

cd $appPath

npm install

export $(cat .env | xargs)


if [ -f "$compressedFile" ]; then
	rm "$compressedFile"
	echo "$compressedFile has been removed"
fi

ng build --configuration=$ENV_CONFIGURATION

zip -r $compressedFile ./dist/*

if [ -f "$compressedFile" ]; then
	echo "$compressedFile $(du -sh $compressedFile | awk '{ print $1 }')  has been created"
fi


