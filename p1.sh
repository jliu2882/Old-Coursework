#!/bin/bash
#Jack Liu
#JALLIU
#112655156

if [ $# -ne 3 ]; then
	echo "USAGE: p1.sh <extension><src_dir><dst_dir>"
	exit 0 #Assuming that exit 0 is fine, since it was not specified
fi

#There were no demands that extension must be .<something>
#This allows the program to be more versatile, but if we had to force it to be .<something>, we can use wildcards
[ ! -d "$2" ] && echo "<src_dir> not found" && exit 0 # We need the source directory to exist
[ ! -d "$3" ] && mkdir "$3" # Create directory if it does not exist

cd "$3"
directory=$(pwd) #Get the absolute path of dst_dir
cd ..
cd "$2" #Go into src_dir
find . -type f -name "*$1" -exec cp --parents {} "$directory" \; #copy all files with that extension(cp has --parents which copies structure
find . -type f -name "*$1" -exec rm {} \; #remove all files with that extension
