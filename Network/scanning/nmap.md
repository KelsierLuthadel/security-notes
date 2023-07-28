# Network Map (NMap)

## Host
```
nmap target

Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-25 14:52 BST
Nmap scan report for 192.168.0.1 (192.168.0.1)
Host is up (0.0097s latency).
Not shown: 995 closed tcp ports (conn-refused)
PORT      STATE    SERVICE
22/tcp    open     ssh
80/tcp    open     http
3128/tcp  filtered squid-http
9929/tcp  open     nping-echo
31337/tcp open     Elite

Nmap done: 1 IP address (1 host up) scanned in 0.20 seconds
```

**Specify host**   
`nmap scanme.nmap.org`


**Specify IP address**   
`nmap 192.168.0.1`

**Specify multiple addresses**   
Scan three addresses:  
`nmap 192.168.0.1 192.168.0.9 192.168.0.25`  

Scan a range of addresses:  
`nmap 192.168.0.1-10`   
 
Scan a CIDR range:  
`nmap 192.168.0.0/24`   

Mixture:   
`nmap 192.168.0.1-5 192.168.0.9 192.168.5.0/24`


## Port
```
nmap -p <port ranges> target
```

**Single port**   
`nmap -p80`

**Port range**   
`nmap -p1-1000`

**Multiple ports**   
`nmap -p8,443,8080`

**All ports**   
`nmap -p-`

**UDP**   
`nmap -p U:53,111,137`

**TCP**   
`nmap -p T:21-25,80,8080`

**Multiple protocols**   
`nmap -p U:53,111,137,T:21-25,80,8080`

**Exclude ports**   
`nmap -p1-100 --exclude-ports=2,3,10`

## OS Fingerprint
```
nmap -O 
```

## Scripts

**Use default set of scripts**
`nmap -sC`

## Version detection
**Probe ports to determine service or version information**
`nmap -sV`

## Save output
`nmap -oN <filename>`


## Typical use
`nmap -sC -sV -oN nmap/scan-1 10.0.0.1`

