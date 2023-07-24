# tcpdump

## Options
```
-A      Print each packet (minus its link level header) in ASCII.  Handy for capturing web pages.

-l      Make stdout line buffered.  Useful if you want to see the data while capturing it.

-vv     Even more verbose output.  For example, additional fields are printed from NFS  reply  packets,  and
        SMB packets are fully decoded.

-w file Write the raw packets to file rather than parsing and printing them out.  They can later be  printed
        with the -r option.              

```

## Write to file

`tcpdump -w output.cap`

## Filter by host

`tcpdump host 192.168.0.2`

**Three way handshake**


> 09:18:08.357631 IP 192.168.0.2 > kali.http: Flags [S], seq 0, win 64240, length 0
> 
> 09:18:08.365416 IP kali.http > 192.168.0.2: Flags [S.], seq 0, ack 1, win 65535, length 0
> 
> 09:18:08.365429 IP 192.168.0.2 > kali.http: Flags [.], seq 1, ack 1, win 502, length 0


The three way handshake can be seen in the example output above by looking at the flags:

```
[S] -  This is the SYN flag

[S.] - This is the SYN/ACK flag

[.] -  This is the ACK flag
```

## Filter traffic FROM a host
`tcp dump src host 192.168.0.2`

## Filter by port
`tcp dump -vv dst port 80`

The -vv flag adds extra verbosity

## Filter by TCP Flags
`tcpdump 'tcp[tcpflags]==tcp-syn'`  
`tcpdump 'tcp[tcpflags]==tcp-ack'`  
`tcpdump 'tcp[tcpflags]==tcp-rts'`  
`tcpdump 'tcp[tcpflags]==tcp-psh'`  
`tcpdump 'tcp[tcpflags]==tcp-urg'`

## Find text output
`tcpdump -vvAl | grep 'Set-Cookie|Host|Cookie:'`







