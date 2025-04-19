# Unit 2 Worksheet - Securing the Network Connection

## Instructions

---

Fill out this sheet as you progress through the lab and discussions. Hold your worksheets until
the end to turn them in as a final submission packet.

### Resources / Important Links

- <https://www.sans.org/information-security-policy/>
- <https://www.sans.org/blog/the-ultimate-list-of-sans-cheat-sheets/>
- <https://docs.rockylinux.org/guides/security/pam/>
- <https://docs.rockylinux.org/guides/security/authentication/active_directory_authentication/>
- <https://docs.rockylinux.org/books/admin_guide/06-users/>


#### Discussion Post #1

There are 16 Stigs that involve PAM for RHEL 9.
Read the guide from Rocky Linux here: <https://docs.rockylinux.org/guides/security/pam/>

1. What are the mechanisms and how do they affect PAM functionality?
    - Mechanisms (module types)
        - Auth: Verifies identity (checks passwords/SSH keys)
        - Account: Checks account validity (not expired or disabled)
        - Password: Handles password changes or updates to authentication tokens
        - Session Management: Manages session setup and teardown (mounting home dirs, audit logs))
   - Review `/etc/pam.d/sshd` on a Linux system.  
     What is happening in that file relative to these functionalities?
        - In terms of the 4 mechanisms, here's how they relate:
            - Auth: Delegates to `password-auth` and `postlogin` to verify user identity.  
            - Account: Enforces access policies, like whether the account is allowed to login (`pam_nologin.so`) or restricted by SELinux roles.  
            - Password: Included for compatibility with password change operations. It's not really triggered by SSH.
            - Session: Sets up and tears down the user sessions. Includes logging, key handling, and SELinux context setup.
          So rather than setting everything up in the `sshd` file, it references shared PAM configs (like `password-auth`) to keep login policy consistent across the system.

2. What are the common PAM modules?
    - `pam_unix`: Manages the global authentication policy.
    * `pam_ldap`: Used for auth and password changing against LDAP servers.  
    * `pam_wheel`: Limits the access to the `su` command to only members of `wheel`.  
    * `pam_cracklib`: Allows you to test passwords.  
    * `pam_console`: Gives special permissions when logging in from a physical console.
    * `pam_tally`: Allows you to lock an account after a certain amount of unsuccessful login attempts.  
    * `pam_securetty`: Allow root login only from a "secure" TTY. 
    * `pam_nologin`: Disable all accounts except root.
    * `pam_limits`: Set limits on system resources used by user sessions.  
    * `pam_time`: Limits the access times to services managed by PAM.  
    * `pam_access`: Used for access management (`/etc/security/access.conf`).  
   - Review `/etc/pam.d/sshd` on a Linux system.  
     What is happening in that file relative to these functionalities?
3. Look for a blog post or article about PAM that discusses real world application.  
   Post it here and give us a quick synopsis. (Bonus arbitrary points if you find one of 
   our ProLUG members blogs on the subject.)

<https://michaelpesa.com/posts/creating-custom-authselect-profiles/>

