-- file : init.lua
app = require("application")  
setup = require("setup")
function startup_delay_5s()
    print("Delay 5s...")    
    setup.start()
end
tmr.alarm(0,5000,0,startup_delay_5s)
