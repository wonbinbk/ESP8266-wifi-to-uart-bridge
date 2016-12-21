-- file: setup.lua
local module = {}

ap_cfg={}
ap_cfg.ssid = "ESP8266"
ap_cfg.pwd = "12345678"

station_cfg = {}
station_cfg.ssid = ""	--Name of wifi access point.
station_cfg.pwd = ""	--Password of wifi AP. 

module.port = "1999"     --socket UDP.

local function wifi_wait_ip()  
    tmr.stop(1)
    print("Setting up Access Point ...")
    wifi.ap.config(ap_cfg)
    print("Access Point SSID: "..ap_cfg.ssid)
    print("Access Point Pass: "..ap_cfg.pwd)
end

function module.start()  
  print("Configuring Wifi ...")
  wifi.setmode(wifi.STATIONAP)
  wifi_wait_ip()
  app.start()	
end

return module  
