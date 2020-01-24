#!/bin/bash

################################################################
################################################################
#              CSharp Tooling Setup                            #
################################################################
################################################################

#Authors:  n173hawk, n00brage
#Created:  01/23/2020
#Modified: 01/24/2020

################################################################
#                    FUNCTIONS                                 #
################################################################

#Add Repository

function_addRepos(){
echo "$OPTARG" >> repos.txt

echo "
$OPTARG was added to the repository list
"
echo "
The following repositories are ready to be cloned:
"
cat repos.txt
}

#Remove Repositories

function_removeRepos(){
sed -i "/$OPTARG/d" repos.txt

echo "
$OPTARG was removed from the repository list
"
echo "
The following repositories are ready to be cloned:
"
cat repos.txt
}
#Compile Repositories

function_buildRepos(){

#Find cs projects from within our /opt/csharptooling folder and create an array
sharpFolders=($(find /opt/csharptooling/ -name "*.csproj"))

#Compile the csproj files
for cspro in "${sharpFolders[@]}"
do
	xbuild $cspro
#	echo "$cspro"
done

#Create an array of all executables that were just compiled.
sharpExe=($(find /opt/csharptooling/ -name "*.exe"))

#Move executables to /opt/exe for use with aggressor scripts.
for cse in "${sharpExe[@]}"
do
	mv $cse /opt/exe
done

#Show list of executables
echo "The following executables have been compiled and are now in your /opt/exe folder:
"

ls /opt/exe
}

#Help Menu
function_Help(){
echo "Usage: 

Be sure that sharptoolsetup.sh and repos.txt are in the same directory.

-a - Add Repository
-b - Compile Cloned Repositories
-c - Clone Repositories
-h - Help
-r - Remove Repository"
}

#Clone Repos Function
function_cloneRepos () {
reposList=repos.txt
mapfile -t sharpTools < $reposList
for st in "${sharpTools[@]}"
do
	cd /opt/csharptooling/ && git clone $st
done

echo "The following Repositories have been cloned to /opt/csharptooling/:
"
echo $reposList
}


#################################################################
#                   OPTIONS                                     #
#################################################################

while getopts ":a:r:bch" opt; do
	case ${opt} in
		a) function_addRepos ;; #Add to repository
		b) function_buildRepos;; #Compile Projects
		c) function_cloneRepos ;; #Clone Repositories
		h) function_Help ;; #Show Help
		r) function_removeRepos #Remove Repository
	        #u) 
	esac
done
