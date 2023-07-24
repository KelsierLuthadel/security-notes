# Monitor mode
Either:   
```
airmon-ng start wlan0
```

Or:  
```
ifconfig wlan0 down
iwconf wlan0 mode monitor
ifconfig wlan0 up
```

# Create a fake AP

First, make sure the interface is in [monitor mode](#monitor-mode)


`mdk3 <interface> b -c <channel> -f <file>`   
`mdk3 <interface> b -n <ssid> -g -t -m`

Where:   
`<interface>`   - The interface that is being used to serve the fake AP   
`<channel>`     - The channel to transmit on   
`<file>`        - A file containing SSIDs   
`<ssid>`        - An SSID to assign to the AP   
`-g`            - Show AP as 54 Mbit.   
`-t`            - Show AP using WPA TKIP encryption   
`-m`            - Assign a valid MAC addresses from the OUI database

example:
`mdk3 wlan0mon b -c 11 -f fake-net.txt`    
`mdk3 wlan0mon b -n free-internet -g -t -m`   