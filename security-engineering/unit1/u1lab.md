# Unit 1 Lab - Database Remediation

## Module 1: Exploring System Information

### Exercise 1.1: Familiarizing ourselves with the System

```bash
mount | grep -i noexec

mount | grep -i nodev

mount | grep -i nosuid

# Approximately how many of your mounted filesystems have each of these values?
```
Answer: 
* `noexec`: 16 
* `nodev`: 18
* `nosuid`: 20

### Exercise 1.2: Checking Mounted Systems

```bash
sysctl -a | grep -i ipv4

sysctl -a | grep -i ipv6

# How many of each are there?
```
Answer:
`ipv4`: 315
`ipv6`: 296

```bash
sysctl -a | grep -i ipv4 | grep -i forward

# Does IPv4 forward on interfaces?
```
Answer: 
No, ipv4 forwarding is not enabled (set to `0`).  

```bash
lsmod | grep -i tables

# What type of tables exist?
```
Answer:
- `libcrc32c` and `nfnetlink` (both nf_tables)

## Module 2: PreLAB

1. Download the STIG Viewer 2.18 from - <https://public.cyber.mil/stigs/downloads/>
<!-- TODO: Host these screenshots locally -->
   ![image](https://github.com/user-attachments/assets/718b0c53-9bcc-4782-a2fb-bfc8b684bad7)

2. Download the STIG for Mariadb and the import it into your STIG viewer.
   ![image](https://github.com/user-attachments/assets/8c6e9b50-3c7e-4670-8092-83a2ae152ae2)

## Module 3: Lab

This lab is designed to have the engineer practice securing a Linux server or service
against a set of configuration standards.
These standards are sometimes called benchmarks, checklists, or guidelines.  
The engineer will be using STIG Viewer 2.18 to complete this lab.

### MariaDB Service configuration:

1. Connect to a hammer server.
2. Install MariaDB.

```bash
dnf install mariadb-server

# Ensure that it is running

systemctl start mariadb

systemctl status mariadb

ss -ntulp | grep 3306
```

- Check and remediate v-253666 STIG.
  ![image](https://github.com/user-attachments/assets/e882e555-773f-43c2-b6df-a12fe34e64eb)

  - What is the problem?
     - We need to limit the number of concurrent connections per user.
     - The number of connections allowed is pre-defined by the organization.
  - What is the fix?
     - Set the number of concurrent sessions (`max_user_connections`) to 1 for each user.
  - What type of control is being implemented?
     - This is a preventative control.  
  - Is it set properly on your system?
     - It was not. By default, all max_user_connections were set to `0`.

  Connect to MariaDB locally.
  ```bash
  mysql
  ```
  Run the SQL command in the STIG's Fix Text section:
  ```sql
  SELECT user, max_user_connections FROM mysql.user;
  ```
  ![image](https://github.com/user-attachments/assets/53984015-72ca-42c1-baa2-28e9a9470e3c)

  Can you remediate this finding?
  ![image](https://github.com/user-attachments/assets/a9410577-7250-421c-acdf-00cc7f54a3f0)
  ```sql
  GRANT USAGE ON *.* TO 'mariadb.sys'@'localhost' WITH MAX_USER_CONNECTIONS 1;
  GRANT USAGE ON *.* TO 'root'@'localhost' WITH MAX_USER_CONNECTIONS 1;
  GRANT USAGE ON *.* TO 'mysql'@'localhost' WITH MAX_USER_CONNECTIONS 1;
  ```

- Check and remediate `v-253677 STIG`
  - What is the problem?
    - MariaDB needs to shut down when an audit fails (software/hardware errors, audit
      capturing mechanism failures, audit storage capacity is reached) ONLY if the
      application owner has not decided that system availability is more important
      than a complete audit trail.
  - What is the fix?
    - Set up alerts (in a DBMS - Database Management System, the OS, or another logging application) when an audit fails.
  - What type of control is being implemented?
    - This is a detective control.
  - Is it set properly on your system?
    - Unable to tell. There is no current auditing on this database, since it is a
      clean installation. Since it's not going to be used, and there are no
      monitoring/logging systems in place, I'd say this is "Not Applicable".

- Check and remediate `v-253678 STIG`
  - What is the problem?
    - MariaDB needs to be able to overwrite audit logs, oldest first (FIFO), to
      prevent running out of storage space.
  - What is the fix?
    - Edit `mariadb-enterprise.cnf` and add to the `[mariadb]` section
      ```conf
      server_audit_output_type = 'syslog'
      ```
        - MariaDB Audit Plugin (log rotation)
  - What type of control is being implemented?
    - This is a preventative control (prevents disk saturation)
  - Is it set properly on your system?
    - No. 
      ```bash
      [root@hammer4 ~]# grep -i 'server_audit_output_type' /etc/my.cnf.d/mariadb-server.cnf
      [root@hammer4 ~]#
      ```
      I've added the line to the file, restarted the process, and now it is remediated (Not a Finding).

- Check and remediate `v-253734 STIG`
  - What is the problem?
    - Insecure network functions (determined by the organization) must be disabled by MariaDB (in accordance with PPSM - Ports, Protocols and Service Management, DoD Instruction 8551.01).
  - What is the fix?
    - Verify that MariaDB denies speciic network functions.
      ```bash
      ls -la /etc | grep my.cnf
      ```
  - What type of control is being implemented?
    - This is a preventative control.
  - Is it set properly on your system?
    - MariaDB is using the default port `3306`.
      ```bash
      MariaDB [(none)]> SHOW GLOBAL VARIABLES LIKE 'port';
      +---------------+-------+
      | Variable_name | Value |
      +---------------+-------+
      | port          | 3306  |
      +---------------+-------+
      1 row in set (0.002 sec)
      ```
      Since the organization (ProLUG) has not deemed this port insecure (at least to
      my knowledge), this is "Not a Finding".


