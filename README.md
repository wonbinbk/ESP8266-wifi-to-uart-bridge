# ESP8266 Wifi to UART Bridge
### Description
This is a simple Wifi to UART Bridge using ESP8266 running NodeMCU.
### Usage
On first boot, ESP will create an access point with:
* SSID: **ESP8266**  
* Password: **12345678**  
* ESP8266 IP: **192.168.4.1**  

1. Connect your phone or laptop to that network.
2. Connect UART tranceiver to ESP8266 serial port UART0.
3. Basically you don't need to add ESP8266 to your current Wireless Network (other than its own access point).

### Commands
Your phone or laptop communicate with ESP8266 over UDP protocols. ESP8266 is listening at port 1999. Your phone also need to listen on UDP port 1999. ESP8266 will relay information from Wireless to UART with baudrate 115200 (the default setting). 
* Alive signal: Phone send **_@?@_** --> ESP reply **_#okay#_**
* Ask IP address: Phone send **_?IP?_** --> ESP reply with its current IP address and network
* Ask ESP to connect to other network (ex: _network_ssid_ & _password_): 
  * Phone send:  **_@sid@network_ssid_**. ESP reply **_network_ssid_**
  * Phone send:  **_@pwd@password_**. ESP reply **_password_**
  * Phone send:  **_@con@_** to ask ESP to start connecting to wireless network.
* Tell ESP phone's IP address (ex: 192.168.1.5):
  * Phone send:  **_@IP@192.168.1.5_**.
* Any others UDP message that is not recognized as command will be understand as normal message and will be transmitted untouched to UART0.
* UART0 to wifi:
  * Each UART message need to end with **_#_** and will be sent to phone via UDP port 1999.

> You will no longer be able to use normal NodeMCU lua command via UART0 unless you re-flash NodeMCU firmware.
