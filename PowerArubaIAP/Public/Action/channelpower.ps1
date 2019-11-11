#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Set-ArubaIAPChannelPower {

    <#
        .SYNOPSIS
        Set the Channel and Power of Aruba Instant AP

        .DESCRIPTION
        Configure Channel and Power (a and g) of Aruba Instant AP
        There is no API call to set back to auto assignement (ARM)

        .EXAMPLE
        Set-ArubaIAPChannelPower -achannel 44 -apower 10 -gchannel 1 -gpower 5

        Set 802.11a (5Ghz) Power to 10 (dBm),Channel to 44 and 802.11g (2,4Ghz) Power to 5 (dBm), Channel to 1 on IAP

        .EXAMPLE
        Set-ArubaIAPChannelPower -achannel 100 -apower -5 -gchannel 6 -gpower 20 -iap_ip_addr 192.0.2.2

        Set 802.11a (5Ghz) Power to -5 (dBm),Channel to 100 and 802.11g (2,4Ghz) Power to 20 (dBm), Channel to 6 on IAP with address IP 192.0.2.2

    #>

    Param(
        [Parameter (Mandatory = $true)]
        [ValidateSet(36, 40, 44, 48, 52, 56, 60, 64, 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 149, 153, 157, 161, 165,
            "36+", "44+", "52+", "60+", "100+", "108+", "116+", "124+", "132+", "149+", "157+", "36E", "52E", "100E", "116E", "149E")]
        [string]$achannel,
        [Parameter (Mandatory = $true)]
        [ValidateRange(-51, 50)]
        [int]$apower,
        [Parameter (Mandatory = $true)]
        [ValidateSet(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, "1+", "2+", "3+", "4+", "5+", "6+", "7+", "8+", "9+")]
        [string]$gchannel,
        [Parameter (Mandatory = $true)]
        [ValidateRange(-51, 50)]
        [int]$gpower,
        [Parameter (Mandatory = $false)]
        [ipaddress]$iap_ip_addr = ${DefaultArubaIAPConnection}.iap_ip_addr
    )

    Begin {
    }

    Process {

        $uri = "rest/channel"


        $aconfig = @{
            "channel_name" = $achannel
            "tx_power"     = $apower.ToString()
        }
        $gconfig = @{
            "channel_name" = $gchannel
            "tx_power"     = $gpower.ToString()
        }
        $channel = @{
            "a-channel" = $aconfig
            "g-channel" = $gconfig
        }

        $body = @{
            "iap_ip_addr" = $iap_ip_addr.ToString()
            "channel"     = $channel
        }
        $body | ConvertTo-Json

        $response = Invoke-ArubaIAPRestMethod -uri $uri -body $body -method 'POST'

        $response
    }

    End {
    }
}
