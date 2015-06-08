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
local serverFiles = {'httpserver', 'httpserver-request', 'httpserver-static', 'httpserver-header', 'httpserver-error','wifiCfg','mcp23017'}
for i, f in ipairs(serverFiles) do compileAndRemoveIfNeeded(f..'.lua') end
compileAndRemoveIfNeeded = nil
serverFiles = nil
collectgarbage()
-- eo compile
-- setup wifi
wifiCfg=require('wifiCfg')
wifiCfg.setup()
--eo wifi