Quick synopsis: 
- `authselect` is a new tool (or was in RHEL 8) that replaced `authconfig`. The
  `authconfig` tool directly modified system files. `authselect` does not do that, it
  manages PAM modules and the NSS (Name Switch Service) configurations through
  selectable p[rofiles.
- You can create a custom `authselect` profile based on the existing `sssd` profile.
  Allows admins more granular control over auth settings.  
- You can include or exclude specific PAM modules and settings with custom profiles.  




#### Discussion Post #2

Read about active directory (or LDAP) configurations of Linux via `sssd` here:
<https://docs.rockylinux.org/guides/security/authentication/active_directory_authentication>

1. Why do we not want to just use local authentication in Linux? Or really any system?
    - The local auth mechanisms (via `/etc/passwd`/`/etc/shadow`) are simple but do
      not scale or secure well in enterprise environments.  
        - The local auth does not have any centralized control over user accounts,
          passwords, and permissions. They must be managed individually on each
          machine. I imagine this is a nightmare at scale.  
        - There's no way to enforce global password policies/account lockouts/access
          restrictions by default.  
        - There's no SSO (Single Sign-On) mechanism with local auth. Credentials will
          need to be added to each machine indivudually, also a nightmare at scale.  
        - If someone needs to be removed, you'll need to revoke access to all of their
          accounts on all machines individually.
2. There are 4 SSSD STIGS.  
   - What are they?  
        - I have 6 STIGs when filtering for SSSD on my version of the RHEL 9 STIGs,
          but only 4 relate to SSSD directly:  
            - V-258122  
            - V-258123  
            - V-258132  
            - V-258133  
   - What do they seek to do with the system?
        - The goal is to secure the authentication methods using rules around certificates, 
          "smart cards" (MFA), and controlling session behaviors
          MFA is controlled with the Online Certificate Status Protocol (OCSP) by default, along with sha256 hashes to verify certificate validity.


<div class="warning">
Submit your input by following the link below.

The discussion posts are done in Discord threads. Click the 'Threads' icon on the top right and search for the discussion post.

</div>

- [Link to Discussion Posts](https://discord.com/channels/611027490848374811/1098309490681598072)


## Definitions

---

* PAM: Pluggable Authentication Module.  
    - Mechanisms (module types)
        - Auth: Verifies identity
        - Account: Checks account validity
        - Session Management: Manages session setup and teardown (mounting home dirs, audit logs))
        - Password: Used to update authentication tokens
    - Modules
        - How PAM interacts with things on the system.
        - `pam_unix.so`, `pam_sss.so`, `pam_tally2.so`, `pam_wheel.so`, etc.
        - Configured in `/etc/pam.d/` (one file per service)

* AD: Active Directory.
    - A Microsoft-based centralized identity and access management (IAM) system.  

* LDAP: Lightweight Directory Access Protocol
    - Protocol used to access and manage directory services over a network
    - Used for querying and modifying directory services
        - Users/groups/permissions/organizations
    - Linux can authenticate users with an LDAP directory instead of `/etc/passwd`

* sssd: System Security Services Daemon.  
    - Acts as a broker between Linux and identity providers (LDAP, AD)
    - It's how we connect to AD and trust another system
    - Caches identity information and handles logins from LDAP/AD, group lookups,
      offline auth, host-based access control.  
    - Integrates with `sssd.conf`, `pam_sss.so`, `nsswitch.conf`

* oddjob: Tool that can do "odd jobs", like make directories to allow users to login.  
    - Creates home directories when LDAP/AD users log in for the first time.  
    - Use with `authconfig` or `realmd` to enable auto-creation of home dirs.
    - Configure in `/etc/oddjobd.conf`

* krb5: Kerberos v5. Network auth protocol used for providing identity without
  sending passwords over the wire.  
    - Used with AD environments, SSSD+Kerberos logins, and Single Sign-On (SSO)
    - Configure in `/etc/krb5.conf` 
    - `/etc/krb5.keytab` stores keys for the host.

* realm/realmd: Used to join Linux machines to identity domains (like AD)
    - Uses `sssd`, `krb5`, `oddjob`, `pam`, and `nsswitch.conf` under the hood
      ```bash
      realm discover example.com
      realm join example.com
      ```

* wheel (system group in RHEL): The RHEL equivalent to the `sudo` group.  
    - Users in this group have full sudo access. 


## Digging Deeper

---

1. How does `/etc/security/access.conf` come into play with pam_access?
   Read up on it here: <https://man7.org/linux/man-pages/man8/pam_access.8.html>
   - Can you find any other good resources?
   - What is the structure of the access.conf file directives?
2. What other important user access or user management information do you learn by
   reading this? <https://docs.rockylinux.org/books/admin_guide/06-users/>
   - What is the contents of the `/etc/login.defs` file? Why do you care?

## Reflection Questions

---

1. What questions do you still have about this week?

If OpenLDAP isn't used on RHEL 9 anymore, what's used instead? Are windows servers a
necessary evil for hosting an AD auth system?

2. How are you going to use what you've learned in your current role?

I will put these skills on my resume.

