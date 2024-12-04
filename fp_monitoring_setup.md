# ProLUG 101 Final Project Monitoring Stack Setup


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

If I can programatically generate a list of hosts running `node_exporter` using 
either a bash script or the proxmox API, I can modify this file (`targets.json`) to
contain all of the nodes.  

Alternatively, every time I deploy `node_exporter` on a container, I save the IP of
the remote machine (VM) to the `targets.json` file. 
Maybe I can use `jq` to get it in there correctly.  

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







