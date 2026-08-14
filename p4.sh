#!/bin/bash
#Jack Liu
#JALLIU
#112655156

if [ $# -gt 2 ]; then
	echo "too many arguments"
	exit 0 #again, with 3+ args, we technically do have the files, but
fi
if [ $# -ne 2 ]; then
	echo "input file and dictionary missing"
	exit 0
fi
[ ! -f "$1" ] && echo "$1 is not a file" && exit 0
[ ! -f "$2" ] && echo "$2 is not a file" && exit 0 # Assuming the dictionary is meant to be a file


input=$(tr ' ' '\n' < $1 | sed 's/[^a-zA-Z0-9]//g' | grep '^[^a-zA-Z]*[a-zA-Z]\{5\}[^a-zA-Z]*$') #Get the words in the file, remove punctuation/etc, and see if they are five letters long

for word in $input #loop through every five letter word
do
	if ! grep -iq $word $2; then #if it doesn't exist in the dictionary; is also case insensitive
		echo $word #it isn't part of dictionray
	fi
done
