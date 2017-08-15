#!/bin/bash

# Exit script on error
set -e

# Ensure correct paths
cd ~/flickr-workflow
imageSourceDir="$PWD/crawled-data"
imageTargetDir="$PWD/prepared-images-visback"
maxNumberOfImages=2000

# Clear target directory
mkdir -p $imageTargetDir
rm $imageTargetDir -r
mkdir -p $imageTargetDir

# Prepare each registered datatset
for d in $imageSourceDir/*/; do 
	label="$(basename $d)"
	echo "Preparing dataset '$label'"
	sudo docker run --rm -v $imageSourceDir:/srcImg -v $imageTargetDir:/dstImg \
        prepare-images-for-ssd --sourceDir "/srcImg/$label" --targetDir "/dstImg" --label $label --maxNumberOfImages $maxNumberOfImages --valPercentage 10

done

echo "All datasets prepared"

# Fix permissions since docker runs as root
sudo chown -R place-recognizer-students:msws2016t1 $imageTargetDir

