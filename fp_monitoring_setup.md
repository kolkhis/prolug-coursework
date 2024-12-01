# ProLUG 101 Final Project Monitoring Stack Setup


## Monitoring Stack

I'm going to be using the following stack for monitoring my Proxmox homelab and its
containers/VMs:  

* `node_exporter` for collecting system metrics ("Like Prometheus, but for logs")
* `Prometheus` TSDB for system metrics storage
* `Promtail` to collect ship logs to a centralized Loki from all nodes
* `Loki` for log aggregation. 
* `Grafana` for Visualiztion.  

---

Other possibilities:
* `cAdvisor` for per-container resource usage (if I start a kubernetes/container-heavy project)
* Alerts with `Alertmanager`, which is bundled with Prometheus.

### Central VM for Monitoring
There will be a central VM that runs Grafana, Prometheus, and Loki.  

Then I'm going to deploy a distributed setup; `node_exporter` and `promtail` will run 
on all the other nodes and send all the data from those nodes to the central VM.  

### Visualization

```yaml
Central Monitoring VM:
  - Prometheus (metrics DB)
  - Grafana (visualizations)
  - Loki (log storage)

Proxmox Node 1:
  - node_exporter (metrics)
  - promtail (logs)

Proxmox Node 2:
  - node_exporter (metrics)
  - promtail (logs)
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

### Writing the Playbook
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







