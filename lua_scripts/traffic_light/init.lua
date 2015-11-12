
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
    gpio.write(led1, gpio.LOW);
    gpio.write(led2, gpio.HIGH);
  else
    gpio.write(led1, gpio.LOW);
    gpio.write(led2, gpio.LOW);
  end
  print("set light to:"..color)
end
m_dis["/vls/traffic"]=trafficFunc

-- setup wifi
function wifiFinishCallback() -- is called when wifi is ready
  print("started the esp")

   m=mqtt.Client("nodemcu"..node.chipid(),120)
   m:lwt("/lwt", "offline: "..node.chipid(), 0, 0) --lastwill
   m:connect("mqtt.micromata.priv",1883,0)
   m:on("connect",function(m)
     print("connected to mqtt broker")
     m:subscribe("/vls/traffic",0,function(m) print("sub to traffic done") end)
     tmr.alarm(0,1000*60*15,0,function()
        print("Restarting node cause of offline bug")
       node.restart()
     end)

   end)
   m:on("message",dispatch )

  collectgarbage()
end --eo wifiFinishCallback
wifiCfg=require('wifiCfg')
wifiCfg.setup(wifiFinishCallback)
wifiCfg=nil
package.loaded["wifiCfg"]=nil
collectgarbage()
--eo wifi
