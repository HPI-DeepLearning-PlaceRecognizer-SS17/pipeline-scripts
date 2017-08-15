#!/usr/bin/env bash

rootDir="/home/place-recognizer-students/flickr-workflow"
preparedDataDir="$rootDir/prepared-images-visback"
ssdRoot="$rootDir/ssd-docker-visback"
ssdDataDir="$ssdRoot/data/berlin"
crawledDataDir="$rootDir/crawled-data"

echo "Reading Class Names..."

#numberOfClasses=$(ls -l $crawledDataDir | grep -c ^d)
#classNames="$(bash get-labels.sh $crawledDataDir)"
numberOfClasses=8
classNames="berlinerdom,brandenburgertor,fernsehturm,funkturm,none,reichstag,rotesrathaus,siegessaeule"

echo "We are having $numberOfClasses with names $classNames"

#echo "Cleaing data folders..."
#mkdir -p $ssdDataDir
#rm -rf $ssdDataDir 
#mkdir -p $ssdDataDir

#echo "Preparing Dataset..."
#python $ssdRoot/tools/prepare_dataset.py --dataset berlin --set train --target $ssdDataDir/train.lst --root $preparedDataDir
#python $ssdRoot/tools/prepare_dataset.py --dataset berlin --set val --target $ssdDataDir/val.lst --root $preparedDataDir

# Determine IP of logged in user to set up debug connection
USER_IP="`echo $SSH_CLIENT | awk '{ print $1}'`"
USER_PORT=13370
echo ""
echo "PyCharm debugger will try to connect to $USER_IP:$USER_PORT"
echo ""

# --visualBackprop
# --debugIp $USER_IP --debugPort $USER_PORT
# --pretrained ""

echo "Training Network..."
export MXNET_CUDNN_AUTOTUNE_DEFAULT=0
sudo nvidia-docker run -e MXNET_CUDNN_AUTOTUNE_DEFAULT=0 -v $ssdRoot/data:/ssd/data -v $ssdRoot/model:/ssd/model -v $ssdRoot/training-log:/ssd/training-log ssd-backprop \
	python3 /ssd/train.py --train-path /ssd/data/berlin/train.rec --val-path /ssd/data/berlin/val.rec --prefix /ssd/model/ssdberlin \
	--pretrained /ssd/model/vgg16_reduced --batch-size 32 --num-class $numberOfClasses --class-names $classNames \
        --lr 0.001 --gpus 0,1 --log /ssd/training-log/$(date +%F-%T)-train.log --end-epoch 100 \
	--freeze "^(convnofreeze).*" --visualBackprop --resume 49

