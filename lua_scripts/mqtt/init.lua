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


led1 = 3
led2 = 4
gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)
gpio.write(led1, gpio.HIGH);
gpio.write(led2, gpio.HIGH);
m_dis={}
function dispatch(m,t,pl)
    if pl~=nil and m_dis[t] then
        m_dis[t](m,pl)
    end
end
function trafficFunc(m,pl)
  local color = pl
  if(color == nil) then
    color = "red"
  end
  if(color == "red") then
    gpio.write(led1, gpio.HIGH);
    gpio.write(led2, gpio.HIGH);
  elseif(color == "orange") then
    gpio.write(led1, gpio.HIGH);
    gpio.write(led2, gpio.LOW);
  else
    gpio.write(led1, gpio.LOW);
    gpio.write(led2, gpio.HIGH);
  end
  print("set light to:"..color)
end
m_dis["/traffic"]=trafficFunc


-- setup wifi
function wifiFinishCallback() -- is called when wifi is ready
  print("started the esp")

   m=mqtt.Client("nodemcu"..node.chipid(),60)   
   m:lwt("/lwt", "offline: "..node.chipid(), 0, 0) --lastwill
   m:connect("192.168.0.2",1883,0)
   m:on("connect",function(m)
     print("connected to mqtt broker")
     m:subscribe("/traffic",0,function(m) print("sub done") end)
   end)
   m:on("message",dispatch )

  collectgarbage()
end --eo wifiFinishCallback
wifiCfg=require('wifiCfg')
wifiCfg.setup(wifiFinishCallback)
wifiCfg=nil
collectgarbage()
--eo wifi
