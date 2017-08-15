#!/usr/bin/env bash
# Exit script on error

echo "Usage: 08-train-and-evaluate.sh <NUMBER OF IMAGES> <NAME>"

set -e

eval_gpu=0
gpus="0,1"
rootDir="/home/place-recognizer-students/flickr-workflow"
preparedDataDir="$rootDir/prepared-images"
ssdRoot="$rootDir/ssd"
ssdDataDir="$ssdRoot/data/evaluation"
imageSourceDir="$rootDir/crawled-data"
logfile="/home/place-recognizer-students/flickr-workflow/ssd-docker-visback/training-log/2017-07-16-11:58:45-train.log"
modelDir="/home/place-recognizer-students/flickr-workflow/ssd-docker-visback/model"
noneImagesDir="$imageSourceDir/none"
modelPrefix="$modelDir/ssdberlin"
csvPath="$modelDir/ssdberlin.csv"
maxEpochs=79

maxNumberOfImages=$1


echo "Reading Class Names..."

numberOfClasses=$(ls -l $imageSourceDir | grep -c ^d)
classNames="$(bash get-labels.sh $imageSourceDir)"

echo "Reading training log file.."
python $ssdRoot/parse_logs.py $logfile $csvPath

for i in $(seq 1 $maxEpochs);
do
        echo "Evaluating epoch $i"
        python $ssdRoot/evaluate_and_write_csv.py --false-positives-image-folder $noneImagesDir --class-names $classNames --num-class $numberOfClasses --prefix $modelPrefix  --epoch $i --false-postives-image-count 300 --gpus $eval_gpu --false-positives-thresholds 0.0,0.5,0.75,0.9,0.99
done

