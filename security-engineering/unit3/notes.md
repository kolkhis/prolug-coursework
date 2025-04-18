# Unit 3 Notes
We always have to report up our compliance 
* Falcon(something)
* Nessus

- SSH auth methods: password, cert, key
    - SSH can spawn `sh` but it needs permission

- NIS: Network Internet Services?

- Disallow non-root logins on tty1 `/etc/security/access.conf`
    - `-:ALL EXCEPT root`
    - `grp_<server-name>`: Only allow certain groups into servers
        - All servers built with a group name 
    - Can disable cron in this file (`-:ALL:cron`)
        - Users can easily crash clusters with cron 

- Tool called "Archer" - risk management tool
    - Very expensive, used by enterprise environments

- SSH settings being changed affect current sessions? No
    - Why? 
        - The sessions have already been established

- Setup OpenLDAP

- This week: Turn off the warewulf client
  ```bash
  systemctl stop wwctl
  ```

- In RHEL 9, you no longer use OpenLDAP (IDM now)
    - In Rocky 9 you can.  
    - <https://www.redhat.com/en/technologies/cloud-computing/directory-server>
    - https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/configuring_authentication_and_authorization_in_rhel/configuring-sssd-to-use-ldap-and-require-tls-authentication_configuring-authentication-and-authorization-in-rhel#An-OpenLDAP-client-using-SSSD-to-retrieve-data-from-LDAP-in-an-encrypted-way_configuring-SSSD-to-use-LDAP-and-require-TLS-auathentication
    - https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/planning_identity_management/overview-of-identity-management-and-access-control-planning-identity-management

(GRC teams)

- Final Project
    - Based around HIPAA compliance
    - Plan how our org's activies will align with an overall HIPAA architecture
    - Technical, physical, (managerial), administrative controls
    - Write up policies, AND procedures (5 and 5)
    - Think about "acceptable use policy" 
        - Banner MOTD that says "you're in a gov't system"
        - e.g., Search RHEL STIGs for "banner"
    - LABEL DATA
    - <https://www.sans.org/information-security-policy/>
    - <https://www.sans.org/blog/the-ultimate-list-of-sans-cheat-sheets/>

- You will likely NEVER build an LDAP server.
    - We use Active Directory over LDAP
    - AWS has an AD
    - The SSSD part, you will your whole career

- Allow users to get in only if they've been vetted and given access via AD
    - Like a keybox when buying a house
