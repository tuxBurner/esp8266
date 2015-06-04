-- make ist fast :)
--uart.setup(0,115200,8,0,1,1,PERMANENT)
f = "mcp23017.lua"
if file.open(f) then
      file.close()
      print('Compiling:', f)
      node.compile(f)
      file.remove(f)
      collectgarbage()
end
mcp = require("mcp23017")
mcp.init(3,4)
-- set pin to input
mcp.setUpPin(9,1,1)
start = -1
function showButtons()
  -- negate the output
  local state = mcp.getPin(9)
  if(state == 1)then
    local now =  tmr.now()
    local diff = tmr.now() - start
    if(start < 0 or diff > 1000000) then      
      local ledState = mcp.getPin(1)    
      mcp.setPin(1,bit.bxor(ledState,1))
      start = now
    end  
  else  
    start = -1
  end  
end
tmr.alarm(0,50,1,showButtons) -- run showButtons() every 2 seconds
