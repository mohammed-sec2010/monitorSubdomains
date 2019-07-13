#!/bin/bash





workSpace="workSpace"
subResultPath="$workSpace/subResultPath"
wordlistPath="$workSpace/wordlistPath"
checkTar(){
	if [[ $# -eq 0 ]]; then
		echo -e "pleaser enter the target"#statements
		exit 1
	fi
}

setupDir(){
	if [[ ! -d "workSpace" ]]; then
	mkdir -p workSpace
	cd workSpace
	mkdir subResultPath
fi
}

detectSub(){
	#subfinder -d $1 -t 50 -b -w wordlistPath/all.txt $TARGET -nW --silent -o "$subResultPath/$1/`date +"%Y-%m-%d"`.txt"
	cat test.txt > $subResultPath/$1/`date +"%Y-%m-%d"`.txt;
}
detectSubs(){
	
	for target in `cat targets.txt`; do
		if [[ ! -d "$target" ]]; then
			mkdir -p $subResultPath/$target/update;

		fi
	done
	for target in `cat targets.txt`; do
		
		detectSub $target
    	cat $subResultPath/$target/*.txt | sort | awk '{print tolower($0)}' | uniq -u > $subResultPath/$target/update/update.txt
    	
    	rm $subResultPath/$target/$(ls $subResultPath/$target | grep -v $(date +"%Y-%m-%d")) 2> /dev/null
    	
	done

}


#start
#checkTar

setupDir
detectSubs

