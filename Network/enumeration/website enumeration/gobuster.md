# GoBuster
Scan a website for directories using a wordlist and print the full URLs of discovered paths

`gobuster dir -u <url> -w <wordlist>`

## Example
`gobuster dir -u http://10.0.0.1 -w /usr/share/wordlists/dirb/common.txt`

```
===============================================================
Gobuster v3.5
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.0.0.1
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/wordlists/dirb/common.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.5
[+] Timeout:                 10s
===============================================================
2023/07/28 10:19:34 Starting gobuster in directory enumeration mode
===============================================================
/.hta                 (Status: 403) [Size: 291]
/.htaccess            (Status: 403) [Size: 296]
/.htpasswd            (Status: 403) [Size: 296]
/hidden               (Status: 301) [Size: 318] [--> http://10.0.0.1/hidden/]
/index.html           (Status: 200) [Size: 158]
/server-status        (Status: 403) [Size: 300]
Progress: 4614 / 4615 (99.98%)
===============================================================
2023/07/28 10:19:49 Finished
==============================================================
```
