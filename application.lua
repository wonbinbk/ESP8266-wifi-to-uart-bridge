-- file : application.lua
local module = {}  

local function listening(port_num)
    mySrv = net.createServer(net.UDP)
    mySrv:listen(port_num)
    mySrv:on("receive", 
    	function(c,pl)
        --[[
            When receive UDP packet "@?@", send ack "#okay#
            When receive vector command, send that to uart
        --]]
    		if (pl=="@?@") then 
                mySrv:send("#okay#")
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
    Receive info from MCU
    check formatting then
    send it to phone.
--]]
uart.on("data",25,
    function(data)
        if string.find(data,
        "@%d%d%d,%d%d%d,%d%d%d@%d%d%d,%d%d%d,%d%d%d@") ~= nil 
        then print (data)
        end
    end,0)
return module
