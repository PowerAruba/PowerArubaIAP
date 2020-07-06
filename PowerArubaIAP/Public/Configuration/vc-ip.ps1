#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Set-ArubaIAPVCIP {

    <#
        .SYNOPSIS
        Set the Virtual Controller (VC) IP Address to Aruba Instant AP Cluster

        .DESCRIPTION
        Set the VC IP to Aruba Instant AP Cluster

        .EXAMPLE
        Set-ArubaIAPVCIP 192.0.2.1

        Set IP Address 192.0.2.1 to virtual controller

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [ipaddress]$vc_ip,
        [Parameter (Mandatory = $false)]
        [ipaddress]$iap_ip_addr = ${DefaultArubaIAPConnection}.iap_ip_addr
    )

    Begin {
    }

    Process {

        $uri = "rest/virtual-controller-ip"


        $virtual_controller_ip = @{
            "action"       = "create"
            "vc-ip" = $vc_ip.ToString()
        }

        $body = @{
            "virtual-controller-ip" = $virtual_controller_ip
        }

        if ($PSCmdlet.ShouldProcess($iap_ip_addr, 'Set VC IP')) {
            $response = Invoke-ArubaIAPRestMethod -uri $uri -body $body -method 'POST'

            $response
        }
    }

    End {
    }
}