<div class="flex-container">
        <img src="https://github.com/ProfessionalLinuxUsersGroup/img/blob/main/Assets/Logos/ProLUG_Round_Transparent_LOGO.png?raw=true" width="64" height="64"></img>
    <p>
        <h1>Unit 7 Lab - Monitoring and Alerting</h1>
    </p>
</div>

> If you are unable to finish the lab in the ProLUG lab environment we ask you `reboot`
> the machine from the command line so that other students will have the intended environment.

### Required Materials

Putty or other connection tool Lab Server

Root or sudo command access

STIG Viewer 2.18 (download from <https://public.cyber.mil/stigs/downloads/> )

#### Downloads

The lab has been provided below. The document(s) can be transposed to
the desired format so long as the content is preserved. For example, the `.txt`
could be transposed to a `.md` file.

<!-- - <a href="./assets/downloads/u7/u7_lab.txt" target="_blank" download>📥 u7_lab(`.txt`)</a> -->
<!-- - <a href="./assets/downloads/u7/u7_lab.pdf" target="_blank" download>📥 u7_lab(`.pdf`)</a> -->

## Lab 🧪

These labs focus on pulling metric information and then visualizing that data quickly on dashboards for real time analysis.

### Monitoring Jails with Fail2ban logs

<!-- <img src='./assets/images/u7/image1.png'></img> -->

1. Complete the lab: <https://killercoda.com/het-tanis/course/Linux-Labs/109-fail2ban-with-log-monitoring>

   - Were you able to see the IP address that was banned and unban it?
        - Yes, the IP was `10.244.23.174`
            - This is weird because the output of `hostname -I` on `node01` did not
              contain this IP address.. Kubernetes?
        - The command to unban the banned IP was:
          ```bash
          fail2ban-client set sshd unbanip 10.244.23.174
          ```

   - Were you able to see all the NOTICE events in Grafana?
        - Yes:
          ```txt
          2025-05-16 23:03:51,097 fail2ban.actions        [36481]: NOTICE  [sshd] Unban 10.244.23.174
          2025-05-16 23:01:02,621 fail2ban.actions        [36481]: NOTICE  [sshd] Ban 10.244.23.174
          ```

   - What other questions do you have about this lab, and how might you go figure them out?
        - TODO: Question about the IP -- how is that determined? I think it is the
          Kubernetes running under the hood assigning the IPs, since `10.x.x.x` is
          indicative of a kubernetes CNI.  

### Monitoring Jails with Fail2ban and telemetry data

<!-- <img src='./assets/images/u7/image2.png'></img> -->

1. Complete the lab here: <https://killercoda.com/het-tanis/course/Linux-Labs/110-fail2ban-with-metric-alerting>

   - Do you see `fail2ban` in the Grafana Dashboard? If not, how are you going to
     troubleshoot it?
        - After adding it, yes. We didn't set up logs in that particular lab, so
          fail2ban wasn't on the dashboard by default. We added the visualization
          panel for fail2ban, using the influxdb data source.  

   - Did you get your test alert and then real alert to trigger into the Discord channel?
        - Yes! It worked (eventually).  

   - What other applications or uses for this could you think of? Do you have other
     places you could send alerts that would help you professionally?
        - This would be great for alerting when system resources become saturated.  
        - Professionally, no, but this would benefit me greatly in my homelab.  

```bash
fail2ban-client get sshd banned  # show banned ips from ssh
fail2ban-client set sshd unbanip <the IP from the logs> # unban an ip
```

- username: kolkhis
- password: password
- org name: prolug
- bucket n: lab-bucket
- token: EfZzZANrLU44BUas-oZuxWTKLx1mYdTep1GNtArHoDNHwNm1mBHDpBqubwsX_LGR-IQf4jPveXF9ZZwgFhh8fQ==

## Digging Deeper challenge (not required for finishing lab)

1. Review the alert manager documentation:
   <https://prometheus.io/docs/alerting/latest/configuration/>

   - What are all the types of receivers you see?

   - Which of the receivers do you have experience with?

2. Review the Grafana alert thresholds:
   <https://grafana.com/docs/grafana/latest/panels-visualizations/configure-thresholds/>

   - Can you modify one of the thresholds from the lab to trigger into the discord?

   - What is the relationship between critical and warning by default?

> Be sure to `reboot` the lab machine from the command line when you are done.
