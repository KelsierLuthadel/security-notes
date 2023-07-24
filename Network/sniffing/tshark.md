# tshark

tshark, the command line version of WireShark is a powerful tool when it comes to filtering information from an existing packet capture session (.pcap file).

## Filtering out user agents
`tshark -r <file.pcapng> -Y "http.user_agent" -T fields -e http.user_agent`

Where:   
`<file.pcapng>` - A file containing packets from a previous session   
`-Y`            - The display filter, in this case only show values from `http.user_agent`   
`-T`            - The output format, in this case `fields`   
`-e`            - The field to output, in this has `http.user_agent`

## Filtering out TLS versions

`tshark -r <file.pcapng> -Y "tcp.port==443" -T fields -e tls.handshake.version | sort | uniq`

Where:   
`<file.pcapng>` - A file containing packets from a previous session   
`-Y`            - The display filter, in this case only show values that have `tcp.port` equalling `443`   
`-T`            - The output format, in this case `fields`   
`-e`            - The field to output, in this has `tls.handshake.version`




