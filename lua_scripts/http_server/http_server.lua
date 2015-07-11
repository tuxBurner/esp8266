------------------------------------------------------------------------------
-- http server module
--
-- LICENCE: http://opensource.org/licenses/MIT
-- Sebastian Hardt
-----------------------------------------------------------------------------
local moduleName = ...
local M = {}
_G[moduleName] = M

local _requestHandler = nil
local split = function(str, splitOn)
    if (splitOn=='') then return false end
    local pos,arr = 0,{}
    for st,sp in function() return string.find(str,splitOn,pos,true) end do
        table.insert(arr,string.sub(str,pos,st-1))
        pos = sp + 1
    end
    table.insert(arr,string.sub(str,pos))
    pos = nil
    collectgarbage()
    return arr
end --eo  split
local getHttpReq = function (instr)
	local t = {}
	local str = string.sub(instr, 0, 200)
	local v = string.gsub(split(str, ' ')[2], '+', ' ')
	local parts = split(v, '?')
	local params = {}
	if (table.maxn(parts) > 1) then
		for idx,part in ipairs(split(parts[2], '&'))  do
			parmPart = split(part, '=')
			params[parmPart[1]] = parmPart[2]
		end
	end
  t = nil
  str = nil
  v = nil
  parts = nil
  collectgarbage()
  return params
end
local connect = function (conn, data)
  conn:on ("receive", function (cn, req_data)
    local params = getHttpReq (req_data)
    cn:send("HTTP/1.1 200/OK\r\nServer: NodeLuau\r\nContent-Type: text/json\r\n\r\n")
    cn:send("{ chipInfo : { chipId: "..node.chipid())
    cn:send(", heap: "..node.heap())
    cn:send("}")
    if(_requestHandler) then
      _requestHandler(cn,params)
    end
    cn:send("}")
    params = nil
    collectgarbage()
    cn:close ( )
  end)
end -- eo connect

M.init = function(port,requestHandler) -- inits the server
  _requestHandler = requestHandler
  svr = net.createServer (net.TCP, 30)
  svr:listen (port, connect)
  print("Http server started on port: ",port)
  collectgarbage()
end --eo init

return M
