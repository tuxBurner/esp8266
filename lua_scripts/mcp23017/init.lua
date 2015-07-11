-- make ist fast :)
--uart.setup(0,115200,8,0,1,1,PERMANENT)
-- mcp starts here
mcp = require("mcp23017")
mcp.init(3,4)

--mcp.setPin(8,1)
--mcp.setPin(9,1)
local compileAndRemoveIfNeeded = function(f)
   if file.open(f) then
      file.close()
      print('Compiling:', f)
      node.compile(f)
      file.remove(f)
      collectgarbage()
   end
end
local serverFiles = {'httpserver.lua', 'httpserver-request.lua', 'httpserver-static.lua', 'httpserver-header.lua', 'httpserver-error.lua'}
for i, f in ipairs(serverFiles) do compileAndRemoveIfNeeded(f) end
compileAndRemoveIfNeeded = nil
serverFiles = nil
collectgarbage()


function test()
  print("started the esp")
  dofile("httpserver.lc")(80)
  print('heap: ',node.heap())
  collectgarbage()
end


wifiCfg=require('wifiCfg')
wifiCfg.setup(test)
wifiCfg=nil
collectgarbage()


