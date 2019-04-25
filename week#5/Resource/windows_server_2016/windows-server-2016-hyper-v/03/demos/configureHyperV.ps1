<# Notes:

Authors: Greg Shields

Goal - Complete various configurations on a Hyper-V host.

Disclaimers

!!!!!!!!!!
This script is provided primarily as an example series of cmdlets and
is not directly intended to be run as-is.
!!!!!!!!!!

This example code is provided without copyright and AS IS.  It is free for you to use and modify.
Note: These demos should not be run as a script. These are the commands that I use in the 
demonstrations and would need to be modified for your environment.

#>

### Configure HYPERV1

systeminfo
d:\setup64.exe /S /v "/qn REBOOT=Y"
powershell
New-NetIPAddress -interfacealias ethernet0 -IPAddress 192.168.3.200 -Prefixlength 24 -defaultgateway 192.168.3.2
Set-DNSClientServerAddress -interfacealias ethernet0 -ServerAddress 192.168.3.10
New-NetFirewallRule -displayname "Allow All Traffic" -direction outbound -action allow
New-NetFirewallRule -displayname "Allow All Traffic" -direction inbound -action allow
Add-Computer -newname hyperv1 -domainname company.pri -restart

### Install Hyper-V and Management Tools

get-windowsfeature -computername hyperv1
install-windowsfeature -computername hyperv1 -name hyper-v
restart-computer -computername hyperv1
install-windowsfeature -computername hyperv1 -name rsat-hyper-v-tools
install-windowsfeature -computername hyperv1 -name hyper-v-powershell

get-windowsoptionalfeature -online | where featurename -like "*hyper*"

### Create a New VM

new-vm -computername hyperv1 -name vm1 -generation 2 -memorystartupbytes 2GB -newvhdpath vm1.vhdx -newvhdsizebytes 60000000000 -switchname external
start-vm -computername hyperv1 -name vm1

### Perform Configurations via PowerShell Direct

Enter-PSSession -VMName nanoserver1
get-process
Invoke-Command -VMName nanoserver1 -ScriptBlock { get-process }   (as company\administrator)
$session = New-PSSession -VMName nanoserver1 -Credential (Get-Credential)
Copy-Item -FromSession $session -Path C:\nanoserver1.txt -Destination C:\

### Upgrade Hyper-V VMs

Get-VMHostSupportedVersion -ComputerName hyperv1
New-VM -computername hyperv1 -name VM2 -version 5.0
update-vmversion -computername hyperv1 -name vm2

### Delege VM Management

### Begin by creating a new Active Directory Global group = "RebootOnly" and add jhelmick account
New-PSRoleCapabilityFile -path ./RebootOnly.psrc
### Enable VisibleCmdlets = Restart-VM, Get-VM
### Create Folder = C:\Program Files\WindowsPowerShell\Modules\RebootOnly
### Create Folder = C:\Program Files\WindowsPowerShell\Modules\RebootOnly\RoleCapabilities
### Move hypervoperator.psrc to to C:\Program Files\WindowsPowerShell\Modules\RebootOnly\RoleCapabilities
New-PSSessionConfigurationFile -path ./RebootOnly.pssc -full
### Change SessionType to RestrictedRemoteServer
### Change RunAsVirtualAccount to $true
### Change RoleDefinitions to || RoleDefinitions = @{ 'COMPANY\RebootOnly' = @{ RoleCapabilities = 'RebootOnly' } } 
Register-PSSessionConfiguration -Name "RebootOnly" -Path ./RebootOnly.pssc
Get-PSSessionConfiguration
Exit
Enter-PSSession hyperv1 -ConfigurationName "RebootOnly" -Credential "company\jhelmick"
Get-Command

### Implement nested virtualization

Set-VMProcessor -VMName <VMName> -ExposeVirtualizationExtensions $true
Get-VMNetworkAdapter -VMName nanoserver1 | Set-VMNetworkAdapter -MacAddressSpoofing On