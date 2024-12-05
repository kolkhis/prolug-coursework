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
I'm going to have a Central VM that hosts Grafana, Loki, and Prometheus. Probably
also node_exporter and promtail on this node, but I'm not going to worry about that
yet. 
I'm first going to set up Grafana on the server. Then, I'll set up prometheus, and
create a `targets.json` that I can append to every time I add a new `node_exporter`
instance on a node.  

<!-- I'll see if there is any way to programmatically configure Grafana by adding Prometheus as a data source, and/or create default dashboards. -->
<!-- Anything that I can do programmatically instead of using the Web UI. -->

The `grafana-cli` tool, which ships with `grafana-server`, can be used for managing
Grafana plugins.  


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







## Resources

[Grafana docs on provisioning data sources](https://grafana.com/docs/grafana/latest/administration/provisioning/#data-sources)
[Grafana Ansible collection](https://github.com/grafana/grafana-ansible-collection)
