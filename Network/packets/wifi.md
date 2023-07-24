# WiFi

## Terminology

| | |
|-|-|
|**AP**|This is the access point or router where clients connect.|
|**PSK**|Pre-Shared Key. This is the password used to authenticate with the AP.|
|**SSID**|Service Set Identifier. The name used to identify the AP.|
|**ESSID**|Extended Service Set Identifier. This is the same as the SSID by can be used for multiple APs in a wireless LAN.|
|**BSSID**|Basic Service Set Identifier. This is the unique identifier for the AP. This is the same as the AP MAC Address.|
|**Channel**|Wi-Fi operates on channels 1-14, but limited to 1-11 in the US.|
|**Power**|The closer you get to the AP, the stronger the signal.|
|**Security**|The security protocol to authenticate and encrypt Wi-Fi traffic (WEP, WPA-PSK)|
|**Modes**|Wi-Fi can operate in three modes: Master, Managed, Monitor.|
|**Range**|At the legal limit of 0.5 watts, most Wi-Fi APs are accessible up to 100m, but high gain antennas can reach 20 miles.|
|**Frequency**|Wi-Fi is designed to operate at 2.4GHZ and 5GHZ|


## Anatomy of a Wi-Fi frame

### Management Frames
| Type Value| Type description| Subtype value |      Subtype description    |       Wireshark filter       |
|-----------|-----------------|---------------|-----------------------------|------------------------------|
|         0 |      Management |             0 | Association request         | wlan.fc.type_subtype == 0x00 |
|         0 |      Management |             1 | Association response        | wlan.fc.type_subtype == 0x01 |
|         0 |      Management |            10 | Reassociation request       | wlan.fc.type_subtype == 0x02 |
|         0 |      Management |            11 | Reassociation response      | wlan.fc.type_subtype == 0x03 |
|         0 |      Management |           100 | Probe request               | wlan.fc.type_subtype == 0x04 |
|         0 |      Management |           101 | Probe response              | wlan.fc.type_subtype == 0x05 |
|         0 |      Management |     0110-0111 | Reserved                    |                              |
|         0 |      Management |          1000 | Beacon                      | wlan.fc.type_subtype == 0x08 |
|         0 |      Management |          1001 | AITM                        | wlan.fc.type_subtype == 0x09 |
|         0 |      Management |          1010 | Disassociation              | wlan.fc.type_subtype == 0x0A |
|         0 |      Management |          1011 | Authentication              | wlan.fc.type_subtype == 0x0B |
|         0 |      Management |          1100 | Deauthentication            | wlan.fc.type_subtype == 0x0C |
|         0 |      Management |          1101 | Action                      | wlan.fc.type_subtype == 0x0D |
|         0 |      Management |     1110-1111 | Reserved                    |                              |


### Control Frames
| Type Value| Type description| Subtype value |      Subtype description    |       Wireshark filter       |
|-----------|-----------------|---------------|-----------------------------|------------------------------|
|         1 |         Control |     0000-0111 | Reserved                    |                              |
|         1 |         Control |          1000 | Block Ack Request           | wlan.fc.type_subtype == 0x18 |
|         1 |         Control |          1001 | Block Ack                   | wlan.fc.type_subtype == 0x19 |
|         1 |         Control |          1010 | PS-Poll                     | wlan.fc.type_subtype == 0x1A |
|         1 |         Control |          1011 | RTS                         | wlan.fc.type_subtype == 0x1B |
|         1 |         Control |          1100 | CTS                         | wlan.fc.type_subtype == 0x1C |
|         1 |         Control |          1101 | ACK                         | wlan.fc.type_subtype == 0x1D |
|         1 |         Control |          1110 | CF-END                      | wlan.fc.type_subtype == 0x1E |
|         1 |         Control |          1111 | CF-END + CF-ack             | wlan.fc.type_subtype == 0x1F |


