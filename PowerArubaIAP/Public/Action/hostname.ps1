#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Set-ArubaIAPHostname {

    <#
        .SYNOPSIS
        Set the name of Aruba Instant AP

        .DESCRIPTION
        Configure hostname of Aruba Instant AP

        .EXAMPLE
        Set-ArubaIAPHostname PowerArubaIAP-AP1

        Set PowerArubaIAP-AP1 hostname on IAP

        .EXAMPLE
        Set-ArubaIAPHostname -hostname PowerArubaIAP-AP2 -iap_ip_addr 192.0.2.2

        Set PowerArubaIAP-AP2 hostname on IAP with address IP 192.0.2.2
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [string]$hostname,
        [Parameter (Mandatory = $false)]
        [ipaddress]$iap_ip_addr = ${DefaultArubaIAPConnection}.iap_ip_addr
    )

    Begin {
    }

    Process {

        $uri = "rest/hostname"


        $hostname_info = @{
            "hostname" = $hostname
        }

        $body = @{
            "iap_ip_addr"   = $iap_ip_addr.ToString()
            "hostname_info" = $hostname_info
        }

        if ($PSCmdlet.ShouldProcess($iap_ip_addr, 'Set Hostname')) {
            $response = Invoke-ArubaIAPRestMethod -uri $uri -body $body -method 'POST'

            $response
        }

    }

    End {
    }
}
