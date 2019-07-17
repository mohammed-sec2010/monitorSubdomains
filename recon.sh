#!/bin/bash
#set fifo
mkfifo ./fifo1
#make fd
exec 3<> ./fifo1
rm ./fifo1
THREAD=10
#set flag
for (( i = 0; i < $THREAD; i++ )); do
	echo >&3
done




workSpace="workSpace"
subResultPath="$workSpace/subResultPath"
wordlistPath="./wordlistPath"
checkTar(){
	if [[ $# -eq 0 ]]; then
		echo -e "pleaser enter the target"
		exit 1
	fi
}

setupDir(){
	if [[ ! -d "workSpace" ]]; then
	mkdir -p $subResultPath
	
fi
}

detectSub(){
	subfinder -d $1 -t 50 -b -w wordlistPath/names.txt $1 -nW --silent -o "$subResultPath/$1/`date +"%Y-%m-%d"`.txt";
	#cat test.txt > $subResultPath/$1/`date +"%Y-%m-%d"`.txt;
}
detectSubs(){
	#make workdirection
	for target in `cat targets.txt`; do
		if [[ ! -d "$target" ]]; then
			mkdir -p $subResultPath/$target/update;

		fi
	done
	#dectsub
	for target in `cat targets.txt`; do
		
		read -u3
		{
			
			detectSub $target
			echo >&3
		} &
		
		
    	
	done
	wait
	#deal with result
	for target in $(cat targets.txt); do
		read -u3
		{
			if [[ $(ls $subResultPath/$target/ | wc -l) -eq 3 ]]; then
			cat $subResultPath/$target/*.txt | awk '{print tolower($0)}' | sort | uniq -u > $subResultPath/$target/update/update.txt
    		rm $subResultPath/$target/$(ls $subResultPath/$target | grep -v $(date +"%Y-%m-%d")) 2> /dev/null
    		fi
    	} &
	done
	wait
	#send update
	
	for target in $(cat targets.txt); do
		if [[ -f $subResultPath/$target/update/update.txt ]]; then
			for content in $(cat $subResultPath/$target/update/update.txt); do
				#echo $content
				curl -X POST -H 'Content-type: application/json' --data '{"text":"'$target' - '$content'"}' https://hooks.slack.com/services/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
			done
		fi
	done
	#close fd
	exec 3<&-
	exec 3>&-

}



#start
#checkTar

setupDir
detectSubs

