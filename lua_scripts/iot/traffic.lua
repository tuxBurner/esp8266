led1 = 3
led2 = 4
gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)
gpio.write(led1, gpio.HIGH);
gpio.write(led2, gpio.HIGH);
return function(cn,params)
  local color = params["color"] 
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
  
  cn:send(", \"trafficInfo\" : {" )
  cn:send("\"pin1\" : "..gpio.read(led1))  
  cn:send(",\"pin2\" : "..gpio.read(led2))  
  cn:send(",\"color\" : \""..color.."\"")  
  cn:send("}")
  
end