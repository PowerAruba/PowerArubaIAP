#
# Copyright 2018, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Connect-ArubaIAP {

    <#
      .SYNOPSIS
      Connect to a Aruba Instant Access Point

      .DESCRIPTION
      Connect to a Aruba Instant Access Point
      .EXAMPLE
      Connect-ArubaIAP -Server 192.0.2.1

      Connect to a Aruba Instant Access Point with IP 192.0.2.1 using (Get-)credential

      .EXAMPLE
      Connect-ArubaIAP -Server 192.0.2.1 -SkipCertificateCheck

      Connect to an Aruba Instant Access Point using HTTPS (without check certificate validation) with IP 192.0.2.1 using (Get-)credential

      .EXAMPLE
      $cred = get-credential
      PS C:\>Connect-ArubaIAP -Server 192.0.2.1 -credential $cred

      Connect to a Aruba Instant Access Point with IP 192.0.2.1 and passing (Get-)credential

      .EXAMPLE
      $mysecpassword = ConvertTo-SecureString aruba -AsPlainText -Force
      PS C:\>Connect-ArubaIAP -Server 192.0.2.1 -Username admin -Password $mysecpassword

      Connect to a Aruba Instant Access Point with IP 192.0.2.1 using Username and Password
  #>

    Param(
        [Parameter(Mandatory = $true, position = 1)]
        [String]$Server,
        [Parameter(Mandatory = $false)]
        [String]$Username,
        [Parameter(Mandatory = $false)]
        [SecureString]$Password,
        [Parameter(Mandatory = $false)]
        [PSCredential]$Credentials,
        [Parameter(Mandatory = $false)]
        [switch]$SkipCertificateCheck = $false
    )

    Begin {
    }

    Process {


        $connection = @{server = ""; session = ""; invokeParams = ""; sid = "" }
        $invokeParams = @{DisableKeepAlive = $false; UseBasicParsing = $true; SkipCertificateCheck = $SkipCertificateCheck }

        #If there is a password (and a user), create a credentials
        if ($Password) {
            $Credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)
        }
        #Not Credentials (and no password)
        if ($null -eq $Credentials) {
            $Credentials = Get-Credential -Message 'Please enter administrative credentials for your ArubaIAP Instant Access Point'
        }

        if ("Desktop" -eq $PSVersionTable.PsEdition) {
            #Remove -SkipCertificateCheck from Invoke Parameter (not supported <= PS 5)
            $invokeParams.remove("SkipCertificateCheck")
        }
        else {
            #Core Edition
            #Remove -UseBasicParsing (Enable by default with PowerShell 6/Core)
            $invokeParams.remove("UseBasicParsing")
        }

        #for PowerShell (<=) 5 (Desktop), Enable TLS 1.1, 1.2 and Disable SSL chain trust (needed/recommanded by ArubaIAP)
        if ("Desktop" -eq $PSVersionTable.PsEdition) {
            #Enable TLS 1.1 and 1.2
            Set-ArubaIAPCipherSSL
            if ($SkipCertificateCheck) {
                #Disable SSL chain trust...
                Set-ArubaIAPuntrustedSSL
            }
        }

        $postParams = @{user = $Credentials.username; passwd = $Credentials.GetNetworkCredential().Password }

        $url = "https://${Server}:4343/rest/login"
        $headers = @{ Accept = "application/json"; "Content-type" = "application/json" }

        try {
            $response = Invoke-RestMethod $url -Method POST -Body ($postParams | ConvertTo-Json) -SessionVariable arubaiap -headers $headers  @invokeParams
        }
        catch {
            Show-ArubaIAPException $_
            throw "Unable to connect"
        }

        if ($response.Status -ne "Success" -or $null -eq $response.sid) {
            $errormsg = $response."Error Message"
            throw "Unable to connect ($errormsg)"
        }

        $connection.server = $server
        $connection.session = $arubaiap
        $connection.invokeParams = $invokeParams
        $connection.sid = $response.sid

        set-variable -name DefaultArubaIAPConnection -value $connection -scope Global

        $connection
    }

    End {
    }
}

function Disconnect-ArubaIAP {

    <#
        .SYNOPSIS
        Disconnect to a ArubaIAP Instant Access Point

        .DESCRIPTION
        Disconnect the connection on ArubaIAP Instant Access Point

        .EXAMPLE
        Disconnect-ArubaIAP

        Disconnect the connection

        .EXAMPLE
        Disconnect-ArubaIAP -noconfirm

        Disconnect the connection with no confirmation

    #>

    Param(
        [Parameter(Mandatory = $false)]
        [switch]$noconfirm
    )

    Begin {
    }

    Process {

        $url = "rest/logout"

        if ( -not ( $Noconfirm )) {
            $message = "Remove Aruba Instant Access Point connection."
            $question = "Proceed with removal of Aruba Instant Access Point connection ?"
            $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

            $decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
        }
        else { $decision = 0 }
        if ($decision -eq 0) {
            Write-Progress -activity "Remove Aruba Instant Access Point connection"
            Invoke-ArubaIAPRestMethod -method "POST" -uri $url | Out-Null
            Write-Progress -activity "Remove Aruba Instant Access Point connection" -completed
            if (Get-Variable -Name DefaultArubaIAPConnection -scope global) {
                Remove-Variable -name DefaultArubaIAPConnection -scope global
            }
        }

    }

    End {
    }
}
