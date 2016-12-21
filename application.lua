-- file : application.lua
local module = {}  
local peer_IP
local uart_flush --just a place to dump unwanted uart data.

local function listening(port_num)
    mySrv = net.createServer(net.UDP)	
    mySrv:listen(port_num)
    mySrv:on("receive", 
    	function(c,pl)
        --[[
            When receive UDP packet "@?@", send ack "#okay#
            When receive vector command, send that to uart
            When receive @IP@192.168.1.4 save that IP.
        --]]
    		if (pl=="@?@") then 
                	mySrv:send("#okay#")
                elseif string.find(pl,"@IP@") ~=nil then
                	peer_IP = string.sub(pl,5)
                	mySrv:send("your IP= " .. peer_IP)
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
