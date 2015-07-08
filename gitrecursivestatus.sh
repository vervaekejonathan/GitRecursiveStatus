#!/bin/bash


#PRINT GIT STATUS
function GitStatus()
{
	echo $(pwd)
	
	#PRINT UPTODATE
	output=$(git status | head -n 2 | tail -n 1)	

	if [[ "$output" == "Your branch is up-to-date"* ]]
	then
		echo -ne 	"\e[1;32m\t"
		echo  		$output	
		echo -ne 	"\e[0m"	
	else
		echo -ne 	"\e[1;31m\t"
		echo  		"Your branch/origin is not up-to-date!"
		echo -ne 	"\e[0m"

	fi


	#PRINT MODIFIER STATUS
	echo -ne 	"\e[1;34m"

	declare -A mod_stats
	mod_stats=( 	["M"]="File(s) Changed"
		 	["A"]="File(s) Added"
			["D"]="File(s) Deleted"
			["R"]="File(s) Renamed"
			["C"]="File(s) Copied"
			["U"]="Unmerged File(s)" 
			["\?"]="Untracked File(s)"
			["\!"]="Ignored File(s)!" ) #SEE git status --help

	for i in "${!mod_stats[@]}"
	do
		output=$(git status -s  | cut -c-2 | grep -c "$i")
		if [[ $output != 0 ]]
		then
			echo -e "\t$output ${mod_stats["$i"]}"
		fi
	done
	echo -ne "\e[0m"
	echo ""

}


#LOOP THROUGH FOLDERS IN CURRENT MAP
function loopFolders()
{
	rootPath=$(pwd)
	#FIND AND LOOP THROUGH GIT DIRECTORIES
	for i in $(find . -name ".git" 2> /dev/null)
	do
		if [ -d $i ]
		then
			cd $i	
			cd ..
			GitStatus						
			cd $rootPath
		fi
	done
}

currentPath=$(pwd)
if [ "$#" -eq 1 ]
then
	cd $1
fi

loopFolders ./

cd $currentPath
