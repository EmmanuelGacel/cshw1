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

# Searches for a .junk directory -> If none exits, it creates one.
cd ~
if [ ! -d ".junk" ]; then
        mkdir .junk
fi

function listAll(){
	echo will list all the files in recycle bin
}
function purgeAll(){
	echo will purge all the files in recycle bin
}
# Displays the usage message. Implements basenames to get the file name.
function helpMessage(){
	varname=$(basename "$0")
(cat << ENDOFTEXT
Usage: $varname [-hlp] [list of files]
    -h: Display help.
    -l: List junked files.
    -p: Purge all files.
    [list of files] with no other arguments to junk those files.
ENDOFTEXT
)

}
# NEED TO CONSIDER CASE WHEN FILE ARUGMENTS ARE ENTERED
