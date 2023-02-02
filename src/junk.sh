#!/bin/bash

#####################################################
#Name: junk.sh
#Authors: Katherine Wimmer and Emmanuel Gacel
#Version 2.0 02/01/2023
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

readonly junky=~/.junk

# Searches for a junk directory, if not, it creates one
if [ ! -d $junky ]; then
        mkdir -p $junky
	#mkdir ~/.junk
fi	

function listAll(){ #lists all the files in junk directory
	cd $junky
	ls -lAF
	exit 0
}
# shopt citation - https://www.gnu.org/software/bash/manual/html_node/Filename-Expansion.html section 3.5.8
function purgeAll(){ #removes all the files in the junk directory
        cd $junky # If the line below is redundant, than so is this one.
	shopt -s dotglob 
	rm -r $junky/*
	shopt -u dotglob
	exit 0
}

	 

help_flag=0;
list_flag=0;
purge_flag=0;
#Checks for the presence of flags
while getopts ":hlp" option; do #checks for flags, given theres one argument
	case "$option" in
		h)	
			(( ++help_flag ))
			;;
		l)
			(( ++list_flag ))
			;;
		p)
			(( ++purge_flag ))
			;;
		?)
			echo Error: Unknown option -"${OPTARG}".
			helpMessage
			exit 1 ;;
	esac
done
#Checks too see if too many valid arguments have been submitted to the command line
#If so, the proper error message is displayed and the program exits in failure

if [ "$help_flag" -eq 1 ] && [ $(( list_flag + purge_flag )) -gt 0 ]; then
	printf "Error: Too many options enabled.\n" >&2
	helpMessage
	exit 1
fi
if [ "$list_flag" -eq 1 ] && [ $(( help_flag + purge_flag )) -gt 0 ]; then
	printf "Error: Too many options enabled.\n" >&2
	helpMessage
	exit 1
fi
if [ "$purge_flag" -eq 1 ] && [ $(( help_flag + list_flag )) -gt 0 ]; then
	printf "Error: Too many options enabled.\n" >&2
	helpMessage
	exit 1
fi


if [ $(( help_flag + list_flag + purge_flag )) -eq 1 ] && [ $# -gt 1 ];then
	printf "Error: Too many options enabled.\n" >&2
	helpMessage
	exit 1 
fi


# Will take action given what flags were entered
if [ "$help_flag" -ge 1 ];then
	helpMessage
	exit 0
elif [ "$list_flag" -ge 1 ]; then
	listAll
	exit 0
elif [ "$purge_flag" -ge 1 ]; then
	purgeAll
	exit 0
fi

#mulitple of the same flag, do not proceed to process text
if [ $(( help_flag + list_flag + purge_flag )) -eq 1 ] && [ $# -gt 1 ];then
	exit 0
fi


file_finder(){
	
	if [ -f "$1" ]; then
		mv "$1" $junky
	elif [ -d "$1" ]; then
		mv "$1" $junky
	else
		echo Warning: "$1" not found
	fi
}

for filepath in "$@"; do #passes command line arguments to file_finder
	
	file_finder "$filepath"	
done

exit 0 # all files were found and moved into junk directory

