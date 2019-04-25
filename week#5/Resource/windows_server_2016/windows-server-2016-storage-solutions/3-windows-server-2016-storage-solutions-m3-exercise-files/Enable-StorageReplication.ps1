<#

Author: Mike Pfeiffer

Setup Storage Replica Server to Server Replication

Disclaimers

!!!!!!!!!!
This script is provided as an example and is not directly intended to be run as-is.
!!!!!!!!!!

This example code is provided without copyright and AS IS.  It is free for you to use and modify.
Note: These demos should not be run as a script. These are the commands that I use in the 
demonstrations and would need to be modified for your environment.

#>

#Install Pre-req's
Invoke-Command -ScriptBlock {

    Install-WindowsFeature -Name Storage-Replica,FS-FileServer -IncludeManagementTools -Restart

} -ComputerName server1,server2

#Create partnership
New-SRPartnership -SourceComputerName server1 `
-SourceRGName RG1 `
-SourceVolumeName d: `
-SourceLogVolumeName e: `
-DestinationComputerName server2 `
-DestinationRGName RG2 `
-DestinationVolumeName d: `
-DestinationLogVolumeName e:

#View group settings
Get-SRGroup
(Get-SRGroup).replicas

Get-SRPartnership

#Modify replication source
Set-SRPartnership -NewSourceComputerName server2 `
-SourceRGName RG2 `
-DestinationComputerName server1 `
-DestinationRGName RG1

#Review group settings
Get-SRPartnership

#To disable replication
Get-SRPartnership | Remove-SRPartnership
Get-SRGroup | Remove-SRGroup