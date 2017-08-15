#!/usr/bin/env bash

rootDir="/home/place-recognizer-students/flickr-workflow"
preparedDataDir="$rootDir/prepared-images"
ssdRoot="$rootDir/ssd"
ssdDataDir="$ssdRoot/data/berlin"
crawledDataDir="$rootDir/crawled-data"

echo "Reading Class Names..."

numberOfClasses=$(ls -l $crawledDataDir | grep -c ^d)
classNames="$(bash get-labels.sh $crawledDataDir)"

echo "We are having $numberOfClasses with names $classNames"

echo "Cleaing data folders..."
mkdir -p $ssdDataDir
rm -rf $ssdDataDir 
mkdir -p $ssdDataDir

echo "Preparing Dataset..."
python $ssdRoot/tools/prepare_dataset.py --dataset berlin --set train --target $ssdDataDir/train.lst --root $preparedDataDir
python $ssdRoot/tools/prepare_dataset.py --dataset berlin --set val --target $ssdDataDir/val.lst --root $preparedDataDir
 
echo "Training Network..."
export MXNET_CUDNN_AUTOTUNE_DEFAULT=0
python $ssdRoot/train.py --train-path $ssdDataDir/train.rec --val-path $ssdDataDir/val.rec --prefix $ssdRoot/model/ssdberlin --pretrained $ssdRoot/model/vgg16_reduced --batch-size 96 --num-class $numberOfClasses --class-names $classNames --lr 0.002 --gpus 0,1 --log $rootDir/training-log/$(date +%F-%T)-train.log --end-epoch 50
