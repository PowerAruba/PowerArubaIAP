
# PowerArubaIAP

This is a Powershell module for configure a Aruba Instant AP (IAP)

<p align="center">
<img src="https://raw.githubusercontent.com/PowerAruba/PowerArubaIAP/master/Medias/PowerArubaIAP.png" width="250" height="250" />
</p>

With this module (version 0.3.0) you can manage:

- Show commands
- Action API
- Configuration API (Partially)

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


### Monitoring

#### Show command

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
### Action
For each action, you can use -iap_ip_addr for configure an IAP of cluster (using IP Address)

#### Hostname

```powershell
# Configure IAP (Host)Name
    Set-ArubaIAPHostname MyIAP
```

#### Radio State

```powershell
# For enable Radio (5Ghz and 2,4Ghz)
    Set-ArubaIAPRadioState -dot11a -dot11g

# For disable Radio
    Set-ArubaIAPRadioState -dot11a:$false -dot11g:$false
```

#### Channel and Power

```powershell
# for configure manually channel and Power for 802.11a (5Ghz) and 802.11g (2,4Ghz)
    Set-ArubaIAPChannelPower -apower 10 -achannel 36 -gpower 15 -g-channel 1

```


#### Swarm Mode

```powershell
# Use Standalone Mode
    Set-ArubaIAPSwarmmode Standalone

# Use Cluster Mode (default)
    Set-ArubaIAPSwarmmode Cluster
```

#### Zone

```powershell
# Add IAP to a Zone
    Add-ArubaIAPZone MyZone

# Remove all zone of IAP
    Remove-ArubaIAPZone
```

### Configuration

#### AP Reboot

```powershell
# Restart All AP of the cluster
    Restart-ArubaIAPReboot -target all

# Restart only AP with IP Address 192.0.2.1
   Restart-ArubaIAPReboot -iap_ip_addr 192.0.2.1 -target single
```

#### VC Country Code

```powershell
# Set Virtual Controller Country Code to FR
    Set-ArubaIAPCountryCode -country_code FR

# Remove Virtual Controller Country code
    Remove-ArubaIAPCountryCode
```

#### VC IP Address

```powershell
# Set Virtual Controller IP(v4) Address to 192.0.2.1
    Set-ArubaIAPVCIP -vc_ip 192.0.2.1
```

#### NTP Server

```powershell
# Set NTP Server to pool.ntp.org
    Set-ArubaIAPNTP -ntp pool.ntp.org

# Remove NTP Server
    Remove-ArubaIAPNTP
```

#### System Location

```powershell
# Set System Location to PowerAruba
    Set-ArubaIAPSyslocation -syslocation PowerAruba

# Remove System Location
    Remove-ArubaIAPSyslocation
```

#### Organization

```powershell
# Set Organization to MyOrg
    Set-ArubaIAPOrganization -syslocation MyOrg

# Remove Organization
    Remove-Organization
```

#### Syslog Server

```powershell
# Set Syslog Server to 192.0.2.1
    Set-ArubaIAPSyslogServer 192.0.2.1

# Remove Syslog Server
    Remove-ArubaIAPSyslogServer
```

#### Syslog Level

```powershell
# Set Syslog Level to debug (composant syslog)
    Set-ArubaIAPSyslogLevel -level debug

#Set Syslog Level to error from composant network
    Set-ArubaIAPSyslogLevel -level error -composant network

# Remove Syslog Level
    Remove-ArubaIAPSyslogLevel
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
Remove-ArubaIAPCountryCode
Remove-ArubaIAPNTP
Remove-ArubaIAPOrganization
Remove-ArubaIAPSyslocation
Remove-ArubaIAPSyslogLevel
Remove-ArubaIAPSyslogServer
Remove-ArubaIAPZone
Restart-ArubaIAPReboot
Set-ArubaIAPAntennaGain
Set-ArubaIAPChannelPower
Set-ArubaIAPCipherSSL
Set-ArubaIAPConnection
Set-ArubaIAPCountryCode
Set-ArubaIAPHostname
Set-ArubaIAPNTP
Set-ArubaIAPOrganization
Set-ArubaIAPRadioState
Set-ArubaIAPSwarmMode
Set-ArubaIAPSyslocation
Set-ArubaIAPSyslogLevel
Set-ArubaIAPSyslogServer
Set-ArubaIAPuntrustedSSL
Set-ArubaIAPVCIP
Set-ArubaIAPZone
Set-UseUnsafeHeaderParsing
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
