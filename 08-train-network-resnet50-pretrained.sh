#!/usr/bin/env bash

rootDir="/home/place-recognizer-students/flickr-workflow"
preparedDataDir="$rootDir/prepared-images"
ssdRoot="$rootDir/ssd"
ssdDataDir="$ssdRoot/data/berlin_10_07_2017"
crawledDataDir="$rootDir/crawled-data"

#echo "Reading Class Names..."

#numberOfClasses=$(ls -l $crawledDataDir | grep -c ^d)
#classNames="$(bash get-labels.sh $crawledDataDir)"

#echo "We are having $numberOfClasses with names $classNames"

echo "Training Network..."
export MXNET_CUDNN_AUTOTUNE_DEFAULT=0
python train.py --train-path $ssdDataDir/train.rec --val-path $ssdDataDir/val.rec --prefix $ssdRoot/model/ssdResNet50_allcl --pretrained imagenet1k-resnet-50 --epoch 0 --batch-size 8 --num-class 8 --class-names berlinerdom,brandenburgertor,fernsehturm,funkturm,none,reichstag,rotesrathaus,siegessaeule --lr 0.002 --gpus 0 --log $rootDir/training-log/$(date +%F-%T)-train_resnet50_allcl.log --end-epoch 30 --network resnet50 --begin-epoch 7
