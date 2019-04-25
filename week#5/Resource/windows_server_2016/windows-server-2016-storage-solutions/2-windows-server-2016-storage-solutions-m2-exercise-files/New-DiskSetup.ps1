<#

Author: Mike Pfeiffer

Sample one-liner to partition and format a volume

Disclaimers

!!!!!!!!!!
This script is provided as an example and is not directly intended to be run as-is.
!!!!!!!!!!

This example code is provided without copyright and AS IS.  It is free for you to use and modify.
Note: These demos should not be run as a script. These are the commands that I use in the 
demonstrations and would need to be modified for your environment.

#>

Get-Disk | 
    Where-Object PartitionStyle -eq 'raw' |
        Initialize-Disk -PassThru |
            New-Partition -UseMaximumSize -AssignDriveLetter |
                Format-Volume -FileSystem ReFS 
