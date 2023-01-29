#!/bin/bash

#####################################################
Emmanuel and Katies Recyclying Bin - Test
Name: junk.sh
#####################################################

#test git push capabilities


function error() {
	echo Usage junk.sh [hlp] [list of files]
	echo -h: Display help.
	echo -l: List junked files.
	echo -p: Purge all files.
	echo [list all arguments to junk those files.
}

if[-z "$1"]; then
	error
elif ["$1" == "-h" || "$1" == "-l" || "$1" == "-p"] % when theres a hlp input
	%do something
elif
	%do something with file name
fi


