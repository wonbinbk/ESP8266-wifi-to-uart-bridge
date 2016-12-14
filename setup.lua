-- file: setup.lua
local module = {}

local function wifi_wait_ip()  
    tmr.stop(1)
    print("Setting up Access Point ...")
    cfg={}
    cfg.ssid=config.APSSID
    cfg.pwd=config.APPASS
    wifi.ap.config(cfg)
    print("Access Point SSID: "..config.APSSID)
    app.start()
end

function module.start()  
  print("Configuring Wifi ...")
  wifi.setmode(wifi.STATIONAP);
  wifi_wait_ip();
end

return module  
