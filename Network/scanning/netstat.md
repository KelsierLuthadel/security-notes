# Netstat

## Basic flags:

```
--verbose, -v
    Tell  the user what is going on by being verbose. Especially print some
    useful information about unconfigured address families.

--numeric, -n
    Show  numerical addresses instead of trying to determine symbolic host,
    port or user names.

-e, --extend
    Display  additional information.  Use this option twice for maximum de‐
    tail.

-p, --program
    Show the PID and name of the program to which each socket  belongs.   A
    hyphen is shown if the socket belongs to the kernel (e.g. a kernel ser‐
    vice, or the process has exited but the socket hasn't finished  closing
    yet).

-l, --listening
    Show only listening sockets.  (These are omitted by default.)
    
-a, --all
    Show  both  listening and non-listening sockets.  With the --interfaces
    option, show interfaces that are not up

```    


## Example

**Show all connections, with numeric addresses/port and PID**

`netstat -anp`

**Show only listening connections, with numeric addresses/port and PID**

`netstat -anp`
