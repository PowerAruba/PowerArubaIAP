#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Set-ArubaIAPSyslocation {

    <#
        .SYNOPSIS
        Set a Syslocation to Aruba Instant AP

        .DESCRIPTION
        Set Syslocation to Aruba Instant AP

        .EXAMPLE
        Set-ArubaIAPSyslocation -syslocation "PowerAruba"

        Set Syslocation PowerAruba to IAP
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [string]$syslocation,
        [Parameter (Mandatory = $false)]
        [ipaddress]$iap_ip_addr = ${DefaultArubaIAPConnection}.iap_ip_addr
    )

    Begin {
    }

    Process {

        $uri = "rest/syslocation"

        $syslocation_info = @{
            "action"      = "create"
            "syslocation" = $syslocation
        }

        $body = @{
            "syslocation_info" = $syslocation_info
        }

        if ($PSCmdlet.ShouldProcess($iap_ip_addr, 'Set Syslocation')) {
            $response = Invoke-ArubaIAPRestMethod -uri $uri -body $body -method 'POST'

            $response
        }
    }

    End {
    }
}

function Remove-ArubaIAPSyslocation {

    <#
        .SYNOPSIS
        Remove Syslocation to Aruba Instant AP

        .DESCRIPTION
        Remove Syslocation to Aruba Instant AP

        .EXAMPLE
        Remove-ArubaIAPSyslocation

        Remove Syslocation to IAP

        .EXAMPLE
        Remove-ArubaIAPSyslocation -confirm:$false

        Remove Syslocation to IAP without confirmation
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $false)]
        [ipaddress]$iap_ip_addr = ${DefaultArubaIAPConnection}.iap_ip_addr
    )

    Begin {
    }

    Process {

        $uri = "rest/syslocation"

        $syslocation_info = @{
            "action" = "delete"
        }

        $body = @{
            "syslocation_info" = $syslocation_info
        }

        if ($PSCmdlet.ShouldProcess($iap_ip_addr, 'Remove Syslocation')) {
            $response = Invoke-ArubaIAPRestMethod -uri $uri -body $body -method 'POST'

            $response
        }
    }

    End {
    }
}