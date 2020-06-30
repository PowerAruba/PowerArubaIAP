#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Set-ArubaIAPAntennaGain {

    <#
        .SYNOPSIS
        Set the Antenna Gain of Aruba Instant AP

        .DESCRIPTION
        Configure Antenna Gain of Aruba Instant AP

        .EXAMPLE
        Set-ArubaIAPAntennaGain -aexternalantenna "14 Panel" -gexternalantenna "12 Sector"

        Configure a-external Antenna and g-external Antenna on IAP

        .EXAMPLE
        Set-ArubaIAPAntennaGain -aexternalantenna "14 Panel" -gexternalantenna "12 Sector" -iap_ip_addr 192.0.2.2

        Configure a-external Antenna and g-external Antenna on IAP with address IP 192.0.2.2
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param(
        [Parameter (Mandatory = $true)]
        [string]$aexternalantenna,
        [Parameter (Mandatory = $true)]
        [string]$gexternalantenna,
        [Parameter (Mandatory = $false)]
        [ipaddress]$iap_ip_addr = ${DefaultArubaIAPConnection}.iap_ip_addr
    )

    Begin {
    }

    Process {

        $uri = "rest/antenna-gain"


        $antenna_gain_info = @{
            "a-external-antenna" = $aexternalantenna
            "g-external-antenna" = $gexternalantenna
        }

        $body = @{
            "iap_ip_addr"       = $iap_ip_addr.ToString()
            "antenna_gain_info" = $antenna_gain_info
        }

        if ($PSCmdlet.ShouldProcess($iap_ip_addr, 'Set antenna gain')) {
            $response = Invoke-ArubaIAPRestMethod -uri $uri -body $body -method 'POST'

            $response
        }
    }

    End {
    }
}
