#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-ArubaIAPShowCmd {

    <#
        .SYNOPSIS
        Get the result of a cli command on Aruba Instant AP

        .DESCRIPTION
        Get the result of a cli command.

        Following command are available :
        show clients, show aps, show running-config, show stats ap <IP-address>, show version, show summary, show wired-port-settings
        show port status, show network, show client debug, show network <name>, show network <name>, show log iap-bootup, show client status <mac>

        .EXAMPLE
        Get-ArubaIAPShowCmd  -cmd "Show running-config"

        This function give you the result (status, status-code, Cli Command, IAP IP Address, Command Output...) of a cli command on the IAP.

        .EXAMPLE
        Get-ArubaIAPShowCmd  -cmd "Show running-config" -display_result

        This function give only ther esult of a cli command on the IAP.
    #>

    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [string]$cmd,
        [Parameter (Mandatory = $false)]
        [ipaddress]$iap_ip_addr = ${DefaultArubaIAPConnection}.iap_ip_addr,
        [Parameter (Mandatory = $false)]
        [switch]$display_result
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }

        $invokeParams.add( 'iap_ip_addr', $iap_ip_addr )

        #Replace space by %20
        $cmd = $cmd -replace ' ', '%20'

        $uri = "rest/show-cmd?cmd=$cmd"

        $response = Invoke-ArubaIAPRestMethod -uri $uri -method 'GET' @invokeParams

        if ($display_result) {
            #only display CLI output
            $response.'Command output'
        }
        else {
            $response
        }
    }

    End {
    }
}
