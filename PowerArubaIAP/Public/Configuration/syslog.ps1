#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Set-ArubaIAPSyslogLevel {

    <#
        .SYNOPSIS
        Set Syslog Level to Aruba Instant AP

        .DESCRIPTION
        Set Syslog Level (Emergency, Alert, Critical...) to Aruba Instant AP

        .EXAMPLE
        Set-ArubaIAPSyslogLevel -level error -composant network

        Set Syslog Level to error from composant network

        .EXAMPLE
        Set-ArubaIAPSyslogLevel -level debug

        Set Syslog Level to debug from composant "Syslog"
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param(
        [Parameter (Mandatory = $true)]
        [ValidateSet("emergency", "alert", "error", "warning", "notice", "info", "debug", IgnoreCase = $false)]
        [string]$level,
        [Parameter (Mandatory = $false)]
        [ValidateSet("ap-debug", "network", "security", "system", "syslog", "user", "user-debug", "wireless", IgnoreCase = $false)]
        [string]$component,
        [Parameter (Mandatory = $false)]
        [ipaddress]$iap_ip_addr = ${DefaultArubaIAPConnection}.iap_ip_addr
    )

    Begin {
    }

    Process {

        $uri = "rest/syslog-level"

        $syslog_level = @{
            "action"    = "create"
            "level"     = $level
            "component" = $component
        }

        $body = @{
            "syslog-level" = $syslog_level
        }

        if ($PSCmdlet.ShouldProcess($iap_ip_addr, 'Set Syslog Level')) {
            $response = Invoke-ArubaIAPRestMethod -uri $uri -body $body -method 'POST'

            $response
        }
    }

    End {
    }
}

function Remove-ArubaIAPSyslogLevel {

    <#
        .SYNOPSIS
        Remove SyslogLevel to Aruba Instant AP

        .DESCRIPTION
        Remove Syslog Level to Aruba Instant AP

        .EXAMPLE
        Remove-ArubaIAPSyslogLevel

        Remove Syslog Level to IAP

        .EXAMPLE
        Remove-ArubaIAPSyslogLevel -composant network -confirm:$false

        Remove Syslog Level to composant network to IAP without confirmation
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $false)]
        [ValidateSet("ap-debug", "network", "security", "system", "syslog", "user", "user-debug", "wireless", IgnoreCase = $false)]
        [string]$component,
        [Parameter (Mandatory = $false)]
        [ipaddress]$iap_ip_addr = ${DefaultArubaIAPConnection}.iap_ip_addr
    )

    Begin {
    }

    Process {

        $uri = "rest/syslog-level"

        $syslog_level = @{
            "action"    = "delete"
            "component" = $component
        }

        $body = @{
            "syslog-level" = $syslog_level
        }

        if ($PSCmdlet.ShouldProcess($iap_ip_addr, 'Remove Syslog Level')) {
            $response = Invoke-ArubaIAPRestMethod -uri $uri -body $body -method 'POST'

            $response
        }
    }

    End {
    }
}

function Set-ArubaIAPSyslogServer {

    <#
        .SYNOPSIS
        Set a Syslog Server to Aruba Instant AP

        .DESCRIPTION
        Set Server syslog (IP Address or FQDN) to Aruba Instant AP

        .EXAMPLE
        Set-ArubaIAPSyslogServer 192.0.2.1

        Set Syslog Server 192.0.2.1 to IAP

        .EXAMPLE
        Set-ArubaIAPSyslogServer -syslog "192.0.2.1 192.0.2.2"

        Set Syslog Server 192.0.2.1 and 192.0.2.2 to IAP
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [string]$syslog,
        [Parameter (Mandatory = $false)]
        [ipaddress]$iap_ip_addr = ${DefaultArubaIAPConnection}.iap_ip_addr
    )

    Begin {
    }

    Process {

        $uri = "rest/syslog-server"

        $syslog_server = @{
            "action"           = "create"
            "syslog_server_ip" = $syslog
        }

        $body = @{
            "syslog-server" = $syslog_server
        }

        if ($PSCmdlet.ShouldProcess($iap_ip_addr, 'Set Syslog Server')) {
            $response = Invoke-ArubaIAPRestMethod -uri $uri -body $body -method 'POST'

            $response
        }
    }

    End {
    }
}

function Remove-ArubaIAPSyslogServer {

    <#
        .SYNOPSIS
        Remove Syslog Server to Aruba Instant AP

        .DESCRIPTION
        Remove Syslog Server to Aruba Instant AP

        .EXAMPLE
        Remove-ArubaIAPSyslogServer

        Remove Syslog Server to IAP

        .EXAMPLE
        Remove-ArubaIAPSyslogServer -confirm:$false

        Remove Syslog Server to IAP without confirmation
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $false)]
        [ipaddress]$iap_ip_addr = ${DefaultArubaIAPConnection}.iap_ip_addr
    )

    Begin {
    }

    Process {

        $uri = "rest/syslog-server"

        $syslog_server = @{
            "action" = "delete"
        }

        $body = @{
            "syslog-server" = $syslog_server
        }

        if ($PSCmdlet.ShouldProcess($iap_ip_addr, 'Remove Syslog Server')) {
            $response = Invoke-ArubaIAPRestMethod -uri $uri -body $body -method 'POST'

            $response
        }
    }

    End {
    }
}