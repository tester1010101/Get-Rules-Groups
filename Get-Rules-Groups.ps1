##################################################
#               ~ Get-Rules v1.1 ~               #
# ._.       ~ Made by: tester1010101 ~       ._. #
# Get all firewall rules from Windows Defender   #
# Firewall with Advanced Security, + reconverts  #
# them into applicables one through netsh fire.  #
# Dumped in: %USERPROFILE%\Rules\FWCommands.txt  #
#        github.com/tester1010101/PS_Dump/       #
##################################################

#[GetRulesBlocks]##########################################################################
# 1. Creates the Rules folder in %USERPROFILE%\Rules if not present
# 2. Dumps all "allowed" firewall rules into a textfile at %USERPROFILE%\Rules\FW-Rules.txt
# 3. Stock the rules into a variable from the file dumped (user can use custom file/path)
# 4. Parse each rules ending at '(?<=Action:                               Allow)'
# 5. Create a .txt of each rules at %USERPROFILE%\Rules\$i.txt
# 6. Increment until none left

Function GetRulesBlocks{
    $TestPath = Test-Path $env:USERPROFILE\Rules
    if ($TestPath -eq $False) {mkdir $env:USERPROFILE\Rules}
    netsh advfirewall firewall show rule name=all verbose > $env:USERPROFILE\Rules\FW-Rules.txt
    $Rules = Get-Content -Path $env:USERPROFILE\Rules\FW-Rules.txt -raw
    $Rules = $Rules -split '(?<=Action:                               Allow)'
    $i = 1
    ForEach ($Rule in $Rules) {
    $Rule | Out-File $env:USERPROFILE\Rules\$i.txt
    $i++ 
    }
}
GetRulesBlocks


#[Count]##########################################################################
# 1. Gets the last item of the rules dumped, then starts the loop until last rule
# 2. Starting from rule #1, it'll extract all rule's parameters into variables
# 3. Then create a netsh command to re-enter it as needed, with rule's variables
# 4. Each set of variables creates a command which is added to a command file
# 5. Final textfile contains all commands ready to be applied, in the 'netsh' format.

