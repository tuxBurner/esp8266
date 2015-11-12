# esp8266
Here i collect all the stuff i found out about the esp8266

gtkterm

ESP8266 supports firmware updates over the same serial interface with a few changes to the setup — you need to pull the GPIO0 pin to ground and use a 115200 baud rate from Teensy to the module.


## Install Firmware
wget https://github.com/nodemcu/nodemcu-firmware/releases/download/0.9.6-dev_20150406/nodemcu_integer_0.9.6-dev_20150406.bin
sudo python esptool.py --port /dev/ttyUSB0  write_flash 0x00000 nodemcu_integer_0.9.6-dev_20150406.bin

## Tools To use
* ESPlorer:http://esp8266.ru/esplorer/ a good IDE makes life easier :)
* nodemcu-uploader: https://github.com/kmpm/nodemcu-uploader easy way to upload files
* esptool: https://github.com/themadinventor/esptool

## Links
* GitHub Repos Search: https://github.com/search?utf8=%E2%9C%93&q=nodemcu
* https://github.com/NodeUSB/nodemcu-ide has a nice idea how to pull scripts from a ws
* https://github.com/marcoskirsch/nodemcu-httpserver nice http server
* Original Firmare: http://www.electrodragon.com/w/ESP8266_AT-command_firmware
* NodeMcu Custom Builds: http://frightanic.com/nodemcu-custom-build/
* Good Blog with tips: http://randomnerdtutorials.com/
