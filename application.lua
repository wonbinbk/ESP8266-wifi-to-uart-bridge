-- file : application.lua
local module = {}  
local peer_IP
local uart_flush --just a place to dump unwanted uart data.

local station_cfg = {}
station_cfg.ssid = ""	--Name of wifi access point.
station_cfg.pwd = ""	--Password of wifi AP.
station_cfg.save = false 

local Wifi={}

local function listening(port_num)
    if station_cfg.ssid ~= "" then
    	wifi.sta.config(station_cfg)
    end	
    mySrv = net.createServer(net.UDP)	
    mySrv:listen(port_num)
    mySrv:on("receive", 
    	function(c,pl)
        --[[
            When receive UDP packet "@?@", send ack "#okay#
            When receive vector command, send that to uart
            When receive @IP@192.168.1.4 save that IP.
        --]]
        --[[
            Configure ESP in station mode using these commands:
            @sid@wifi_ssid: connect to wifi_ssid
            @pwd@password: using password "password"
            ESP will then save these values to rom for next boot up.
        --]]
    		if (pl=="@?@") then 
                	mySrv:send("#okay#")
                elseif string.find(pl,"@IP@") ~=nil then
                	peer_IP = string.sub(pl,5)
                	mySrv:send("Your IP= " .. peer_IP)
                elseif string.find(pl,"?IP?") ~= nil then
                	if wifi.sta.getip() ==nil then
                		mySrv:send("No station IP, check SSID and PWD in station mode")
                	else
                		Wifi = wifi.sta.getconfig(true)
                		mySrv:send(
		    		"Connected to "..Wifi.ssid.."\n\r"..
		    		"Station IP: "..
		    		wifi.sta.getip())
                	end
            	elseif string.find(pl,"@sid@") ~= nil then
            		station_cfg.ssid = string.sub(pl,6)
            		mySrv:send(station_cfg.ssid)
       		elseif string.find(pl,"@pwd@") ~= nil then
       			station_cfg.pwd = string.sub(pl,6)
       			mySrv:send(station_cfg.pwd)
            	elseif string.find(pl,"@con@") ~= nil then
            		if wifi.sta.getip() ~= nil then
            		Wifi = wifi.sta.getconfig(true)
            		mySrv:send(
            		"Connected to "..Wifi.ssid.."\n\r"..
            		"Station IP: "..
            		wifi.sta.getip()) 
            		elseif station_cfg.ssid == "" then mySrv:send("Check SSID")
            		else
            			--if have ssid and doesn't have ip yet, connect to that ssid
            			--and send IP address to peer
            			wifi.sta.config(station_cfg)
				tmr.alarm(1, 1000, 1, 
					function()
				    	if wifi.sta.getip() == nil then 
						mySrv:send("Wait for IP...")
				    	else 
				    		mySrv:send("Station IP: "..wifi.sta.getip())
						tmr.stop(1)			
				    	end
					end)
			end           		
            	else
                	print(pl)
            	end
    	end
    	)
end

function module.start()  
    print("listening on port " .. setup.port)
    listening(setup.port)
end

--[[
    *** Need revised ****
    Receive data on UART.
    If data end with '#' then send the data to peer
    all other case will go into lua interpreter
--]]
-- Execute command if end with line feed 
-- Transfer data end with #
uart.on("data","#",
    function(data)
	conn = net.createConnection(net.UDP,0)
	conn:connect(1999, peer_IP)
	conn:send(string.sub(data,1,-2))
	conn:close()
	--uart.on("data")
    end,0)
    
return module
