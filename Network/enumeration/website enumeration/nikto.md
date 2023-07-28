# Nikto

Nikto is a pluggable web server and CGI scanner written in Perl, using rfp’s LibWhisker to perform fast security or informational checks.

Features:

    - Easily updatable CSV-format checks database
    - Output reports in plain text or HTML
    - Available HTTP versions automatic switching
    - Generic as well as specific server software checks
    - SSL support (through libnet-ssleay-perl)
    - Proxy support (with authentication)
    - Cookies support

`nikto -h <address>`

## Example
`nikto -h http://10.0.0.1`

```
 Nikto v2.5.0
---------------------------------------------------------------------------
+ Target IP:          10.0.0.1
+ Target Hostname:    10.0.0.1
+ Target Port:        80
+ Start Time:         2023-07-28 10:05:42 (GMT1)
---------------------------------------------------------------------------
+ Server: Apache/2.4.18 (Ubuntu)
+ Apache/2.4.18 appears to be outdated (current is at least Apache/2.4.54). Apache 2.2.34 is the EOL for the 2.x branch.
+ OPTIONS: Allowed HTTP Methods: GET, HEAD, POST, OPTIONS .
+ /hidden/: Directory indexing found.
+ /hidden/: This might be interesting.
+ /icons/README: Apache default file found
+ 8074 requests: 0 error(s) and 8 item(s) reported on remote host
+ End Time:           2023-07-28 10:09:56 (GMT1) (254 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested
```
