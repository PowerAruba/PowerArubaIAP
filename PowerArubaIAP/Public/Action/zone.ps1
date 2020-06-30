#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Set-ArubaIAPZone {

    <#
        .SYNOPSIS
        Set a zone to Aruba Instant AP

        .DESCRIPTION
        Set zone to Aruba Instant AP
        Configures zone on an Instant AP. You can configure up to six SSID zones per AP, and up to 32
        SSID zones per ssid-profile. Use comma separators when listing multiple zones.

        .EXAMPLE
        Set-ArubaIAPZone PowerArubaIAP-Zone1

        Set Zone PowerArubaIAP-Zone1 to IAP

        .EXAMPLE
        Set-ArubaIAPZone "PowerArubaIAP-Zone1,PowerArubaIAP-Zone2"

        Set Zone PowerArubaIAP-Zone1 and PowerArubaIAP-Zone2" to IAP

        .EXAMPLE
        Set-ArubaIAPZone -zone PowerArubaIAP-Zone2 -iap_ip_addr 192.0.2.2

        Set PowerArubaIAP-Zone2 zone on IAP with address IP 192.0.2.2
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [string]$zone,
        [Parameter (Mandatory = $false)]
        [ipaddress]$iap_ip_addr = ${DefaultArubaIAPConnection}.iap_ip_addr
    )

    Begin {
    }

    Process {

        $uri = "rest/zone"


        $zone_info = @{
            "action"   = "create"
            "zonename" = $zone
        }

        $body = @{
            "iap_ip_addr" = $iap_ip_addr.ToString()
            "zone_info"   = $zone_info
        }

        if ($PSCmdlet.ShouldProcess($iap_ip_addr, 'Set Zone')) {
            $response = Invoke-ArubaIAPRestMethod -uri $uri -body $body -method 'POST'

            $response
        }
    }

    End {
    }
}

function Remove-ArubaIAPZone {

    <#
        .SYNOPSIS
        Remove zone to Aruba Instant AP

        .DESCRIPTION
        Remove zone to Aruba Instant AP

        .EXAMPLE
        Remove-ArubaIAPZone

        Remove Zone PowerArubaIAP-Zone1 to IAP

        .EXAMPLE
        Remove-ArubaIAPZone  -iap_ip_addr 192.0.2.2

        Remove zone on IAP with address IP 192.0.2.2
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $false)]
        [ipaddress]$iap_ip_addr = ${DefaultArubaIAPConnection}.iap_ip_addr
    )

    Begin {
    }

    Process {

        $uri = "rest/zone"


        $zone_info = @{
            "action" = "delete"
        }

        $body = @{
            "iap_ip_addr" = $iap_ip_addr.ToString()
            "zone_info"   = $zone_info
        }

        if ($PSCmdlet.ShouldProcess($iap_ip_addr, 'Remove Zone')) {
            $response = Invoke-ArubaIAPRestMethod -uri $uri -body $body -method 'POST'

            $response
        }
    }

    End {
    }
}