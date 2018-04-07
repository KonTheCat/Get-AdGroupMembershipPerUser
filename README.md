# Get-AdGroupMembershipPerUser
PowerShell script to output AD user's group memberships to a CSV file. Filterable by OU for both users and groups.

Mean to be executed on a Domain Controller. Needs to be dot-sourced into the console. 

.SYNOPSIS

Gets a report of users and their AD groups. Filterable by OU for both users and groups. Has an option to exclude users with no groups. Report is placed on desktop by default.   
       
.EXAMPLE

Get-AdGroupMembershipPerUser -UserOU '<OU Distinguished Name>' -Group-OU '<OU Distinguished Name>' -ExcludeNoGroups 
