#!/bin/bash
#Jack Liu
#JALLIU
#112655156

if [  $# -eq 0 ]; then # We need exactly one argument, but this catches the no argument case
	echo "input directory is missing"
	exit 0
fi
if [ $# -ne 1 ]; then # technically, i should use greater than, but 0 is already caught before
	echo "too many arguments" #not part of the documentation, but it does mention that there is ONLY 1 argument so 
	exit 0
fi
[ ! -d "$1" ] && echo "the directory does not exist" && exit 0 # directory must exist

cd $1 #go to the directory
#Assuming that the argument is a directory is accessble from our current path
#We could search for the directory through all possible directories, but that didn't seem like what you were asking for
echo "Current date and time: $(date)" #print a
echo "Current directory is: $(pwd)" #print b
echo "" #print c
echo "--- 10 most recently modified directories ---" #print d
echo "$(ls -lt | grep "^d" | head -10)" #print e
#Assuming that not enough directories mean we can just print less than 10; rather than printing something like a 'not enough'
#Also, not listing the . directory since that doesn't really count
echo "" #print f
echo "--- 6 largest files ---" #print g
echo "$(ls -lSr | grep "^-" | tail -n +2 | head -6)" #print h
#echo "======================================================================" just kidding
for ((i=1;i<=70;i++)); #print i with a loop since this is faster than counting 70 equal signs
do
	if ((i == 70))
	then
		echo "="
	else
		echo -n "="
	fi
done
