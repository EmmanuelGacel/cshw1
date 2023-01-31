#!/bin/bash

#####################################################
#Name: junk.sh
#####################################################

# Use these variables as integers.
directory_count=0
symlink_count=0

# Use these variables as booleans.
directory_flag=0
symlink_flag=0

# Function to recurse the file system.
recurse_dir() {
    # "$1"/* matches all files except hidden files.
    # "$1"/.[!.]* matches hidden files, but not .. which would lead to
    # infinite recursion.
    for file in "$1"/.[!.]* "$1"/*; do
        # -h tests if a file is a symlink.
        if [ "$symlink_flag" -eq 1 ] && [ -h "$file" ]; then
            # readlink prints the location to which the symlink points.
            echo "symlink  : $file -> $(readlink "$file")"
            (( ++symlink_count ))
        fi
        # -d tests if a file is a directory.
        if [ -d "$file" ]; then
            if [ "$directory_flag" -eq 1 ]; then
                echo "directory: $file"
                (( ++directory_count ))
            fi
            recurse_dir "$file"
        fi
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

help_flag=0;
list_flag=0;
purge_flag=0;
#Should only be reached if there is exactly 1 flag, or solely files names
function findflags(){ 
	while getopts ":hlp" option; do #checks for flags, given theres one argument
		case "$option" in
			h)	helpMessage
				help_flag=$((help_flag+1))	
				;;
			l)
				listAll
				list_flag=$((list_flag+1))
				;;
			p)
				purgeAll
				purge_flag=$((purge_flag+1))
				;;
			?)
				echo Error: Unknown option -${OPTARG}.
				helpMessage
				exit 1 ;;
		esac
	done
}
#Checks too see if too many valid arguments have been submitted to the command line
#If so, the proper error message is displayed and the program exits in failure
if [ $(( helpcounter + listcounter + purgecounter )) \> 1 ]; then
        printf "Error: Too many options enabled.\n" >&2
        exit 1
fi

# Process remaining arguments, which should be the folder in which start
# recursing.
# Consider ./search.sh -s -d /tmp
# $0 is ./search.sh
# $1 is -s
# $2 is -d
# $3 is /tmp
# $OPTIND is the index of the next argument on the command line, after all
# flags have been parsed with getopts.
# We want to shift it so that /tmp is now in $1, so we take 3-1 and left shift
# 2 places.
shift "$((OPTIND-1))"

# $# gives the number of command line arguments. After shifting, it should just
# be 1.
if [ $# -gt 1 ]; then
    echo "Error: Too many arguments." >&2
    exit 1
elif [ $# -eq 0 ]; then
    # If not directory was supplied, pass the current directory (.) to the
    # function.
    directory_flag=1
    recurse_dir .
else
        symlink_flag=1
    recurse_dir "$1"
fi

# Print the counts discovered during the search.
if [ "$symlink_flag" -eq 1 ]; then
    if [ "$symlink_count" -eq 1 ]; then
        echo "1 symlink found."
    elif [ "$symlink_count" -eq 0 ]; then
        echo "0 symlinks found."
    else
        echo "$symlink_count symlinks found."
    fi
fi

if [ "$directory_flag" -eq 1 ]; then
    if [ "$directory_count" -eq 1 ]; then
        echo "1 directory found."
    elif [ "$directory_count" -eq 0 ]; then
        echo "0 directores found."
    else
        echo "$directory_count directories found."
    fi
fi

