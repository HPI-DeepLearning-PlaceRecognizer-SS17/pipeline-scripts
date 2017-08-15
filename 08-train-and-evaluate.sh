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
logfile="$rootDir/training-log/$(date +%F-%T)-train.log"
modelDir="$ssdRoot/model/evaluation"
noneImagesDir="$imageSourceDir/none"
modelPrefix="$modelDir/berlin-$1-$2"
csvPath="$modelPrefix.csv"
maxEpochs=50

maxNumberOfImages=$1


echo "Reading Class Names..."

numberOfClasses=$(ls -l $imageSourceDir | grep -c ^d)
classNames="$(bash get-labels.sh $imageSourceDir)"

# Clear target directory
mkdir -p $preparedDataDir
rm $preparedDataDir -r
mkdir -p $preparedDataDir

# Prepare each registered datatset
for d in $imageSourceDir/*/; do
    label="$(basename $d)"
    echo "Preparing dataset '$label'"
    sudo docker run --rm -v $imageSourceDir:/srcImg -v $preparedDataDir:/dstImg \
        prepare-images-for-ssd --sourceDir "/srcImg/$label" --targetDir "/dstImg" --label $label --maxNumberOfImages $maxNumberOfImages
done

echo "All datasets prepared"

# Fix permissions since docker runs as root
sudo chown -R place-recognizer-students:msws2016t1 $preparedDataDir

echo "We are having $numberOfClasses with names $classNames"

echo "Cleaing data folders..."
mkdir -p $ssdDataDir
rm -rf $ssdDataDir
mkdir -p $ssdDataDir

echo "Preparing Dataset..."
python $ssdRoot/tools/prepare_dataset.py --dataset berlin --set train --target $ssdDataDir/train.lst --root $preparedDataDir
python $ssdRoot/tools/prepare_dataset.py --dataset berlin --set val --target $ssdDataDir/val.lst --root $preparedDataDir

# Make ssd-dir
mkdir -p $modelDir

echo "Training Network..."
export MXNET_CUDNN_AUTOTUNE_DEFAULT=0
python $ssdRoot/train.py --train-path $ssdDataDir/train.rec --val-path $ssdDataDir/val.rec --prefix $modelPrefix --pretrained $ssdRoot/model/vgg16_reduced --batch-size 96 --num-class $numberOfClasses --class-names $classNames --lr 0.002 --gpus $gpus --log $logfile --end-epoch $maxEpochs

echo "Reading training log file.."
python $ssdRoot/parse_logs.py $logfile $csvPath

for i in $(seq 1 $maxEpochs);
do
        echo "Evaluating epoch $i"
        python $ssdRoot/evaluate_and_write_csv.py --false-positives-image-folder $noneImagesDir --class-names $classNames --num-class $numberOfClasses --prefix $modelPrefix  --epoch $i --false-postives-image-count 300 --gpus $eval_gpu --false-positives-thresholds 0.0,0.5,0.75,0.9,0.99
done

