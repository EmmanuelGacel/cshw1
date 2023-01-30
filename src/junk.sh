#!/bin/bash

#####################################################
#Name: junk.sh
#####################################################


# Searches for a junk directory, if not, it creates one
cd ~
if [ ! -d ".junk" ]; then
        mkdir .junk
fi

# Looks at the arguments given on the command line
if [ $# -eq 0 ];then #there were no arguments supplied
	helpmessage
	exit 1
elif [ $# -gt 1 ]; then
	for FILE in $*; do #iterate through all command line arguments
		if[ -f "$FILE" ]; then
			mv "$FILE" ~/junk #moves the valid file to junk
        	else
 			echo Warning: '"$FILE"' not found
		fi
	done	
else #there is exactly one argument entered
	findflags	
fi

function findflags(){
	while getopts ":hlp" option; do #checks for flags, given theres one argument
		case "$option" in
			h)	helpmessage ;;
			l)
				listAll;;
			p)
				purgeAll ;;
			?)
				echo Error: Unknown option -${OPTARG}.
				helpmessage
				exit 1 ;;
		esac
	done
}

function listAll(){ #lists all the files in junk directory
	cd ~/junk
	for FILE in junk; do
		echo "$FILE"
	done
}
function purgeAll(){ #removes all the files in the junk directory
	cd ~/junk
	for FILE in junk; do
		rm "$FILE"
	done
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