$Count = ((Get-ChildItem $env:USERPROFILE\Rules\).Count) - 3
[int]$iii = 001
Do
{
    $RulePath = "$env:USERPROFILE\Rules\$iii.txt"
    $File = $RulePath
    $Content = Get-Content $File

    [string]$RuleNameTEST = ($Content | Select-String "Rule Name:")
if ($RuleNameTEST.Length -gt 1) { 
    $RuleName = $RuleNameTEST.Substring(38)
    [bool]$RuleNameBool = $True }

[string]$DescriptionTEST = ($Content | Select-String "Description:")
if ($DescriptionTEST.Length -gt 1) { 
    $Description = $DescriptionTEST.Substring(38)
    [bool]$DescriptionBool = $True }

[string]$EnabledTEST = ($Content | Select-String "Enabled:")
if ($EnabledTEST.Length -gt 1) { 
    $Enabled = $EnabledTEST.Substring(38)
    [bool]$EnabledBool = $True }

[string]$DirTEST = ($Content | Select-String "Direction:")
if ($DirTEST.Length -gt 1) { 
    $Dir = $DirTEST.Substring(38)
    [bool]$DirBool = $True }

[string]$ProfileTEST = ($Content | Select-String "Profiles:")
if ($ProfileTEST.Length -gt 1) { 
    $Profile = $ProfileTEST.Substring(38)
    [bool]$ProfileBool = $True }

[string]$GroupingTEST = ($Content | Select-String "Grouping:")
if ($GroupingTEST.Length -gt 39) { 
    $Grouping = $GroupingTEST.Substring(38)
    [bool]$GroupingBool = $True }

[string]$LocalIPTEST = ($Content | Select-String "LocalIP:")
if ($LocalIPTEST.Length -gt 1) { 
    $LocalIP = $LocalIPTEST.Substring(38)
    [bool]$LocalIPBool = $True }

[string]$RemoteIPTEST = ($Content | Select-String "RemoteIP:")
if ($RemoteIPTEST.Length -gt 1) { 
    $RemoteIP = $RemoteIPTEST.Substring(38)
    [bool]$RemoteIPBool = $True }

[string]$ProtocolTEST = ($Content | Select-String "Protocol:")
if ($ProtocolTEST.Length -gt 1) { 
    $Protocol = $ProtocolTEST.Substring(38)
    [bool]$ProtocolBool = $True }

[string]$LocalPortTEST = ($Content | Select-String "LocalPort:")
if ($LocalPortTEST.Length -gt 1) { 
    $LocalPort = $LocalPortTEST.Substring(38)
    [bool]$LocalPortBool = $True }

[string]$RemotePortTEST = ($Content | Select-String "RemotePort:")
if ($RemotePortTEST.Length -gt 1) { 
    $RemotePort = $RemotePortTEST.Substring(38)
    [bool]$RemotePortBool = $True }

[string]$EdgeTEST = ($Content | Select-String "Edge traversal:")
if ($EdgeTEST.Length -gt 1) { 
    $Edge = $EdgeTEST.Substring(38)
    [bool]$EdgeBool = $True }

[string]$ProgramTEST = ($Content | Select-String "Program:")
if ($ProgramTEST.Length -gt 1) { 
    $Program = $ProgramTEST.Substring(38)
    [bool]$ProgramBool = $True }

[string]$ServiceTEST = ($Content | Select-String "Service:")
if ($ServiceTEST.Length -gt 1) { 
    $Service = $ServiceTEST.Substring(38)
    [bool]$ServiceBool = $True }

[string]$InterfaceTEST = ($Content | Select-String "InterfaceTypes:")
if ($InterfaceTEST.Length -gt 1) { 
    $Interface = $InterfaceTEST.Substring(38)
    [bool]$InterfaceBool = $True }

[string]$SecurityTEST = ($Content | Select-String "Security:")
if ($SecurityTEST.Length -gt 1) { 
    $Security = $SecurityTEST.Substring(38)
    [bool]$SecurityBool = $True }

[string]$ActionTEST = ($Content | Select-String "Action:")
if ($ActionTEST.Length -gt 1) { 
    $Action = $ActionTEST.Substring(38)
    [bool]$ActionBool = $True }

$PreCommand = ("netsh advfirewall firewall add rule")
[array]$Matches = @("ICMPv4","ICMPv6")

if ([bool]$RuleNameBool -eq $True) {$PreCommand += " name='$RuleName'" }
if ([bool]$DescriptionBool -eq $True) {$PreCommand += " description='$Description'" }
if ([bool]$EnabledBool -eq $True) {$PreCommand += " enable=$Enabled" }
if ([bool]$DirBool -eq $True) {$PreCommand += " dir=$Dir" }
if ([bool]$ProfileBool -eq $True) {$PreCommand += " profile=$Profile" }
if ([bool]$LocalIPBool -eq $True) {$PreCommand += " localip='$LocalIP'" }
if ([bool]$RemoteIPBool -eq $True) {$PreCommand += " remoteip='$RemoteIP'" }
if ([bool]$ProtocolBool -eq $True) {
    if ($Protocol -in $Matches)
    {
        [string]$Protocols = ($Content | Select-String "Type    Code" -Context 1 | % { $_.Context.PostContext })
        if ($Protocols.Length -gt 1) {
        $Protocols = $Protocols.Substring(38)
        $ProtocolsMod = (-split $Protocols)
        [string]$ICMPType = $ProtocolsMod[0]
        [string]$ICMPCode = $ProtocolsMod[1]
        $PreCommand += (" protocol='$Protocol"+":$ICMPType,$ICMPCode'")
        }
    } else { $PreCommand += " protocol='$Protocol'" }   
}
if ([bool]$LocalPortBool -eq $True) {$PreCommand += " localport='$LocalPort'" }
if ([bool]$RemotePortBool -eq $True) {$PreCommand += " remoteport='$RemotePort'" }
if ([bool]$EdgeBool -eq $True) {$PreCommand += " edge='$Edge'" }
if ([bool]$ProgramBool -eq $True) {$PreCommand += " program='$Program'" }
if ([bool]$ServiceBool -eq $True) {$PreCommand += " service='$Service'" }
if ([bool]$InterfaceBool -eq $True) {$PreCommand += " interface='$Interface'" }
if ([bool]$SecurityBool -eq $True) {$PreCommand += " security='$Security'" }
if ([bool]$ActionBool -eq $True) {$PreCommand += " action='$Action'" }

$Command = ($PreCommand + "`n")

if ([bool]$GroupingBool -eq $True) {
                                        $RuleName2 = $RuleName
                                        $RuleGroup = $Grouping
                                        $PreCommand2 = ( 'Get-NetFirewallRule -DisplayName "' + $RuleName2 + '" | % { $_.Group = "' + $RuleGroup + '" ; Set-NetFirewallRule -InputObject $_ }' )
                                        $Command += ($PreCommand2 + "`n")
}

    $RuleName = $null
    $Description = $null
    $Enabled = $null
    $Dir = $null
    $Profile = $null
    $Grouping = $null
    $LocalIP = $null
    $RemoteIP = $null
    $Protocol = $null
    $Protocols = $null
    $ProtocolsMod = $null
    $LocalPort = $null
    $RemotePort = $null
    $Edge = $null
    $Program = $null
    $Service = $null
    $Interface = $null
    $Security = $null
    $Action = $null
    $RuleName2 = $null
    $RuleGroup = $null
    $PreCommand2 = $null
    ####
    $RuleNameTEST = $null
    $DescriptionTEST = $null
    $EnabledTEST = $null
    $DirTEST = $null
    $ProfileTEST = $null
    $GroupingTEST = $null
    $LocalIPTEST = $null
    $RemoteIPTEST = $null
    $ProtocolTEST = $null
    $LocalPortTEST = $null
    $RemotePortTEST = $null
    $EdgeTEST = $null
    $ProgramTEST = $null
    $ServiceTEST = $null
    $InterfaceTEST = $null
    $SecurityTEST = $null
    $ActionTEST = $null
    ####
    $RuleNameBool = $false
    $DescriptionBool = $false
    $EnabledBool = $false
    $DirBool = $false
    $ProfileBool = $false
    $GroupingBool = $false
    $LocalIPBool = $false
    $RemoteIPBool = $false
    $ProtocolBool = $false
    $ICMPBool = $false
    $LocalPortBool = $false
    $RemotePortBool = $false
    $EdgeBool = $false
    $ProgramBool = $false
    $ServiceBool = $false
    $InterfaceBool = $false
    $SecurityBool = $false
    $ActionBool = $false
    $Commands += $Command
    
    $iii++
}
Until ($iii -eq $Count)

$Commands | Out-File $env:USERPROFILE\Rules\FWCommands.txt
$Commands = $null

################
# Completion ~ #
################
Write-Host "Get-Rules successfully extracted rules and re-created them in: $env:USERPROFILE\Rules\FWCommands.txt" -ForeGroundColor Cyan -BackGroundColor Magenta
Write-Host "Open destination folder? @$ENV:USERPROFILE\Rules\* -> [Y/N]" -ForegroundColor Yellow
$Answer = (Read-Host)
if ($Answer -eq "Y")
{
    explorer $ENV:USERPROFILE\Rules\
}
Write-Host "Press Enter to exit..." -ForegroundColor Red
Read-Host