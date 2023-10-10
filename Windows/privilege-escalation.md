# Create elevated accounts on windows
If you have a system where either your permissions require elevation, or you do not have an account then the following steps will grant you a privileged account.

## Reboot into recovery mode
For this, you will need to reboot the machine into recovery mode using a bootable USB drive that contains Windows installation media.

When the installation screen appears, you will want to click the following buttons:
* Repair
* Troubleshoot
* Advanced
* Command prompt

## Edit the registry
Now that you have a command prompt, you will want to open `regedit` and open the following hive `d:\windows\system32\config\software`

Browse to the following registry key `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options` and add a new registry key called `utilman.exe`

Now add a new `String value` entry inside `utilman.exe` called `Debugger` and assign the value `cmd.exe`

## Reboot into Windows
Once Windows has rebooted, you should click the `Ease of access` button which will now fire up a privileged command prompt.

## Add a new user
To add a new user type:

```
net user <username> <password>
```

## Escale privileges
To escalate any user's privileges type:

```
net localgroup administrators <username> /add
```


