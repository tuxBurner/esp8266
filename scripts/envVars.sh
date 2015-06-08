#!/bin/bash

##########################
### Holds the settings ###
##########################

# UART DEV
ESP_PORT="/dev/ttyUSB0"

# UART SPEED
ESP_SPEED=9600

# base dir
BASE_DIR=$PWD

# data dir
DATA_DIR=$BASE_DIR"/_data"
if [ ! -d $DATA_DIR ]
then
  echo "Data dir: $DATA_DIR does not exist creating it"
  mkdir $DATA_DIR
fi

# LINK TO THE NODEMCU Firmware
NODEMCU_FMW="https://github.com/nodemcu/nodemcu-firmware/releases/download/0.9.6-dev_20150406/nodemcu_integer_0.9.6-dev_20150406.bin"

# path for the esptool
ESP_TOOL_DIR=$DATA_DIR"/esptool"

# path for nodemcu-uploader
NODEMCU_UPLOADER_DIR=$DATA_DIR"/nodemcu-uploader"

##############################################################
### Checks out a git repo when not existing or updates it ###
### param1: the url to the repo                           ###
### param2: the destination dir                           ###
#############################################################
function cloneOrUpdateGit() {
  local repo_url=$1
  local dest_dir=$2
  if [ ! -d $dest_dir ]
  then
    echo "Git dest_dir does not exist clone the repo:"
    git clone $repo_url $dest_dir
  else
    echo "Git repo already cloned update it"
    cd $dest_dir
    git pull origin master
    cd  $BASE_DIR
  fi
}

#################################################
### Checkout the nodemcu-uploader from github ###
#################################################
function getOrUpdateNodemcuUploader() {
  cloneOrUpdateGit "https://github.com/kmpm/nodemcu-uploader.git" $NODEMCU_UPLOADER_DIR
}

##########################################################
### Uloads files to the esp                            ###
### param1: files to upload check nodemcu-uploader doc ###
##########################################################
function uploadToESP() {
  getOrUpdateNodemcuUploader
  local files_to_upload=$1
  $NODEMCU_UPLOADER_DIR/nodemcu-uploader.py -b $ESP_SPEED -p $ESP_PORT upload $files_to_upload
}
