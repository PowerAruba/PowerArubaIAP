#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Restart-ArubaIAPReboot {

    <#
        .SYNOPSIS
        Reboot Aruba Instant AP

        .DESCRIPTION
        Launch Reboot of Aruba Instant AP

        .EXAMPLE
        Restart-ArubaIAPReboot all

        Reboot ALL IAP of the cluster

        .EXAMPLE
        Restart-ArubaIAPHostname -target single -iap_ip_addr 192.0.2.1

        Launch only the reboot of IAP with IP Address 192.0.2.1

        .EXAMPLE
        Restart-ArubaIAPReboot all -confirm:$flase

        Reboot ALL IAP of the cluster without confirmation
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [ValidateSet('all', 'single', IgnoreCase = $false)]
        [string]$target,
        [Parameter (Mandatory = $false)]
        [ipaddress]$iap_ip_addr = ${DefaultArubaIAPConnection}.iap_ip_addr
    )

    Begin {
    }

    Process {

        $uri = "rest/reboot"


        $reboot_info = @{
            "target" = $target
        }

        $body = @{
            "iap_ip_addr" = $iap_ip_addr.ToString()
            "reboot-info" = $reboot_info
        }

        if ($PSCmdlet.ShouldProcess($iap_ip_addr, 'Restart IAP')) {
            $response = Invoke-ArubaIAPRestMethod -uri $uri -body $body -method 'POST'

            $response
        }
    }

    End {
    }
}
