#!/bin/bash
for directory in `find $1 -type d `
do

	if [ -f $directory/info	]; then
	
		serie="$(grep -m 1 '^T' $directory/info | sed -r 's/^.{2}//')"
		folge="$(grep -m 1 '^S' $directory/info | sed -r 's/^.{2}//')"
		
		filename=$serie' - '$folge
		
		mkdir -p "/net/down/serien/$serie"
		chown adreno:adreno "/net/down/serien/$serie"
		
		zaehl=0;
		for i in $directory/*.ts; do
		
			zaehl=$((zaehl + 1))
			
			if [ $zaehl = 1 ]; then
				pfad='/net/down/serien/'$serie/$filename'.ts'
				mv $i "$pfad"
				
			else
				pfad='/net/down/serien/'$serie/$filename'_'$zaehl'.ts'
				mv $i "$pfad"
			fi
			
			chown adreno:adreno "$pfad"
			
		done

		rm -R $directory
		find "$1/" -depth -type d -empty -exec rmdir {} \;
		
	fi

done
