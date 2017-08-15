# Pipeline Scripts


| Script        | Description
| ------------- |:-------------:
| get-labels.sh | Determines classes of our dataset by looking at existing folders
| 00-crawl-data.sh    | Crawls images from flickr      
| 01-annotate-all.sh | Auto-annotates all images using a trained model
| 01-annotate-none.sh | Auto-annotates images of class "none"
| 01-start-quick-decider.sh | Starts the quick decider
| 02-prepare-images.sh | Prepares dataset images for training
| 03-manually-annotate-bounding-boxes.sh | Starts Manual Annotator
| 04-train-network-docker.sh | Trains the networking using a docker container for running it
| 04-train-network.sh | Trains the SSD network
| 05-train-network-resnet101-pretrained.sh | Trains the ResNet101 network
| 05-train-network-resnet50-pretrained.sh | Trains the ResNet50 network
| 06-train-network-resnet18-pretrained.sh | Trains the ResNet18 network
| 07-train-network-resnet34-pretrained.sh | Trains the ResNet34 network
| 08-train-and-evaluate.sh | Trains the SSD network and evaluates mAP scores and false positives
| 08-train-network-resnet50-pretrained.sh | Trains the ResetNet50 network
| 09-evaluate-vis-backprop-training.sh | Evaluates training using Vis. Backprop
