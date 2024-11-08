# ProLUG 101 Systems Administration Course - Project Ideas


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

1. Automated file integrity checking system
    * Script that generates file checksums (`cksum`, `sha256sum`) for critical system files and compares
      them regularly to detect changes
    * Set up alerts if file contents change unexpectedly and log all integrity checks




