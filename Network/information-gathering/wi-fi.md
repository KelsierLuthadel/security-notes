# Discovering Wi-Fi Secrets

Windows conveniently stores Wi-Fi passwords unencrypted when running `netsh`, so this simple script will iterate through all the saved passwords and dump them out for you.

```
@echo off
rem 

# Delayed Expansion will cause variables within a batch file to be expanded at execution time rather than at parse time
setlocal enabledelayedexpansion

rem # Output from netsh wlan show profile is something like:  
rem
rem # All User Profile     : ESSD_1
rem # All User Profile     : ESSD_2

for /F "tokens=2 delims=:" %%p in ('netsh wlan show profile') do (
  set wifi_pwd=
  rem # The output from netsh wlan show profile ESSID key=clear is huge so we need to find the string "Key Content"
  for /F "tokens=2 delims=: usebackq" %%P IN (`netsh wlan show profile %%p key^=clear ^| find "Key Content"`) do (set wifi_pwd=%%P)
echo %%p : !wifi_pwd!
)
```