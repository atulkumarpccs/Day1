<#

Author: Mike Pfeiffer

Setup Mirrored Storage Space

Disclaimers

!!!!!!!!!!
This script is provided as an example and is not directly intended to be run as-is.
!!!!!!!!!!

This example code is provided without copyright and AS IS.  It is free for you to use and modify.
Note: These demos should not be run as a script. These are the commands that I use in the 
demonstrations and would need to be modified for your environment.

#>

$disks = Get-StoragePool -IsPrimordial $true | 
    Get-PhysicalDisk | Where-Object CanPool -eq $True

$storageSubsystem = Get-StorageSubSystem

New-StoragePool –FriendlyName MyStoragePool `
–StorageSubsystemFriendlyName $storageSubsystem.FriendlyName `
–PhysicalDisks $disks

New-VirtualDisk –FriendlyName MyVirtualDisk `
-StoragePoolFriendlyName MyStoragePool `
-ResiliencySettingName Mirror `
-ProvisioningType Fixed `
-NumberOfDataCopies 2 `
-UseMaximumSize

Get-VirtualDisk –FriendlyName MyVirtualDisk | 
    Get-Disk | Initialize-Disk –Passthru | 
        New-Partition –AssignDriveLetter –UseMaximumSize | 
            Format-Volume -FileSystem NTFS