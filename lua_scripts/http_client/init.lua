-- checks if we have some lua files and compiles it
local compileAndRemoveIfNeeded = function(f)
   if file.open(f) then
      file.close()
      print('Compiling:', f)
      node.compile(f)
      file.remove(f)
      collectgarbage()
   end
end
local serverFiles = {'http_server','wifiCfg','mcp23017'}
for i, f in ipairs(serverFiles) do compileAndRemoveIfNeeded(f..'.lua') end
compileAndRemoveIfNeeded = nil
serverFiles = nil
collectgarbage()
-- eo compile

-- setup wifi
function wifiFinishCallback() -- is called when wifi is ready
  print("started the esp")
  sk=net.createConnection(net.TCP, 0) 
  sk:on("receive", function(sck, c) print(c) end )
  sk:connect(80,"http://raw.githubusercontent.com") 
  sk:send("GET /nodemcu/nodemcu-firmware/master/LICENSE HTTP/1.1\r\nHost: "..wifi.sta.getip().."\r\nConnection: keep-alive\r\nAccept: */*\r\n\r\n")
end --eo wifiFinishCallback
wifiCfg=require('wifiCfg')
wifiCfg.setup(wifiFinishCallback)
wifiCfg=nil
collectgarbage()
--eo wifi