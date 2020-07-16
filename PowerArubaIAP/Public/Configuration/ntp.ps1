#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Set-ArubaIAPNTP {

    <#
        .SYNOPSIS
        Set a NTP to Aruba Instant AP

        .DESCRIPTION
        Set NTP (IP Address or FQDN) to Aruba Instant AP

        .EXAMPLE
        Set-ArubaIAPNTP 192.0.2.1

        Set NTP 192.0.2.1 to IAP

        .EXAMPLE
        Set-ArubaIAPNTP -ntp pool.ntp.org

        Set NTP pool.ntp.org to IAP
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [string]$ntp,
        [Parameter (Mandatory = $false)]
        [ipaddress]$iap_ip_addr = ${DefaultArubaIAPConnection}.iap_ip_addr
    )

    Begin {
    }

    Process {

        $uri = "rest/ntp-server"

        $ntp_server = @{
            "action"        = "create"
            "ntp_server_ip" = $ntp
        }

        $body = @{
            "ntp-server" = $ntp_server
        }

        if ($PSCmdlet.ShouldProcess($iap_ip_addr, 'Set NTP')) {
            $response = Invoke-ArubaIAPRestMethod -uri $uri -body $body -method 'POST'

            $response
        }
    }

    End {
    }
}

function Remove-ArubaIAPNTP {

    <#
        .SYNOPSIS
        Remove NTP to Aruba Instant AP

        .DESCRIPTION
        Remove NTP to Aruba Instant AP

        .EXAMPLE
        Remove-ArubaIAPNTP

        Remove NTP Server to IAP

        .EXAMPLE
        Remove-ArubaIAPNTP -confirm:$false

        Remove NTP Server to IAP without confirmation
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $false)]
        [ipaddress]$iap_ip_addr = ${DefaultArubaIAPConnection}.iap_ip_addr
    )

    Begin {
    }

    Process {

        $uri = "rest/ntp-server"

        $ntp_server = @{
            "action" = "delete"
        }

        $body = @{
            "ntp-server" = $ntp_server
        }

        if ($PSCmdlet.ShouldProcess($iap_ip_addr, 'Remove NTP')) {
            $response = Invoke-ArubaIAPRestMethod -uri $uri -body $body -method 'POST'

            $response
        }
    }

    End {
    }
}