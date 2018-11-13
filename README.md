# ansible-runner
Ansible runner is Docker container to run CD steps with Ansible playbooks for delivering software and configurations to any host (including Windows)

To run playbook for Linux hosts just:
```bash
docker run stolyarenko/ansible-runner -i <invertory> <playbook-name>
```

To run playbook for Windows hosts (local users usage):
Add folowing parameters to `group_vars/all.yml`
```
# file: group_vars/all.yml
ansible_user: user
ansible_password: password
ansible_port: 5986
ansible_connection: winrm
```

or add it to run command:

```bash
docker run \
  stolyarenko/ansible-runner -i <invertory> \
  -e ansible_user: user \
  
  ...
  
  -e ansible_connection: winrm \
  <playbook-name>
```

To use domain user authentication on configurable Windows hosts you need to add configuration file for Kerberos.

Sample kerberos-config.conf:
```config
[logging]
default = FILE:/var/log/krb5libs.log
kdc = FILE:/var/log/krb5kdc.log
admin_server = FILE:/var/log/kadmind.log
[libdefaults]
dns_lookup_realm = true
dns_lookup_kdc = true
ticket_lifetime = 24h
renew_lifetime = 7d
forwardable = true
rdns = false
default_realm = DOMAIN.COM
default_ccache_name = KEYRING:persistent:%{uid}
[realms]
DOMAIN.COM = {
kdc = YOUR_DOMAIN_CONTROLLER.DOMAIN.COM
}
[domain_realm]
.domain.com = DOMAIN.COM 
```
**Attention config values DOMAIN.COM, .domain.com, YOUR_DOMAIN_CONTROLLER is key sensetive**

Auth configuration should be like example below:
```
# file: group_vars/all.yml
ansible_user: user@DOMAIN.COM
ansible_password: password
ansible_port: 5986
ansible_connection: winrm
ansible_winrm_server_cert_validation: ignore
ansible_winrm_transport: kerberos
ansible_winrm_kinit_mode: managed
```

and run with: 
```bash
docker run \
  -v kerberos-config.conf:/etc/krb5.conf \
  stolyarenko/ansible-runner -i <invertory> \
  <playbook-name>
```

Or add params directly to command:
```bash
docker run \
  kerberos-config.conf:/etc/krb5.conf \
  stolyarenko/ansible-runner -i <invertory> \
    -e ansible_user=<user@DOMAIN.COM> \

    ...

    -e ansible_winrm_kinit_mode: managed \
  <playbook-name>
```
