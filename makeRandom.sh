#!/bin/bash

name="randomSpawns.cfg"
letters="abcde"
t="t"
amount=50

while getopts hn:ctr:l:a: opt
do
	case "$opt" in
		n) name=$OPTARG ;;
		c) t="ct" ;;
		t) t="t" ;;
		a) amount=$OPTARG ;;
		r) letters=($(eval echo {a..$OPTARG})) ;;
		l) letters=($(echo "$OPTARG" | grep -o .)) ;;
		h) echo Script which generates random spawns for cs2, compatible with xxxSpawns.cfg files
		   echo
		   echo arguments:
		   echo -n "fileName" to set destination file name
		   echo -t for t spawns
		   echo -c for ct spawns
		   echo -a "amount" amount of random spawns
		   echo -r "range" spawns for map, -r e will generate spawns a-e
		   echo -l "letters" specify letters of spawns, i.e. abdef generates spawns of a b d e f
		   echo
		   echo to generate 20 random spawns in file name "trainrandom.cfg" for t side for spawns a-f type:
		   echo ./makeRandom -n trainrandom.cfg -t -a 20 -r f  
		   exit 0;;
	esac
done

if [ -f $name ];
then
	echo "File already exists, do you want to overwrite the file? (y/n)"

	read -n 1 answer
	
	echo

	case "$answer" in
		y|Y) echo "Overwriting file $name";;
		n|N) echo "Exiting program"
		    exit 1;;
	esac		    
fi

echo alias randomSpawn \"randomSpawn0\" > $name 

for ((i=0;i!=$amount;i++))
do
	randomLetter=letters[RANDOM % ${#letters[@]}]
	echo alias randomSpawn${i} \"alias randomSpawn \\"randomSpawn$((i+1))\\"; alias lastRandomSpawn \\"loc${t}${randomLetter}\\";  loc${t}${randomLetter}\" >> $name
done
randomLetter=letters[RANDOM % ${#letters[@]}]
echo alias randomSpawn${amount} \"alias randomSpawn \\"randomSpawn0\\"; alias lastRandomSpawn \\"loc${t}${randomLetter}\\"; loc${t}${randomLetter}\" >> $name
		

