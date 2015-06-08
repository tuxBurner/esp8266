#!/bin/bash

######################################################
### Downloads the lua http server and installs it ###
#####################################################

# include the env vars
. ./envVars.sh




#################################################
### Checkout the http-server from github ###
#################################################
HTTP_SERVER_DIR=$DATA_DIR"/httpserver"
function getOrUpdateHttpServer() {
  cloneOrUpdateGit "https://github.com/marcoskirsch/nodemcu-httpserver.git" $HTTP_SERVER_DIR
}

################################################
### Uploads the http server files to the esp ###
################################################
function uploadHttpServer() {
  local http_files=( 'httpserver.lua' 'httpserver-request.lua' 'httpserver-static.lua' 'httpserver-header.lua' 'httpserver-error.lua' )
  local http_upl_files=""
  for i in "${http_files[@]}"
  do
  	http_upl_files="$http_upl_files $HTTP_SERVER_DIR/$i:$i"
  done
  uploadToESP "$http_upl_files"
}
getOrUpdateHttpServer
uploadHttpServer
