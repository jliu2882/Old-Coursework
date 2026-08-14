#!/bin/bash
#Jack Liu
#JALLIU
#112655156

if [ $# -eq 0 ]; then
	echo "score directory missing"
	exit 0 #No arguments=>argument missing
fi
if [ $# -ne 1 ]; then
	echo "too many arguments"
	exit 0 #again not part of the description, but the argument is there
fi

[ ! -d "$1" ] && echo "$1 is not a directory" && exit 0

#Assumes that all files in the directory are score files; but we could also search the input to readFile to confirm a .txt extension
function readFile { # Made a function to read the file and print the proper output
	id=$(tail -n +2 $1 | tr "," "\n" | head -n 1) #get the first of the second line of the file
	input=$(tail -n +2 $1 | tr "," "\n" | tail -n +2) #get everything but the first of the second line
	sum=0 #start at 0
	for score in $input #add all scores
	do
		sum=$((sum+=2*$score)) #Since we knowthat there is 50 points for 100 percent, we can do this easier method
	done
	echo -n $id #Print id without a newline
	echo -n ":" #Print the colon wihtout a newline
	#We will now find the right letter grade to print with a newline
	if [ "$sum" -ge 93 ]  && [ "$sum" -le 100 ]; then #if you got more than 100, you don't get an A
		echo "A"
	elif [ "$sum" -ge 80 ] && [ "$sum" -le 92 ]; then #less than 92 is implied here but for the sake of consistency
		echo "B"
	elif [ "$sum" -ge 65 ] && [ "$sum" -le 79 ]; then
		echo "C"
	elif [ "$sum" -ge 51 ] && [ "$sum" -le 65 ]; then #part of the documentation, but I assume it meant 64, but 65 will return a C since it was first
		echo "D"
	elif [ "$sum" -le 50 ]; then #Just in case you got 101, you're gonna have to wait to get a grade :)
		echo "F"
	fi
}

cd $1 #go into the directory
for FILE in *; do  readFile $FILE; done #for each file get the scores


