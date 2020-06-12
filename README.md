# Minimalistic TCP and UDP port scanners<br>(port-scan-tcp.ps1 | port-scan-udp.ps1)

A simple yet powerful TCP and UDP port scanners:
* Detection of open, closed and filtered ports (both TCP and UDP)
* Ability to scan a single host, network range or a list of hosts in a file
* Adjustable timeout values for effective and reliable port scanning

Despite the minimalistic design, both port scanners keep track of everything by using a simple state file (scanresults.txt) which is created in the current working directory. This allows the scanners to be easily resumed if they were interrupted or to skip already scanned hosts / ports.

See the main article for detailed description: https://www.infosecmatter.com/minimalistic-tcp-and-udp-port-scanner/

## Usage and examples
```
Import-Module .\port-scan-tcp.ps1
Import-Module .\port-scan-udp.ps1

# Usage:
port-scan-tcp <host(s)> <port(s)>
port-scan-udp <host(s)> <port(s)>
```

**Port check of a single host for port tcp/80 (HTTP)**
```
port-scan-tcp 192.168.205.15 80
```

**Scanning a single host for common TCP ports**
```
port-scan-tcp 10.10.0.1 (21,22,23,25,80,443,445,3389)
```

**Scanning a list of hosts in a file for port tcp/22 (SSH)**
```
port-scan-tcp (gc .\computers.txt) 22
```

**Scanning a network range /24 for port tcp/445 (SMB)**
```
0..255 | foreach { port-scan-tcp 192.168.204.$_ 445 }
```

**Scanning a single host for common UDP services**
```
test-port-udp 192.168.205.15 (53,161,623)
```

**Scanning a network range /24 for port udp/161 (SNMP)**
```
0..255 | foreach { test-port-udp 10.10.0.$_ 161 }
```

**Note**: The port-scan-tcp-compat.ps1 version is for older systems without having .NET 4.5 installed.

## Screenshot

**Scanning a network range for selected TCP ports**
```
0..255 | foreach { port-scan-tcp 192.168.204.$_ (22,80,445) }
```

![portscan-network-range-multiple-ports2](https://user-images.githubusercontent.com/60963123/84473338-f0e90c00-ac99-11ea-937d-9593a0035fd7.png)

For more information, visit https://www.infosecmatter.com/minimalistic-tcp-and-udp-port-scanner/

---

# Minimalistic SMB login bruteforcer (smblogin.ps1)

A simple SMB login attack and password spraying tool.

It takes a list of targets and credentials (username and password) as parameters and it tries to authenticate against each target using the provided credentials.

Despite its minimalistic design, the tool keeps track of everything by writing every result into a text file. This allows the tool to be easily resumed if it was interrupted or skip already compromised targets.

See the main article for detailed description: https://www.infosecmatter.com/minimalistic-smb-login-bruteforcer/

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

---

# Minimalistic AD login bruteforcer (adlogin.ps1)

A simple Active Directory login attack tool.

It takes list of usernames and a password and tries to login with it against specified AD domain using LDAP (directoryservices).

It also retains results in a file in the current working directory, so it can be interrupted and resumed (it will not try to login again if the given user has already been compromised or tried with the given password).

See the main article for detailed description: https://www.infosecmatter.com/minimalistic-ad-login-bruteforcer/

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
