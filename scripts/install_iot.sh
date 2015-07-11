#!/bin/bash

######################################################
### Downloads the lua http server and installs it ###
#####################################################

# include the env vars
. ./envVars.sh

################################################
### Uploads the iot files to the esp ###
################################################
function uploadIot() {

  local files=( 'iot/init.lua' 'wifi_config/wifiCfg.lc' 'wifi_config/wifi_cfg.json')
  local upl_files=""
  for i in "${files[@]}"
  do
       upl_files="$upl_files ../lua_scripts/$i:${i##*/}"
  done
  uploadToESP "$upl_files"
}

uploadIot
