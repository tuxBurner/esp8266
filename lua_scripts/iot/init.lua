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

handleReq = require("http_index")

-- setup wifi
function wifiFinishCallback() -- is called when wifi is ready
  print("started the esp")
  httpserver=require('http_server')
  httpserver.init(80,handleReq)
  collectgarbage()
end --eo wifiFinishCallback
wifiCfg=require('wifiCfg')
wifiCfg.setup(wifiFinishCallback)
wifiCfg=nil
collectgarbage()
--eo wifi
