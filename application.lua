-- file : application.lua
local module = {}  

local function listening(port_num)
    myServer = net.createServer(net.TCP,30)
    myServer:listen(port_num, function(c)
        c:on("receive", function(c,pl)
            for word in string.gmatch(pl, "%S+") do
            	if string.find(word,"/?M")~=nil then
            		print(string.sub(word,3,-1))
            		return
            	end
            end
            end)
        end)
end

uart.on("data", 4,
	function(data)
		print("receive from uart:", data)
    		if data=="quit" then
      		uart.on("data") -- unregister callback function
    		end
	end, 0)

function module.start()  
  listening(config.Port)
end

return module
