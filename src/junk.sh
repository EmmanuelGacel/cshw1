#!/bin/bash

#####################################################
#Name: junk.sh
#####################################################


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


# Looks at the arguments given on the command line
if [ $# -eq 0 ];then #there were no arguments supplied
	helpMessage
	exit 1
fi

NUMFLAGS=0
if [ $# -ge 1 ]; then #parse command line arguments
	echo made it in loop
	for arg in $@; do #iterate through all command line arguments
		echo testing "$arg"
		if [ "$arg" == -* ]; then #HOW TO CHECK IF ITS A FLAG?!?!
			echo numflags is "$NUMFLAGS"
			if [ "$NUMFLAGS" -eq 1 ]; then
				echo Error: Too many options enabled.
				helpMessage
				exit 1
			fi
			((++NUMFLAGS))
		fi
	done
	if [ "$NUMFLAGS" -eq 1 ] && [ $# -gt 1]; then #checks for a flag and file name
		echo Error: Too many options enabled
		helpMessage
		exit 1
	fi	
fi

# Searches for a junk directory, if not, it creates one
cd ~
if [ ! -d ".junk" ]; then
        mkdir .junk
fi

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


#Should only be reached if there is exactly 1 flag, or solely files names
function findflags(){ 
	while getopts ":hlp" option; do #checks for flags, given theres one argument
		case "$option" in
			h)	helpMessage ;;
			l)
				listAll;;
			p)
				purgeAll ;;
			?)
				echo Error: Unknown option -${OPTARG}.
				helpMessage
				exit 1 ;;
		esac
	done
}


