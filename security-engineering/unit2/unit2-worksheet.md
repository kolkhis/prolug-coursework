
# Unit 2 Worksheet - Network Standards and Compliance

## Instructions

---

Fill out this sheet as you progress through the lab and discussions. Hold your worksheets until
the end to turn them in as a final submission packet.

### Resources / Important Links

- <https://www.sans.org/information-security-policy/>
- <https://www.sans.org/blog/the-ultimate-list-of-sans-cheat-sheets/>
- <https://docs.rockylinux.org/gemstones/core/view_kernel_conf/>
- <https://ciq.com/blog/demystifying-and-troubleshooting-name-resolution-in-rocky-linux/>
- <https://www.activeresponse.org/wp-content/uploads/2013/07/diamond.pdf>

To qualify for the ProLUG certification download, fill out, and save the desired worksheet format:

- <a href="./assets/downloads/u2/u2_worksheet.docx" target="_blank" download>📥 u2_worksheet(`.docx`)</a>

### Unit 2 Recording

<img src="./assets/images/under-construction.jpg" style="border-radius:2%"></img>

<!-- <iframe -->
<!--     style="width: 100%; height: 100%; border: none; -->
<!--     aspect-ratio: 16/9; border-radius: 1rem; background:black" -->
<!--     src="" -->
<!--     title="" -->
<!--     frameborder="0" -->
<!--     allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" -->
<!--     referrerpolicy="strict-origin-when-cross-origin" -->
<!--     allowfullscreen> -->
<!-- </iframe> -->

#### Discussion Post #1

There are 401 stigs for RHEL 9. If you filter in your STIG viewer for
`sysctl` there are 33 (mostly network focused), ssh - 39, and network - 58. Now there are
some overlaps between those, but review them and answer these questions

1. As systems engineers why are we focused on protecting the network portion of our
   server builds?

    > - The network portion of the server builds is one of the most important
      components of security. Almost all attacks will come from the outside, meaning
      an attacker will need to find vulnerabilities in the network setup of the
      server. If we harden the network, we make it that much harder for attackers to
      get in and do damage to the org.

2. Why is it important to understand all the possible ingress points to our servers that
   exist?

>   This is important because every single ingress point in the server is a potential
   attack vector. Understanding all possible ingress points allows us to implement
   the best preventative controls we know of to ensure that the ingress points are no 
   longer attack vectors.  

   - Why is it so important to understand the behaviors of processes that are
     connecting on those ingress points?

     > - In the same vein, processes that connect to the ingress points are also
          potential attack vectors. If we're letting a process into one of our
          servers, we need to understand the risk associated with that process. If
          the process itself has attack vectors, those could be exploited to
          indirectly gain access to the system. If we understand the normal behavior
          of those processes, we will recognize when the process is acting unusual.

#### Discussion Post #2

Read this: <https://ciq.com/blog/demystifying-and-troubleshooting-name-resolution-in-rocky-linux/>
or similar blogs on DNS and host file configurations.

1. What is the significance of the `nsswitch.conf` file?

2. What are security problems associated with DNS and common exploits? (May have
   to look into some more blogs or posts for this)

<div class="warning">
Submit your input by following the link below.

The discussion posts are done in Discord threads. Click the 'Threads' icon on the top right and search for the discussion post.

</div>

- [Link to Discussion Posts](https://discord.com/channels/611027490848374811/1098309490681598072)

## Definitions

---

* `sysctl`: A tool used to control kernel modules.

* `nsswitch.conf`: The `/etc/nsswitch.conf` file is is the configuration file for the
  Name Switch Service.

* DNS:

* Openscap:

* CIS Benchmarks:

* ss/netstat:

* tcpdump:

* ngrep:

## Digging Deeper

---

1. See if you can find any DNS exploits that have been used and written up in the
   diamond model of intrusion analysis format. If you can, what are the primary actors
   and actions that made up the attack?

## Reflection Questions

---

1. What questions do you still have about this week?

2. How are you going to use what you've learned in your current role?
