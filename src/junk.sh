#!/bin/bash

#####################################################
#Name: junk.sh
#####################################################

#test git push capabilities


function description() {
	FOURSPACE='    '
	echo Usage junk.sh [hlp] [list of files]$'\n'"${FOURSPACE}"-h: Display help.$'\n'"${FOURSPACE}"-l: List junked files.$'\n'"${FOURSPACE}"-p: Purge all files.$'\n'"${FOURSPACE}"[list all arguments] to junk those files.
}

if [ -z "$1" ];then #there were no arguments supplied
	description
	exit 1
fi

while getopts ":hlp" option; do
	case "$option" in
		h)
			description ;;
		l)
			listAll ;;
		p)
			purgeAll ;;
		?)
			echo Error: Unknown option -${OPTARG}.
			description
			exit 1 ;;
	esac
done

function listAll(){
	echo will list all the files in recycle bin
}
function purgeAll(){
	echo will purge all the files in recycle bin
}

# NEED TO CONSIDER CASE WHEN FILE ARUGMENTS ARE ENTERED
