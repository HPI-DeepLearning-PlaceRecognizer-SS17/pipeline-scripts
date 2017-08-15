#!/usr/bin/env bash
rootDir="/home/place-recognizer-students/flickr-workflow"
ssdDir="$rootDir/ssd"
noneLabelDir="$rootDir/crawled-data/none"

python $ssdDir/annotate-none.py --dir $noneLabelDir --target-status autoAnnotated-Good
