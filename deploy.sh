#!/bin/bash

# Usefull Functions

function checkError() {
	if [ $? == 0 ] 
	then 
		echo "pas d'erreur"
	else 
		echo "Erreur, exiting"
		exit 4
	fi
}



# The arguments are replaced by deploying Travis script
jarName="$argument1"
PATH_LIVRAISON_CIBLE=$(sed "s#~#.#" <<< "$argument2")

echo " -> jarName = $jarName"
echo " -> PATH_LIVRAISON_CIBLE = $PATH_LIVRAISON_CIBLE"

# Logs
echo " -> pwd ="
pwd
echo " -> ps et grep ="
ps aux | grep "$jarName"



echo " -> Getting PID already started..."
processStarted=`ps aux | grep "$jarName" | awk '{if($11 != "grep" && $11 != "bash") {print $2} }'` 
checkError

echo "processStarted = $processStarted"
checkError

if [ -z "$processStarted" ] ; then echo "Process non execute" ; else echo "Process deja en cours d'execution, kill maintenant..." && kill $processStarted ; fi
echo " -> Starting application..."

#java -jar $PATH_LIVRAISON_CIBLE/$jarName > $PATH_LIVRAISON_CIBLE/logStart.txt &
#nohup java -jar $PATH_LIVRAISON_CIBLE/$jarName > $PATH_LIVRAISON_CIBLE/logStart.txt &
# nohup java -jar ./$jarName &
# java -jar ./$jarName > /dev/null &

cd $PATH_LIVRAISON_CIBLE
java -jar ./$jarName > ./logStart.txt &
disown

echo " -> Sleeping 15 seconds to wait for program starting"
sleep 15

cat ./logStart.txt
echo " -> Done."
