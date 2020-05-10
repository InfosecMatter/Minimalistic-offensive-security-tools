# Minimalistic offensive security tools

A repository of tools for pentesting of restricted and isolated environments.

# Minimalistic SMB login bruteforcer (smblogin.ps1)

A simple SMB login attack and password spraying tool.

It takes a list of targets and credentials (username and password) as parameters and it tries to authenticate against each target using the provided credentials.

Despite its minimalistic design, the tool keeps track of everything by writing every result into a text file. This allows the tool to be easily resumed if it was interrupted or skip already compromised targets.

## Usage and examples
```
Import-Module .\smblogin.ps1

# Usage:
smblogin <hosts.txt> <username> <password>

# Examples:
smblogin hosts.txt .\Administrator P@ssw0rd
smblogin hosts.txt CORP\bkpadmin P@ssw0rd
```

**Note**: The extra mini version lacks check for port tcp/445, otherwise the functionality is the same.

## Screenshot

SMB password spraying over the network:

![smblogin-1-smb-login-attack-running](https://user-images.githubusercontent.com/60963123/81509090-4b005580-9319-11ea-9706-6cc5d0b60f9a.png)

For more information, visit https://www.infosecmatter.com/minimalistic-smb-login-bruteforcer/

# Minimalistic AD login bruteforcer (adlogin.ps1)

A simple Active Directory login attack tool.

It takes list of usernames and a password and tries to login with it against specified AD domain using LDAP (directoryservices).

It also retains results in a file in the current working directory, so it can be interrupted and resumed (it will not try to login again if the given user has already been compromised or tried with the given password).

## Usage and examples

```
Import-Module .\adlogin.ps1

# Usage:
adlogin <userlist.txt> <domain> <password>

# Example:
adlogin users.txt domain.com P@ssw0rd

# Check results (find valid credentials):
gc adlogin.*.txt | sls True
```

## Screenshot

Password login attack against domain users:

![adlogin-attack-01-started](https://user-images.githubusercontent.com/60963123/81509021-cd3c4a00-9318-11ea-919f-9c6fd7ccfaed.jpg)

For more information, visit https://www.infosecmatter.com/minimalistic-ad-login-bruteforcer/
