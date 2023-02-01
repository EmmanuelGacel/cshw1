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

# Searches for a junk directory, if not, it creates one
cd ~
if [ ! -d ".junk" ]; then
        mkdir .junk
fi

function listAll(){ #lists all the files in junk directory
	cd ~/.junk
	ls -lAF
}
function purgeAll(){ #removes all the files in the junk directory
        cd ~/.junk # If the line below is redundant, than so is this one.
        shopt -s dotglob # I have to cite this, possibly redudant.
	rm -r ~/.junk/*
	shopt -u dotglob
}

<<temp
# Places a file into the .junk 
junk_mover(){
	 
	targetfile= "$1" #argument passed to the function
	targetdirectory=~/fish

	file_flag=1
	directory_flag=1

	if [ $file_flag -gt 0 ]; then 
        dir=$(dirname "$targetfile") #stores the name of the directory
        filename="$(basename "$targetfile")" #stores the filename
        cd $dir
        mv $targetfile ~/.junk
	fi

	if [ $directory_flag -gt 0 ]; then
        mv $targetdirectory ~/.junk
	fi

}
temp

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
if [ $(( help_flag + list_flag + purge_flag )) -gt  1 ]; then
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
if [ "$help_flag" -eq 1 ];then
	helpMessage
	exit 0
elif [ "$list_flag" -eq 1 ]; then
	listAll
	exit 0
elif [ "$purge_flag" -eq 1 ]; then
	purgeAll
	exit 0
fi

#calls junk_mover for entered files

file_finder(){
	
	echo "$1"	
	if [ -f "$1" ]; then
		mv "$1" ~/.junk
	elif [ -d "$1" ]; then
		file_finder $(dirname "$1")
	else
		echo Warning: "$1" not found
	fi
}
for filepath in "$@"; do #passes command line arguments to file_finder
	
	file_finder "$filepath"	
done


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
if [ $# -gt 1 ]; then # USER CAN ENTER MULTIPLE FILE NAMES, INCORRECT STATEMENT
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

