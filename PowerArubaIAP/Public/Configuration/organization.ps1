#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Set-ArubaIAPOrganization {

    <#
        .SYNOPSIS
        Set an organization to Aruba Instant AP

        .DESCRIPTION
        Set organization to Aruba Instant AP

        .EXAMPLE
        Set-ArubaIAPOrganization MyOrg

        Set Organization MyOrg to IAP

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [string]$organization,
        [Parameter (Mandatory = $false)]
        [ipaddress]$iap_ip_addr = ${DefaultArubaIAPConnection}.iap_ip_addr
    )

    Begin {
    }

    Process {

        $uri = "rest/organization"

        $organization_info = @{
            "action"       = "create"
            "organization" = $organization
        }

        $body = @{
            "organization_info" = $organization_info
        }

        if ($PSCmdlet.ShouldProcess($iap_ip_addr, 'Set Organization')) {
            $response = Invoke-ArubaIAPRestMethod -uri $uri -body $body -method 'POST'

            $response
        }
    }

    End {
    }
}

function Remove-ArubaIAPOrganization {

    <#
        .SYNOPSIS
        Remove organization to Aruba Instant AP

        .DESCRIPTION
        Remove organization to Aruba Instant AP

        .EXAMPLE
        Remove-ArubaIAPorganization

        Remove Organization Server to IAP

        .EXAMPLE
        Remove-ArubaIAPOrganization -confirm:$false

        Remove Organization Server to IAP without confirmation
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $false)]
        [ipaddress]$iap_ip_addr = ${DefaultArubaIAPConnection}.iap_ip_addr
    )

    Begin {
    }

    Process {

        $uri = "rest/organization"

        $Organization_info = @{
            "action" = "delete"
        }

        $body = @{
            "organization_info" = $organization_info
        }

        if ($PSCmdlet.ShouldProcess($iap_ip_addr, 'Remove Organization')) {
            $response = Invoke-ArubaIAPRestMethod -uri $uri -body $body -method 'POST'

            $response
        }
    }

    End {
    }
}