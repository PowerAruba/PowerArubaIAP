#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Set-ArubaIAPSwarmMode {

    <#
        .SYNOPSIS
        Set the Swarm Mode of Aruba Instant AP

        .DESCRIPTION
        Configure the Swarm Mode (standalone or cluster) of Aruba Instant AP
        Need to restart IAP for change mode

        .EXAMPLE
        Set-ArubaIAPSwarnMode -swarmmode cluster

        Set mode cluster on the IAP

        .EXAMPLE
        Set-ArubaIAPSwarnMode -swarmmode standalone -iap_ip_addr 192.0.2.2

        Set mode standalone on the IAP  with address IP 192.0.2.2
    #>

    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [ValidateSet('Cluster', 'standalone')]
        [string]$swarmmode,
        [Parameter (Mandatory = $false)]
        [ipaddress]$iap_ip_addr = ${DefaultArubaIAPConnection}.iap_ip_addr
    )

    Begin {
    }

    Process {

        $uri = "rest/swarm-mode"


        $swarmmode_info = @{
            "swarm-mode" = $swarmmode
        }

        $body = @{
            "iap_ip_addr" = $iap_ip_addr.ToString()
            "swarm-mode"  = $swarmmode_info
        }

        $response = Invoke-ArubaIAPRestMethod -uri $uri -body $body -method 'POST'

        $response
    }

    End {
    }
}
