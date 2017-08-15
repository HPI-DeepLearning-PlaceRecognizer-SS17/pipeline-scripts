#!/bin/bash
set -e

echo ""
echo "Download data to train SSD"
echo "Usage: $0 <labelName> <numberOfPages> \"<searchTerm>\""
echo " (1 Page = 10 Images)"
echo ""

labelName=$1
if [ -z "$labelName" ]; then
  echo "ERROR: Label name must not be empty" 
  exit 1
fi

numberOfPages=$2
if [ -z "$numberOfPages" ]; then
  echo "ERROR: Number of pages must not be empty"
  exit 1
fi

searchTerm=$3
if [ -z "$searchTerm" ]; then
  echo "ERROR: Search term must not be empty"
  exit 1
fi

echo "Label name:      $labelName"
echo "Number of pages: $numberOfPages"
echo "Search term:     $searchTerm"

# Create folder for images
scriptDir="`pwd`"
imageDir="$scriptDir/crawled-data/$labelName"

echo "Will download into $imageDir"
mkdir -p $imageDir

# Run the downloader
sudo docker run -d --rm -ti -v $imageDir:/imageDest fetch-flickr \
	--flickrApiKey 3fbe116ecc87c7c71f00bd27022813b3 \
	--flickrApiSecret 1eea7683a48dab0c \
	--search "$searchTerm" \
	--dest "/imageDest" \
	--maxPages $numberOfPages

sudo chown -R place-recognizer-students:msws2016t1 $imageDir
