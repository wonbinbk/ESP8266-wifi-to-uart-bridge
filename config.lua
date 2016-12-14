-- file : config.lua
local module = {}

module.SSID = {}  
module.SSID["sample"] = "sample" --Used in case we want ESP to connect to router.
--For Access Point mode-------
module.APSSID = "ESP8266"
module.APPASS = "12345678"
module.APPSK = "wifi.WPA_PSK"
------------------------------  
--Port number to listen to----
module.Port = 1999
return module 
