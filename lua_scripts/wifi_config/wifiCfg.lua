------------------------------------------------------------------------------
 -- WIFI-CFG Module
--
-- LICENCE: http://opensource.org/licenses/MIT
-- Sebastian Hardt
-----------------------------------------------------------------------------
local moduleName = ... 
local M = {}
_G[moduleName] = M 
-- the current cfg
local wifiConfig={}
--reads the cfg file
local readCfg = function()   
  local wifiCfg=nil
  if file.open('wifi_cfg.json','r') then
    local continue = true
    local fileData = ''
    while continue do
      local line = file.readline()
      if line == nil then
        continue = false
      else
        fileData = fileData..line      
      end  
    end
    file.close()
    file=nil
    wifiCfg = cjson.decode(fileData)
    fileData=nil 
  end
  collectgarbage()  
  return wifiCfg
end
local isEmpty =  function(toTest)
 if toTest == nil or toTest == '' then
   return true
 end
 return false
end
local setupCfg = function()
  local jsonCfg = readCfg()  
  wifiConfig.mode = wifi.SOFTAP -- mixed mode
  wifiConfig.accessPointConfig = {} --reset data
  wifiConfig.stationPointConfig = {} --reset data
  if jsonCfg.st.en == true and isEmpty(jsonCfg.st.pwd) == false and isEmpty(jsonCfg.st.ssid) == false then
    wifiConfig.mode = wifi.STATION
   if jsonCfg.ap.en == true then
     wifiConfig.mode = wifi.STATIONAP
   end  
   wifiConfig.stationPointConfig.ssid = jsonCfg.st.ssid
   wifiConfig.stationPointConfig.pwd =  jsonCfg.st.pwd
  end
  if jsonCfg.ap.en == true then   
   if isEmpty(jsonCfg.ap.ssid) == true then
     wifiConfig.accessPointConfig.ssid = "ESP-"..node.chipid()
   else
     wifiConfig.accessPointConfig.ssid = jsonCfg.ap.ssid
   end
   if isEmpty(jsonCfg.ap.pwd) == true then
     wifiConfig.accessPointConfig.pwd = "ESP-"..node.chipid()
   else
     wifiConfig.accessPointConfig.pwd = jsonCfg.ap.pwd
   end
  end  
  jsonCfg=nil
  collectgarbage()
end --eo setupCfg
local callBackHandler = function(callback)
  if(not callback) then  
    return
  end
  if wifi.getmode() == wifi.SOFTAP then -- when in softap mode no need to start timer
    callback()
    collectgarbage()
    return
  end
  local joinCounter = 0
  local joinMaxAttempts = 5
  tmr.alarm(0, 3000, 1, function()
    local ip = wifi.sta.getip()
    if ip == nil and joinCounter < joinMaxAttempts then
      print('Connecting to WiFi Access Point ...')
      joinCounter = joinCounter +1
    else
      if joinCounter == joinMaxAttempts then
        print('Faild to connect to WiFi Access Point.')
      else
        print('IP: ',ip)
        callback()
        collectgarbage()
      end
      tmr.stop(0)
      joinCounter = nil
      joinMaxAttempts = nil
      collectgarbage()
    end
  end)--eo tmr
end --eo callBackHandler
-- restarts all wifi settings
M.setup = function(callback)
  setupCfg()
  wifi.setmode(wifiConfig.mode)
  print('set (mode='..wifi.getmode()..')')
  print('MAC: ',wifi.sta.getmac())
  print('chip: ',node.chipid())
  print('heap: ',node.heap())
  if  wifiConfig.mode == wifi.STATIONAP or wifiConfig.mode == wifi.SOFTAP then
    wifi.ap.config(wifiConfig.accessPointConfig) 
  end  
  if  wifiConfig.mode == wifi.STATIONAP or wifiConfig.mode == wifi.STATION then
    wifi.sta.config(wifiConfig.stationPointConfig.ssid, wifiConfig.stationPointConfig.pwd)    
  end
  collectgarbage()  
  callBackHandler(callback)
end
return M 
