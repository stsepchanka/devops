#!/bin/bash

declare -r dbPath="../data"
declare -r fileName="users.db"
declare -r fileNameBackup="users.db.backup"
declare -r dbName=$dbPath/$fileName


function show_help {
	echo 'Manage users.db'
	echo ''
	echo 'The list of supported command'
	echo -e "add\t\t\tAdd a new record"
	echo -e "find\t\t\tFind a record by username"
	echo -e "list\t\t\tDisplay all records"
	echo -e "list -inverse\t\tDisplay all records in a reverse order"
	echo -e "backup\t\t\tMake a backup"
	echo -e "restore\t\t\tRestore from the latest backup"
}

function enter_value {
        value=""
        while [[ "$value" == "" ]]; do
                read -p "$1: " value
                if ! [[ $value =~ ^[a-zA-Z]+$ ]]; then
                        echo "Only latin letters are allowed"
                        value=""
                fi
        done
}
	

function add_record {
	enter_value "username"
	local username=$value

	enter_value "role"
        local role=$value

	echo "$username, $role" >> $dbName
}

function make_backup {
	local curDate=$(date "+%Y-%m-%d")
	local dbBackupName=$dbPath/$curDate-$fileNameBackup
	cp $dbName $dbBackupName
	echo "The file $dbBackupName has been created"
}

function restore {
	local backupFile=$(find $dbPath -name *-$fileNameBackup -type f -exec ls -t1 {} + | head -1)  
        if [[ "$backupFile" != "" ]]; then
		cp $backupFile $dbName
	        echo "The file $dbName has been restored"
	else
		echo "No backup file found"
	fi
}

function find_record {
	enter_value "username"
        grep -ni "$value, " $dbName
	if [[ "$?" != 0 ]]; then
	       echo 'User not found'
	fi	       
}

function list_users {
	if [[ $1 == "-inverse" ]]; then 
		cat -n $dbName | sort -r
	else 
		cat -n $dbName
	fi
}


if [[ "$#" == 0 || "$1" == "help" ]]; then
	show_help
	exit
fi

if [[ "$1" != "restore" && ! -f "$dbName" ]]; then
	read -n 1 -p "The file $dbName does not exist. Would you like to create it? [Y/n] " reply
	echo ""
	if [[ "$reply" == 'y' || "$reply" == 'Y' ]]; then
		touch $dbName
		echo "The file $dbName has been created"
	else 
		echo "No $dbName file to continue"
		exit
	fi
fi

case $1 in
	add) 	 add_record;;
	find)    find_record;;
        list)    list_users $2;;
	backup)	 make_backup;;
	restore) restore;;
	*)	 echo "Invalid comand: $1"
esac
