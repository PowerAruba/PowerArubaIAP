#
# Copyright 2018, Alexis La Goutte <alexis.lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

#Code coming from
# https://stackoverflow.com/questions/35260354/powershell-wget-protocol-violation
# https://social.technet.microsoft.com/Forums/security/en-US/8ca2eb90-63fe-4f60-9f00-344fc321383b/simple-invokewebrequest-produces-protocol-violation-when-attempting-to-xml-login-to-a-web-based?forum=winserverpowershell

function Set-UseUnsafeHeaderParsing {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessforStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSReviewUnusedParameter", "")]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Enable')]
        [switch]$Enable,

        [Parameter(Mandatory, ParameterSetName = 'Disable')]
        [switch]$Disable
    )

    $ShouldEnable = $PSCmdlet.ParameterSetName -eq 'Enable'

    $netAssembly = [Reflection.Assembly]::GetAssembly([System.Net.Configuration.SettingsSection])

    if ($netAssembly) {
        $bindingFlags = [Reflection.BindingFlags] 'Static,GetProperty,NonPublic'
        $settingsType = $netAssembly.GetType('System.Net.Configuration.SettingsSectionInternal')

        $instance = $settingsType.InvokeMember('Section', $bindingFlags, $null, $null, @())

        if ($instance) {
            $bindingFlags = 'NonPublic', 'Instance'
            $useUnsafeHeaderParsingField = $settingsType.GetField('useUnsafeHeaderParsing', $bindingFlags)

            if ($useUnsafeHeaderParsingField) {
                $useUnsafeHeaderParsingField.SetValue($instance, $ShouldEnable)
            }
        }
    }
}