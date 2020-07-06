#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Set-ArubaIAPCountryCode {

    <#
        .SYNOPSIS
        Set the Country Code to Aruba Instant AP Cluster

        .DESCRIPTION
        Set the Country Code to Aruba Instant AP Cluster

        .EXAMPLE
        Set-ArubaIAPCountryCode FR

        Set Country Code FR (France) to the cluster

        .EXAMPLE
        Set-ArubaIAPCountryCode FR -confirm:$flase

        Set Country Code FR (France) to the cluster without confirmation
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [string]$country_code,
        [Parameter (Mandatory = $false)]
        [ipaddress]$iap_ip_addr = ${DefaultArubaIAPConnection}.iap_ip_addr
    )

    Begin {
    }

    Process {

        $uri = "rest/country-code"

        $country_code_info = @{
            "action"       = "create"
            "country-code" = $country_code
        }

        $body = @{
            "country_code_info" = $country_code_info
        }

        if ($PSCmdlet.ShouldProcess($iap_ip_addr, 'Set Country Code')) {
            $response = Invoke-ArubaIAPRestMethod -uri $uri -body $body -method 'POST'

            $response
        }
    }

    End {
    }
}

function Remove-ArubaIAPCountryCode {

    <#
        .SYNOPSIS
        Remove the Country Code to Aruba Instant AP Cluster

        .DESCRIPTION
        Remove the Country Code to Aruba Instant AP Cluster

        .EXAMPLE
        Remove-ArubaIAPCountryCode

        Remove Country Code

        .EXAMPLE
        Remove-ArubaIAPCountryCode -confirm:$false

        Remove Country Code without confirmation
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $false)]
        [ipaddress]$iap_ip_addr = ${DefaultArubaIAPConnection}.iap_ip_addr
    )

    Begin {
    }

    Process {

        $uri = "rest/country-code"

        $country_code_info = @{
            "action" = "delete"
        }

        $body = @{
            "iap_ip_addr" = $iap_ip_addr.ToString()
            "country_code_info"   = $country_code_info
        }

        if ($PSCmdlet.ShouldProcess($iap_ip_addr, 'Remove Country Code')) {
            $response = Invoke-ArubaIAPRestMethod -uri $uri -body $body -method 'POST'

            $response
        }
    }

    End {
    }
}