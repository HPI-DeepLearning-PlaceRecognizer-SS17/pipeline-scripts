#!/bin/bash
#set -e

scriptDir="/home/place-recognizer-students/flickr-workflow"
imageDir="$scriptDir/crawled-data"

echo "Checking if server is running..."

imageRunning="`sudo docker ps | grep webscale-bounding-box`"
echo $imageRunning

if [ -z "$imageRunning" ]; then
	echo "Annotation server not running, starting it..."
	sudo docker run -d --rm -p 3011:3000 -v $imageDir:/app/images webscale-bounding-box
	echo "Server started"
fi

echo "Visit"
echo "http://172.16.18.178:3011/"
echo "to annotate images manually"

