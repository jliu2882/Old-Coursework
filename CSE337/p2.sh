#!/bin/bash
#Jack Liu
#JALLIU
#112655156

if [ $# -gt 2 ]; then
	echo "too many arguments"
	exit 0 #technically, data/ouput file is given but too many arguments shouldn't pass
fi
if [ $# -ne 2 ]; then
	echo "data file or output file not found"
	exit 0 #either way, if the amount of arguments is not 2 then we can't run the script
fi

[ ! -f "$1" ] && echo "$1 not found" && exit 0 #assumming the first file is the data file



## We can use this to create/overwrite a file >
declare -a array #create an array

while read line; do # read every line
	split=$(echo $line | tr ",;:" "\n") #split the line by the delimiters
	index=1 #start an index for the column
	for char in $split #for every number in the line
	do
		array[$index]=$((array[index]+ char )) #increment the array by that columns value
		index=$((index + 1)) #increment the column we are on by 1
	done
done < $1 #take the file as input

column=1 #create a column number since index wasn't working(?)
echo -n "" > $2 #clear the file with an empty char no newline
for i in "${array[@]}" #for every item in the array
do
	echo "Col $column : ${array[$column]}" >> $2 #add the sum of the column to our output file
	column=$((column + 1)) #move to the next column
done
