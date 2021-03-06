#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Invoke-ArubaIAPRestMethod {

    <#
      .SYNOPSIS
      Invoke RestMethod with ArubaIAP connection (internal) variable

      .DESCRIPTION
       Invoke RestMethod with ArubaIAP connection variable (token, csrf..)

      .EXAMPLE
      Invoke-ArubaIAPRestMethod -method "get" -uri "rest/virtual-controller-ip"

      Invoke-RestMethod with ArubaIAP connection for get rest/v1/rest/virtual-controller-ip

      .EXAMPLE
      Invoke-ArubaIAPRestMethod "rest/v1/rest/virtual-controller-ip"

      Invoke-RestMethod with ArubaIAP connection for get rest/v1/rest/virtual-controller-ip uri with default GET method parameter

      .EXAMPLE
      Invoke-ArubaIAPRestMethod -method "post" -uri "rest/v1/rest/virtual-controller-ip" -body $body

      Invoke-RestMethod with ArubaIAP connection for post rest/v1/rest/virtual-controller-ip uri with $body payloaders
    #>

    [CmdletBinding(DefaultParametersetname = "default")]
    Param(
        [Parameter(Mandatory = $true, position = 1)]
        [String]$uri,
        [Parameter(Mandatory = $false)]
        [ValidateSet("GET", "PUT", "POST", "DELETE")]
        [String]$method = "get",
        [Parameter(Mandatory = $false)]
        [psobject]$body,
        [Parameter(Mandatory = $false)]
        [ipaddress]$iap_ip_addr
    )

    Begin {
    }

    Process {

        if ($null -eq $DefaultArubaIAPConnection) {
            Throw "Not Connected. Connect to the Aruba Instant AP with Connect-ArubaIAP"
        }

        $Server = ${DefaultArubaIAPConnection}.Server
        $headers = ${DefaultArubaIAPConnection}.headers
        $invokeParams = ${DefaultArubaIAPConnection}.invokeParams
        $sid = ${DefaultArubaIAPConnection}.sid
        $port = ${DefaultArubaIAPConnection}.port

        $fullurl = "https://${Server}:${port}/${uri}"
        if ($fullurl -NotMatch "\?") {
            $fullurl += "?"
        }

        if ($sid) {
            $fullurl += "&sid=$sid"
        }

        if ($iap_ip_addr) {
            $fullurl += "&iap_ip_addr=$iap_ip_addr"
        }

        $sessionvariable = $DefaultArubaIAPConnection.session
        try {
            if ($body) {
                $response = Invoke-RestMethod $fullurl -Method $method -body ($body | ConvertTo-Json) -Headers $headers -WebSession $sessionvariable @invokeParams
            }
            else {
                $response = Invoke-RestMethod $fullurl -Method $method -Headers $headers -WebSession $sessionvariable @invokeParams
            }
        }

        catch {
            Show-ArubaIAPException $_
            throw "Unable to use ArubaIAP API"
        }
        $response

    }

}