### Data Frames
| Type Value| Type description| Subtype value |      Subtype description    |       Wireshark filter       |
|-----------|-----------------|---------------|-----------------------------|------------------------------|
|        10 |            Data |             0 | Data                        | wlan.fc.type_subtype == 0x20 |
|        10 |            Data |             1 | Data + CF-Ack               | wlan.fc.type_subtype == 0x21 |
|        10 |            Data |            10 | Data + CF-Poll              | wlan.fc.type_subtype == 0x22 |
|        10 |            Data |            11 | Data + CF-Ack + CF-Poll     | wlan.fc.type_subtype == 0x23 |
|        10 |            Data |           100 | Null                        | wlan.fc.type_subtype == 0x24 |
|        10 |            Data |           101 | CF-Ack                      | wlan.fc.type_subtype == 0x25 |
|        10 |            Data |           110 | CF-Poll                     | wlan.fc.type_subtype == 0x26 |
|        10 |            Data |           111 | CF-Ack + CF-Poll            | wlan.fc.type_subtype == 0x27 |
|        10 |            Data |          1000 | Qos Data                    | wlan.fc.type_subtype == 0x28 |
|        10 |            Data |          1001 | Qos Data + CF-ack           | wlan.fc.type_subtype == 0x29 |
|        10 |            Data |          1010 | Qos Data + CF-Poll          | wlan.fc.type_subtype == 0x2A |
|        10 |            Data |          1011 | Qos Data + CF-ack + CF-Poll | wlan.fc.type_subtype == 0x2B |
|        10 |            Data |          1100 | Qos Null                    | wlan.fc.type_subtype == 0x2C |
|        10 |            Data |          1101 | Reserved                    | wlan.fc.type_subtype == 0x2D |
|        10 |            Data |          1110 | Qos + CF-Poll (No data)     | wlan.fc.type_subtype == 0x2E |
|        10 |            Data |          1111 | Qos + CF-Ack (No data)      | wlan.fc.type_subtype == 0x2F |
|        11 |        Reserved |     0000-1111 | Reserved                    |                              |

### Different frame types

1. An **Association request** is sent by a station to associate with a BSS  
*wlan.fc.type == 0x00*

2. An **Association response** is sent in response to an association request.  
*wlan.fc.type == 0x01*

3. A **Reassociation** request is sent by a station changing association with another AP in the same ESS (roaming between APs)  
*wlan.fc.type == 0x02*

4. **Reassociation response** is the response to the reassociation request  
*wlan.fc.type == 0x03*

5. **Probe request** is sent by a station in order to scan for an SSID  
*wlan.fc.type == 0x04*

6. **Probe response** is sent by each BSS participating to that SSID  
*wlan.fc.type == 0x05*

7. **Beacon** is a periodic frame sent by the AP and gives information about the BSS  
*wlan.fc.type == 0x08*

8. **ATIM** is the traffic indication map for IBSS  
*wlan.fc.type == 0x09*

9. **Disassociation** is sent to terminate the association of a station  
*wlan.fc.type == 0x0A*

10. **Authentication** is the frame used to perform 802.11 authentication  
*wlan.fc.type == 0x0B*

11. **Deauthentication** is the frame terminating the authentication of a station. This frame is often used in attack tools to bump users off the AP.  
*wlan.fc.type == 0x0C*

12. An **Action** frame is used for sending information to other stations  
*wlan.fc.type == 0x0D*

13. **PS-Poll** is the power save frame polling for buffered frames after a wake-up from a station  
*wlan.fc.type == 0x1A*

14. **RTS** is the request to send a frame  
*wlan.fc.type == 0x1B*

15. **CTS** is the clear-to-send frame (usually a response to RTS)  
*wlan.fc.type == 0x1C*

16. **ACK** is the acknowledgement frame sent to confirm receipt of a frame  
*wlan.fc.type == 0x1D*

17. **Data frame** is a frame containing data  
*wlan.fc.type == 0x20*

18. **Null frame** is a frame meant to contain no data but flag information  
*wlan.fc.type == 0x24*

19. **QoS Data** is the Quality of Service version of the data frame  
*wlan.fc.type == 0x28*

20. **QoS null** is the Quality of Service version of the null frame  
*wlan.fc.type == 0x2C*


