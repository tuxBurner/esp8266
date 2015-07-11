mcp = require("mcp23017")
mcp.init(3,4)
return function(cn,params)
  for name, value in pairs(params) do
   mcp.setPin(tonumber(name),tonumber(value))
  end
  cn:send(", \"mcpInfo\" : {" )
  local com = ""
  for i=1,16 do 
    local state = mcp.getPin(i)
    cn:send(com.."\""..i.."\":"..mcp.getPin(i))
    com=","
  end
  cn:send("}")
  collectgarbage()
end
