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

mcp = require("mcp23017")
mcp.init(3,4)

function handleReq(cn,params)
  for name, value in pairs(params) do
   mcp.setPin(tonumber(name),tonumber(value))
  end
  cn:send("<form method=\"get\"><ol>")
  for i=1,16 do 
    local state = mcp.getPin(i)
    local opState = 0
    if state == 0 then opState = 1 end 
    cn:send("<li><button name=\""..i.."\" value=\""..opState.."\">"..state.."</button></li>")
  end
  cn:send("</ol></form>")
  collectgarbage()
end

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
