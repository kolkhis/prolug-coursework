

I've got a question.
From the worksheet:
You will research, design, deploy, and document a system that improves your administration of Linux systems in some way.
What exactly does "system" mean here?




syntax is the exact wording of how we issue a command

command - most commands are called by their names
options - sometimes called switches are typically preceded by a `-` 
arguments - optional values passed to the command (i.e., file names, locations, data)


`ls` - default argument
$PWD - current working directory
but, `$PWD` can be changed
- `$PWD=/tmp`
But the default argument to `ls` is NOT `/tmp`

check what user you are by using `id`

Getting help:
* `info`
* `man`
* `--help`



## Commands
`printenv`/`env`
`top` - see processes using the most processor resources
`kill` - stop or restart the process
`last` - shows the most recent logins
`tac` - reverse the order of the output
`uniq` - remove duplicate lines/items
`diff` - show the difference between files


```bash
ping -M do <target>
```
This `-M do` makes sure the packet does not get fragmented.  
* `ping`: The basic `ping` command is used to test the connectivity between two devices 
  on a network by sending ICMP echo request packets to the target and measuring the 
  time it takes to receive an echo reply (response). 
* `-M`: This option sets the path MTU discovery mode, which controls how the `ping` 
  command deals with IP fragmentation.
    * MTU stands for **Maximum Transmission Unit**, which is the largest size of a packet 
      that can be sent over a network link *without fragmentation*.
    * The MTU for a network interface can be found using `ifconfig` or `ip`:
      ```bash
      ifconfig
      ip addr
      # or
      ip a
      ```
      These commands list all the network interfaces, their statuses, and other info.  
      The network interface will usually be named something like `eth0`, `en0`, `enp0`, etc
        * `ifconfig` may not be installed by default on modern Linux distributions.

* Finding the default network interface:
    * To specifically find the interface being used for outbound traffic (like connecting 
      to the internet), you can check the default route:
      ```bash
      ip route
      # or
      ip r
      ```

## MTU Size and Ping
* `mtu`: Maximum transmission unit. The max size of a packet that can be sent.

With `ping`, you can specify the size of the ICMP packet you send with the `-s` option.
```bash
ping -c 1 -s 1500 <destination> # This is the MTU of the interface. It will send 1500 bytes.
```
This will work, but will send the packet in frames, which will be fragmented.

---

If you want to send the packet in a single frame, you can use the `-M` option.  
```bash
ping -c 1 -M do -s 1400 <destination>
```
* `-M do`: Don’t fragment the packets. 
* `-s 1400`: Send packets with a size of 1400 bytes (without fragmentation). 
* `<destination>`: Replace this with the IP address or hostname of the system you're pinging.

If you tried sending a 1500 byte packet without fragmentation, you'd get an error and
100% packet loss, since it exceeds the MTU.  


---

## Misc Notes
* "dual homed" means that a network interface has both an IPv4 and IPv6 address.
* if there are 2 binaries of the same name in `$PATH` then the first one in the list is used. 
* `/var` contains files that change regularly
