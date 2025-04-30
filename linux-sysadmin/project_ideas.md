# ProLUG 101 Systems Administration Course - Project Ideas  

1. Setting up homelab with Proxmox, and run some services in containers  
    * For containers, do something interesting with Container Volumes.  
        * Container volumes are how you map a directory on the host to a directory in the container.  
        * E.g., One volume for config and one for data  
        * Example: Plex media server running as a podman container, one volume for config, one for the media.  
          That way, you can nuke the container, re-launch it later, and it's all configured  


1. Monitoring - Bash script to gather metrics from `/proc` and other sources. Set  
   thresholds and configure alerts based on those thresholds. Use `cron` to automate.  
    * `free`
    * `df`
    * `du`

1. Automated backup and restoration system. Script that compresses selected  
   directories and stores them in a backup location (e.g. S3 or backup disk) + a script  
   that restores from backup location.  

1. User management system. 
    * Shell script for automated user management tasks:  
        * Adding, deleting, modifying user accounts.  
        * Setting up permissions and group memberships.  
    * Read users, groups, and permissions from CSV/JSON file. 
    * Schedule the script to run periodically to keep all settings up to date.  

* Automated file integrity checking system  
    * Bash script that generates file checksums (either `cksum` or `sha256sum`) for critical system files and compares them regularly to detect changes.  
    * Store the original hashes in a file (e.g., `/var/lib/filewatch/hashes.db`) to make comparisons easier and persistent across reboots.  
    * Log all integrity checks in a standard format like `json` or `csv`.  
    * Set up alerts with `inotify` (from `inotify-tools`) if file contents change unexpectedly.  
    * Non-critical: Allow the script to take input from a config file (like `/etc/filewatch.conf`)  

