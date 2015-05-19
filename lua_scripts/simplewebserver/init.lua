wifi.setmode(wifi.STATION)
wifi.sta.config("suckOnMe","leatomhannes")
print(wifi.sta.getip())
led1 = 3
led2 = 4
gpio.mode(led1, gpio.OUTPUT,gpio.PULLUP)
gpio.write(led1, gpio.LOW);
gpio.mode(led2, gpio.OUTPUT,gpio.PULLUP)
gpio.write(led2, gpio.LOW);
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
        buf = buf.."<h1> ESP8266 Web Server</h1>";
        buf = buf.."<p>RED <a href=\"?color=RED\"><button>ON</button></a></p>";
        buf = buf.."<p>GREEN <a href=\"?color=GREEN\"><button>ON</button></a></p>";
        if(_GET.color == "RED")then
              gpio.write(led2, gpio.LOW);
              gpio.write(led1, gpio.HIGH);
        elseif(_GET.color == "GREEN")then
              gpio.write(led1, gpio.LOW);
              gpio.write(led2, gpio.HIGH);
        end
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)
