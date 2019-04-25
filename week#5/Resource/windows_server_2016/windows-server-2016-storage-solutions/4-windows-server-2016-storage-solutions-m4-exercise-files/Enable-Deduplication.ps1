<#

Author: Mike Pfeiffer

Enable volume dedudplication

Disclaimers

!!!!!!!!!!
This script is provided as an example and is not directly intended to be run as-is.
!!!!!!!!!!

This example code is provided without copyright and AS IS.  It is free for you to use and modify.
Note: These demos should not be run as a script. These are the commands that I use in the 
demonstrations and would need to be modified for your environment.

#>

#Install the dedup service
Install-WindowsFeature FS-Data-Deduplication -IncludeAllSubFeature

#Enable dedup on a volume
Enable-DedupVolume -Volume D: -UsageType Default

#Modify the volume dedup policy
Set-DedupVolume -Volume D: -MinimumFileAgeDays 0 

#Manually invoke optimzation for the dedup volume
Start-DedupJob –Volume D: -Type Optimization -Memory 50