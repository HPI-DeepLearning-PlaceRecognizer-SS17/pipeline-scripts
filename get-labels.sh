#!/bin/bash

firstLine=true
for d in $1/*/ ; do
	label="$(basename $d)"
	if [ $firstLine = false ]; then
                printf ","
        fi
	firstLine=false
	printf "$label"
done
