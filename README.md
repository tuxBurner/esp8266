# esp8266
Here i collect all the stuff i found out about the esp8266

gtkterm

ESP8266 supports firmware updates over the same serial interface with a few changes to the setup — you need to pull the GPIO0 pin to ground and use a 115200 baud rate from Teensy to the module.


## Install Firmware
sudo python esptool.py --port /dev/ttyUSB0  write_flash 0x00000 ../nodemcu_latest.bin


## Tools To use
* ESPlorer:http://esp8266.ru/esplorer/ a good IDE makes life easier :)
* nodemcu-uploader: https://github.com/kmpm/nodemcu-uploader easy way to upload files

## Links
* GitHub Repos Search: https://github.com/search?utf8=%E2%9C%93&q=nodemcu
* https://github.com/NodeUSB/nodemcu-ide has a nice idea how to pull scripts from a ws
* https://github.com/marcoskirsch/nodemcu-httpserver nice http server
