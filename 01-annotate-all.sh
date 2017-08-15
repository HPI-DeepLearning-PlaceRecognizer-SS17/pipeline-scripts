#!/usr/bin/env bash

if [ -z "$1" ]; then
 	echo "ERROR: epoch needs to be provided"
	echo "Usage:"
	echo "$0 <epoch> (if unsure, use 10 by default)"
	exit 1;
fi

# Use correct environment for mxnet-ssd
workon env_anotherTry

rootDir="/home/place-recognizer-students/flickr-workflow"
dataDir="$rootDir/crawled-data"
ssdDir="$rootDir/ssd"

echo "Fetching classnames."

classNames="$(bash get-labels.sh $dataDir)"

echo "Using classes $classNames"

export MXNET_CUDNN_AUTOTUNE_DEFAULT=0

for d in $dataDir/*/ ; do
	label="$(basename $d)"
	echo "Working on $label in folder $dataDir/$label"
	python $ssdDir/annotate.py --epoch $1 --dir $dataDir/$label --classes $classNames --prefix $ssdDir/model/ssdberlin --label $label --thresh 0.95

done

