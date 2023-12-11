#!/bin/bash

function checkJQ {
	type jq &>/dev/null

	if [ $? -eq 0 ]; then 
        	echo -e "Updating pipeline with JQ..."
	else 
        	echo -e "${RED} JQ is not found ${END}"
		echo "   Ubuntu installation: sudo apt install jq"
		echo "   Redhat installation: sudo yum install jq"
		exit 1
	fi
}

function checkFile {
	if [ -z $1 ]; then 
		echo -e "${RED} pipeline file is not provided ${END}"
		exit 1
	fi	
	if [ ! -f $1 ]; then
		echo -e "${RED} File $1 is not found ${END}"
		exit 1
	fi
}

function deleteMetadata {
	hasKey=$(jq 'has("metadata")' $1)
	if ( $hasKey ); then
		jq 'del(.metadata)' $1 >tmp.json && mv tmp.json $updatedFile
		echo -e "${GREEN} Property 'metadata' has been deleted ${END}"
	fi
}

function updateVersion {
        hasKey=$(jq 'has("pipeline")' $1) && $(jq '.pipeline | has("version")' $1)
        if ( $hasKey ); then
		version=$(jq '.pipeline.version' $1)
		((version++))
		jq ".pipeline.version=$version" $1 >tmp.json && mv tmp.json $1
		echo -e "${GREEN} Version has been updated ${END}"
	else 
		echo -e "${RED} Property '.pipeline.version' is not found ${END}"
		exit 1
	fi
}

function updateSourceConfiguration {
	hasKey=$(jq ".pipeline.stages[0].actions[0].configuration | has(\"$2\")" $updatedFile) 
	if ( $hasKey ); then
		jq ".pipeline.stages[0].actions[0].configuration.$2=\"$3\"" $1 >tmp.json && mv tmp.json $1
                echo -e "${GREEN} $2 has been updated ${END}"
        else
                echo -e "${RED} Property '.pipeline.stages[0].actions[0].configuration.$2' is not found ${END}"
                exit 1
        fi
} 

function updateBuildConfiguration {
	numberOfUpdated=0
	len=4
	#$(jq '.pipeline.stages' $1).length

	for (( i=0; i<${len}; i++ ));
	do
        	hasKey=$(jq ".pipeline.stages[$i].actions[0].configuration | has(\"EnvironmentVariables\")" $updatedFile)
        	if ( $hasKey ); then
			updatedEnv=$(jq ".pipeline.stages[$i].actions[0].configuration.EnvironmentVariables | fromjson | .[0].value=\"$2\" | tostring" $1) 
                	jq ".pipeline.stages[$i].actions[0].configuration.EnvironmentVariables=$updatedEnv" $1 >tmp.json && mv tmp.json $1
			((numberOfUpdated++))
		fi
	done

	if [ $numberOfUpdated -gt 0 ]; then
		echo -e "${GREEN} $numberOfUpdated property(ies) '.EnvironmentVariables' have been updated ${END}"
        else
                echo -e "${RED} Property '.EnvironmentVariables' is not found ${END}"
                exit 1
        fi
}


