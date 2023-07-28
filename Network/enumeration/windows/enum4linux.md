# enum4linux
A Linux alternative to enum.exe for enumerating data from Windows and Samba hosts.

`enum4linux -a <address>`

## Example response
**Target Information**  
The target information section is generic, and usually shows the same information for each scan

```
=========================================( Target Information )=========================================

Target ........... 10.10.10.10
RID Range ........ 500-550,1000-1050
Username ......... ''
Password ......... ''
Known Usernames .. administrator, guest, krbtgt, domain admins, root, bin, none
```

**workgroup**   
This will show the defined workgroup or domain for the target

```
============================( Enumerating Workgroup/Domain on 10.10.10.10 )============================

[+] Got domain/workgroup name: WORKGROUP

```

**netbios names**   
This shows the names stored in the netbios cache,


```
================================( Nbtstat Information for 10.10.10.10 )================================

Looking up status of 10.10.10.10
	BASIC2          <00> -         B <ACTIVE>  Workstation Service
	BASIC2          <03> -         B <ACTIVE>  Messenger Service
	BASIC2          <20> -         B <ACTIVE>  File Server Service
	..__MSBROWSE__. <01> - <GROUP> B <ACTIVE>  Master Browser
	WORKGROUP       <00> - <GROUP> B <ACTIVE>  Domain/Workgroup Name
	WORKGROUP       <1d> -         B <ACTIVE>  Master Browser
	WORKGROUP       <1e> - <GROUP> B <ACTIVE>  Browser Service Elections

	MAC Address = 00-00-00-00-00-00
```

**OS Information**   
This will show any operating system versions found during an `smbclient` or `srvinfo` lookup

```
 ===================================( OS information on 10.10.10.10 )===================================

[+] Got OS info for 10.10.10.10 from srvinfo: 
	BASIC2         Wk Sv PrQ Unx NT SNT Samba Server 4.3.11-Ubuntu
	platform_id     :	500
	os version      :	6.1
	server type     :	0x809a03

```

**Share details**   
This will show the results of share enumeration

```
=================================( Share Enumeration on 10.10.10.10 )=================================

	Sharename       Type      Comment
	---------       ----      -------
	Anonymous       Disk      
	IPC$            IPC       IPC Service (Samba Server 4.3.11-Ubuntu)

	Workgroup            Master
	---------            -------
	WORKGROUP            BASIC2

[+] Attempting to map shares on 10.10.10.10

//10.10.19.107/Anonymous	Mapping: OK Listing: OK Writing: N/A
```


**Password policy**
If a password policy has been put in place, details will be shown here
```
============================( Password Policy Information for 10.10.10.10 )============================

[+] Attaching to 10.10.10.10 using a NULL share

[+] Trying protocol 139/SMB...

[+] Found domain(s):

	[+] BASIC2
	[+] Builtin

[+] Password Info for Domain: BASIC2

	[+] Minimum password length: 5
	[+] Password history length: None
	[+] Maximum password age: 37 days 6 hours 21 minutes 
	[+] Password Complexity Flags: 000000

		[+] Domain Refuse Password Change: 0
		[+] Domain Password Store Cleartext: 0
		[+] Domain Password Lockout Admins: 0
		[+] Domain Password No Clear Change: 0
		[+] Domain Password No Anon Change: 0
		[+] Domain Password Complex: 0

	[+] Minimum password age: None
	[+] Reset Account Lockout Counter: 30 minutes 
	[+] Locked Account Duration: 30 minutes 
	[+] Account Lockout Threshold: None
	[+] Forced Log off Time: 37 days 6 hours 21 minutes 

[+] Retieved partial password policy with rpcclient:

Password Complexity: Disabled
Minimum Password Length: 5
```

**User enumeration**  
The results of username enumeration will be shown here
```
 ==================( Users on 10.10.10.10 via RID cycling (RIDS: 500-550,1000-1050) )==================

[I] Found new SID: 
S-1-22-1

[+] Enumerating users using SID S-1-22-1 and logon username '', password ''

S-1-22-1-1000 Unix User\bob (Local User)

S-1-22-1-1001 Unix User\sue (Local User)
```

