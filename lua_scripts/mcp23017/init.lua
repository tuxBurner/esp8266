-- make ist fast :)
--uart.setup(0,115200,8,0,1,1,PERMANENT)
mcp = require("mcp23017")
mcp.init(3,4)
mcp.setPin(1,1)
-- set pin to input
mcp.setUpPin(9,1,1)
function showButtons()
  local state = mcp.getPin(9)
  if(state == 0) then
    print(node.heap())
  end
end
tmr.alarm(0,100,1,showButtons) -- run showButtons() every 2 seconds
