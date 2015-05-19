# esp8266
Here i collect all the stuff i found out about the esp8266

gtkterm

ESP8266 supports firmware updates over the same serial interface with a few changes to the setup — you need to pull the GPIO0 pin to ground and use a 115200 baud rate from Teensy to the module.

sudo python esptool.py --port /dev/ttyUSB0  write_flash 0x00000 ../nodemcu_latest.bin

ESPlorer:http://esp8266.ru/esplorer/
