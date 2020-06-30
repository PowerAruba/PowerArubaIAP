#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Set-ArubaIAPRadioState {

    <#
        .SYNOPSIS
        Set the radio state (on/off) of Aruba Instant AP

        .DESCRIPTION
        Configure Radio state (enable/disable for dot11a or dot11g) of Aruba Instant AP

        .EXAMPLE
        Set-ArubaIAPRadioState -dot11a -dot11g

        Enable dot11a and dot11g on IAP

        .EXAMPLE
        Set-ArubaIAPRadioState -dot11a:$false -dot11g:$false -iap_ip_addr 192.0.2.2

        Disable dot11a and dot11g on IAP with address IP 192.0.2.2
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param(
        [Parameter (Mandatory = $true)]
        [switch]$dot11a,
        [Parameter (Mandatory = $true)]
        [switch]$dot11g,
        [Parameter (Mandatory = $false)]
        [ipaddress]$iap_ip_addr = ${DefaultArubaIAPConnection}.iap_ip_addr
    )

    Begin {
    }

    Process {

        $uri = "rest/radio-state"

        if ($dot11a -eq $true) {
            $dot11a_state = "no"
        }
        else {
            $dot11a_state = "yes"
        }

        if ($dot11g -eq $true) {
            $dot11g_state = "no"
        }
        else {
            $dot11g_state = "yes"
        }

        $radio_state = @{
            "dot11a-radio-disable" = $dot11a_state
            "dot11g-radio-disable" = $dot11g_state
        }

        $body = @{
            "iap_ip_addr" = $iap_ip_addr.ToString()
            "radio_state" = $radio_state
        }

        if ($PSCmdlet.ShouldProcess($iap_ip_addr, 'Set Radio State')) {
            $response = Invoke-ArubaIAPRestMethod -uri $uri -body $body -method 'POST'

            $response
        }
    }

    End {
    }
}
