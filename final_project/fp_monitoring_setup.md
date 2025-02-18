# ProLUG 101 Final Project Monitoring Stack Setup


## Table of Contents
* [Monitoring Stack](#monitoring-stack) 
    * [Central VM for Monitoring](#central-vm-for-monitoring) 
    * [Visualization](#visualization) 
    * [Overview](#overview) 
* [Monitoring Stack Setup](#monitoring-stack-setup) 
* [Grafana](#grafana) 
    * [Programmatically Configuring Grafana Data Sources and Dashboards](#programmatically-configuring-grafana-data-sources-and-dashboards) 
        * [Data Source Provisioning](#data-source-provisioning) 
        * [Dashboard Provisioning](#dashboard-provisioning) 
* [Prometheus](#prometheus) 
    * [Prometheus Service Discovery](#prometheus-service-discovery) 
* [Writing the Playbook](#writing-the-playbook) 
* [Loki Playbook Debugging](#loki-playbook-debugging) 
* [Resources](#resources) 


## Monitoring Stack

I'm going to be using the following stack for monitoring my Proxmox homelab and its
containers/VMs:  

* `Grafana` for Visualiztion.  
* `Prometheus` TSDB for system metrics storage
* `Loki` for log aggregation. 

* `node_exporter` for collecting system metrics 
* `Promtail` to collect ship logs to a centralized Loki from all nodes

---

Other possibilities:
* `cAdvisor` for per-container resource usage (if I start a kubernetes/container-heavy project)
* Alerts with `Alertmanager`, which is bundled with Prometheus.

### Central VM for Monitoring
There will be a central VM that runs Grafana, Prometheus, and Loki.  

Then I'm going to deploy a distributed setup; `node_exporter` and `promtail` will run 
on all the other nodes and send all the data from those nodes to the central VM.  

### Visualization

A `yaml` visualization of how the monitoring infrastructure will be set up:
```yaml
Central Monitoring VM:
  - Prometheus: metrics DB
  - Grafana: visualizations
  - Loki: log storage

Proxmox Node 1:
  - node_exporter: metrics
  - promtail: logs

Proxmox Node 2:
  - node_exporter: metrics
  - promtail: logs
```

### Overview

---

My final project is to automate the setup of monitoring tools on a node or set of nodes using Ansible.  
I have a central VM set up in my homelab running Ubuntu Server that will host Grafana, Prometheus, and Loki.  

I have an ansible playbook that installs and launches Grafana on the central VM, and generates a link to the login page. 

I've decided on file-based service discovery in `Prometheus` for `node_exporter` running on other nodes.

I automated the process of adding targets to the `/etc/prometheus/targets.json` file every time I use an ansible playbook to deploy `node_exporter` on another system on the network.
This will allow for dynamic updating of `node_exporter` data sources.  

I aim to make this to be universal, so I can configure targets on the fly.

---

I'm going to have a Central VM that hosts Grafana, Loki, and Prometheus. Probably
also `node_exporter` and promtail on this node, but I'm not going to worry about that
yet. 
I'm first going to set up Grafana on the server. Then, I'll set up prometheus, and
create a `targets.json` that I can append to every time I add a new `node_exporter`
instance on a node.  


## Monitoring Stack Setup
I'm going to create a central VM running Ubuntu Server that I'm going to use as my
centralized monitoring hub.  

Install:
* Loki
* Prometheus
* Grafana

I'm going to write an Ansible playbook to automate this process.  
That way, if I ever have to rebuild the central VM, I won't have to do it all
manually again.  

---

## Grafana
I'm going to be using Grafana for visualizations.  
I'll be Installing and launching Grafana with an Ansible playbook.
Steps:
* Download the GPG key
* Add the apt repository, signed by the GPG key.  
* Download dependencies
    * apt-transport-https
    * software-properties-common
    * unzip
    * grafana-enterprise
* Generate a link to the Grafana dashboard.  

### Programmatically Configuring Grafana Data Sources and Dashboards
[Grafana docs on provisioning data sources](https://grafana.com/docs/grafana/latest/administration/provisioning/#data-sources)

Grafana supports provisioning data sources *and* dashboards through config files.  
 
These are `yaml` files that can be included in an Ansible playbook or placed manually
in the Grafana server's configuration directory.  

These would go in `/etc/grafana/provisioning/datasources` if installed using `deb` or
`rpm` package (if you `apt install`, this is where it goes).

Otherwise, the default config location is `$WORKING_DIR/conf/`.  

#### Data Source Provisioning
Grafana provisioning directory: `/etc/grafana/provisioning/datasources/`
To provision `prometheus`, I could create a `prometheus.yaml` in this directory:
```yaml
# /etc/grafana/provisioning/datasources/prometheus.yaml
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://localhost:9090
    isDefault: true
    editable: false
```

#### Dashboard Provisioning
Dashboards themselves can be in `json` format in a directory on the server:
`/var/lib/grafana/dashboards/`
Create a provisioning file for dashboards, like
`/etc/grafana/provisioning/dashboards/default.yaml`
```yaml
apiVersion: 1
providers:
  - name: 'default'
    orgId: 1
    folder: ''
    type: file
    options:
      path: /var/lib/grafana/dashboards
```






## Prometheus
Setting up Prometheus on the central VM as the TSDB for system metrics.  

The problem I'm facing here is the hosts in the Prometheus configuration.  
I need to specify all sources in `/etc/prometheus/prometheus.yml`. 
This would include all nodes that are running `node_exporter`.  

### Prometheus Service Discovery
Prometheus supports 'service discovery'. 
Using file-based discovery is likely the easiest to set up, and would not require
modifying the `prometheus.yml` config file.

This also allows adding targets for Prometheus to scrape without restarting the 
Prometheus service. 

However I'd need to manage an `/etc/prometheus/targets.json` file. 
```json
[
    { 
        "targets": ["192.168.4.1:9100", "192.168.4.2:9100", "..."], 
        "labels": {"env": "local"}
    },
]
```
NOTE: make sure prometheus has read permissions to the `targets.json` file.  
In the `prometheus.yml` file:
```yaml
scrape_configs:
  - job_name: "node_exporter"
    file_sd_configs:
      - files:
          - "/etc/prometheus/targets.json"
```

---

If I can programmatically generate a list of hosts running `node_exporter` using 
either a bash script or the proxmox API, I can modify this file (`targets.json`) to
contain all of the nodes.  

Alternatively, every time I deploy `node_exporter` on a container, I save the IP of
the remote machine (VM) to the `targets.json` file. 
Maybe I can use `jq` or `jinja2` filters to get it in there correctly.  

---

## Writing the Playbook
```yaml
- name: Install Loki, Prometheus, and Grafana on the Centralized VM
  hosts: localhost # This IP is gonna vary, so this is a placeholder
  tasks:
    - name: Create Loki directory
      ansible.builtin.shell:
        cmd: mkdir /opt/loki
        #creates: /opt/loki  # creates *before* executing command

    - name: Download an install Loki
      ansible.builtin.shell:
        chdir: /opt/loki
        cmd: |
          mkdir /opt/loki 
          curl -sL -o /opt/loki/loki-linux-amd64.zip https://github.com/grafana/loki/releases/download/v3.3.0/loki-linux-amd64.zip 
          unzip /opt/loki/loki-linux-amd64.zip
```




## Loki Playbook Debugging
When running the playbook for loki, I ran into several errors.  
I was initially using the config from the Killercoda lab. The loki process was coming
back as `failed` every time. I used `journalctl -xe -u loki` and ran into the error:
```bash
Dec 27 11:47:35 desmond loki-linux-amd64[9401]: failed parsing config: /opt/loki/loki-local-config.yaml: yaml: unmarshal errors:
Dec 27 11:47:35 desmond loki-linux-amd64[9401]:   line 30: field metric_aggregation_enabled not found in type validation.plain
Dec 27 11:47:35 desmond loki-linux-amd64[9401]:   line 40: field pattern_ingester not found in type loki.ConfigWrapper
Dec 27 11:47:35 desmond loki-linux-amd64[9401]:   line 47: field encoding not found in type lokifrontend.Config. Use -config.expand-env=true flag if you want to expand environment variables in your config f>
Dec 27 11:47:35 desmond systemd[1]: loki.service: Main process exited, code=exited, status=1/FAILURE
```

The error seemed to be in the configuration file. I commented out the lines that were
specified, including the whole `pattern_ingester` section.  
This led me to another error, also from `journalctl`:

```bash
Dec 27 12:09:47 desmond loki-linux-amd64[10526]: level=error ts=2024-12-27T17:09:47.380106871Z caller=main.go:70 msg="validating config" err="CONFIG ERROR: invalid limits_config config: unknown deletion mode: must be one of disabled|filter-only|filter-and-delete"
Dec 27 11:53:24 desmond systemd[1]: loki.service: Main process exited, code=exited, status=1/FAILUR  110 
```

I tried using the loki-local-config.yaml at [the official github page](https://github.com/grafana/loki/blob/release-3.3.x/cmd/loki/loki-local-config.yaml) but ran into some new errors.  
```bash
  Dec 27 12:19:09 desmond loki-linux-amd64[12035]: failed parsing config: /opt/loki/loki-local-config.yaml: yaml: unmarshal errors:
  Dec 27 12:19:09 desmond loki-linux-amd64[12035]:   line 44: field enabled not found in type aggregation.Config. Use `-config.expand-env=true` flag if you want to expand environment variables in your config file
  Dec 27 12:19:09 desmond systemd[1]: loki.service: Main process exited, code=exited, status=1/FAILURE
```
I commented out `enabled: true` where the `journalctl` output was pointing:
```yaml
pattern_ingester:
  enabled: true
  metric_aggregation:
    #enabled: true
    loki_address: localhost:3100
```
Then the service started correctly.  

## Promtail File-based service discovery
Promtail, like Prometheus, supports file-based service discovery.  
It's defined the same way in its configuration file.  

```yaml
scrape_configs:
    - job_name: system
      file_sd_configs: 
        - files:
            - /etc/promtail/file_sd/sys_logs.yml
            - /etc/promtail/file_sd/auth_logs.yml
    - relabel_configs:
        - source_labels: [__path__]
          target_label: path
```

Then the `system_logs.yml` would look like:
```yaml
- targets:
    - localhost
  labels:
    __path__: /var/log/syslog
    job: system_logs
```

Then the `auth_logs.yml` would look like:
```yaml
- targets:
    - localhost
  labels:
    __path__: /var/log/auth.log
    job: auth_logs
```


## Debugging Promtail + Loki

After adding Loki as a datasource for grafana and importing a default dashboard,
there are no logs being shown.  
I have verified that loki is running and the log ingester is ready:
```bash
curl http://192.168.4.53:3100/ready
# ready
curl -s $(printf "http://%s:3100/ready\n" "$(hostname -I | tr -d ' ')")
# ready
```
Then I went to the promtail endpoint through the browser, and saw all the jobs and
targets marked as "ready".  

---
Turns out Promtail was both collecting logs and sending them to Loki. I was using a dashboard that was not showing the logs collected.  

I imported dashboard `13639`, and all the logs were available to see.  



## Resources

[Grafana docs on provisioning data sources](https://grafana.com/docs/grafana/latest/administration/provisioning/#data-sources)
[Grafana Ansible collection](https://github.com/grafana/grafana-ansible-collection)




## TODO
Ansible Workflows

