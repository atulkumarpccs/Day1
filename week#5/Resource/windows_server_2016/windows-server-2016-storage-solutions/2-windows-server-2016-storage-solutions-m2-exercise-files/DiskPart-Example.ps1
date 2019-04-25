<#

Author: Mike Pfeiffer

Sample diskpart commands

Disclaimers

!!!!!!!!!!
This script is provided as an example and is not directly intended to be run as-is.
!!!!!!!!!!

This example code is provided without copyright and AS IS.  It is free for you to use and modify.
Note: These demos should not be run as a script. These are the commands that I use in the 
demonstrations and would need to be modified for your environment.

#>

diskpart
select disk 1
convert dynamic
create volume simple size=1000000 disk=1
assign letter=x
format fs=ntfs label='data' quick
