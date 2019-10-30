
# PowerArubaIAP

This is a Powershell module for configure a Aruba Instant AP (IAP)

With this module (version 0.1.0) you can manage:

- Show commands

More functionality will be added later.

Connection can use HTTPS (default)
Tested with Aruba Instant AP 207 or AP305 (using 8.5.x.x firmware and later...) on Windows/Linux/macOS

<!--
# Usage

All resource management functions are available with the Powershell verbs GET, ADD, SET, REMOVE.
For example, you can manage Vlans with the following commands:
- `Get-ArubaSWVlans`
- `Add-ArubaSWVlans`
- `Set-ArubaSWVlans`
- `Remove-ArubaSWVlans`
-->
# Requirements

- Powershell 5 or 6 (Core) (If possible get the latest version)
- An Aruba Instant AP (with firmware 8.5.x.x), REST API enable

# Instructions
### Install the module
```powershell
# Automated installation (Powershell 5 or later):
    Install-Module PowerArubaIAP

# Import the module
    Import-Module PowerArubaIAP

# Get commands in the module
    Get-Command -Module PowerArubaIAP

# Get help
    Get-Help Get-ArubaIAPShowCmd -Full
```

# Examples
### Connecting to the Aruba Instant AP

The first thing to do is to connect to a Aruba Instant AP with the command `Connect-ArubaIAP` :

```powershell
# Connect to the Aruba Instant AP
    Connect-ArubaIAP 192.0.2.1

#we get a prompt for credential
```
if you get a warning about `Unable to connect` Look [Issue](#Issue)


### Show command

You can display some command... (CLi to API)

```powershell
# Display clients (show clients)
    Get-ArubaIAPShowCmd "show clients"


    Status               : Success
    Status-code          : 0
    CLI Command executed : show clients

    IAP IP address       : 10.44.55.230
    Command output       : cli output:

                        COMMAND=show clients

                        Client List
                        -----------
                        Name  IP Address  MAC Address  OS  ESSID  Access Point  Channel  Type  Role  IPv6 Address  Signal  Speed (mbps)
                        ----  ----------  -----------  --  -----  ------------  -------  ----  ----  ------------  ------  ------------
                        Number of Clients   :0
                        Info timestamp      :1522412



# Display SSID (Network) and output cli output (-display result)
    Get-ArubaIAPShowCmd "show network" -display_result
    cli output:

    COMMAND=show network

    Networks
    --------
    Profile Name  ESSID      Clients  Type      Band  Authentication Method  Key Management  IP Assignment  Status    Zone  Coding   Active
    ------------  -----      -------  ----      ----  ---------------------  --------------  -------------  ------    ----  ------   ------
    MPSK          MPSK       0        employee  all   None                   WPA2-AES        VLAN 44        Disabled  -     Default  No
    WPA3          WPA3       0        employee  all   None                   WPA3_SAE        Default VLAN   Disabled  -     Default  No
[...]

```


### Disconnecting

```powershell
# Disconnect from the Aruba Instant AP
    Disconnect-IAP
```

# Issue

## Unable to connect (certificate)
if you use `Connect-ArubaIAP` and get `Unable to Connect (certificate)`

The issue coming from use Self-Signed or Expired Certificate for AP management
Try to connect using `Connect-ArubaIAP -SkipCertificateCheck`

## REST API Service is not enabled
if you use `Connect-ArubaIAP` and get `503 Service Unavailable REST API Service is not enabled`

You need to enable REST APi via CLI (SSH)

```code
IAP (config)# allow-rest-api
IAP (config)# exit
IAP# commit apply
```


# List of available command
```powershell
Connect-ArubaIAP
Disconnect-ArubaIAP
Get-ArubaIAPShowCmd
Invoke-ArubaIAPRestMethod
Set-ArubaIAPCipherSSL
Set-ArubaIAPuntrustedSSL
Set-ArubaIAPConnection
Show-ArubaIAPException
```

# Author

**Alexis La Goutte**
- <https://github.com/alagoutte>
- <https://twitter.com/alagoutte>

# Special Thanks

- Warren F. for his [blog post](http://ramblingcookiemonster.github.io/Building-A-PowerShell-Module/) 'Building a Powershell module'
- Erwan Quelin for help about Powershell

# License

Copyright 2019 Alexis La Goutte and the community.
