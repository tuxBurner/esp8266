mcp = require("mcp23017")
mcp.init(3,4)
mcp.setPin(1,1)
mcp.setPin(2,1)
val = mcp.getPin(9)
print(val)

