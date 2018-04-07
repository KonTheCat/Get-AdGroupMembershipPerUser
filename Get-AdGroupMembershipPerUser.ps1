function Get-AdGroupMembershipPerUser {

     <#
    .SYNOPSIS
        Gets a report of users and their AD Groups. Filterable by OU for both users and groups. Option to exclude users with no groups. Report on Desktop by default.    
    .EXAMPLE
        Get-AdGroupMembershipPerUser -UserOU '<OU Distinguished Name>' -Group-OU '<OU Distinguished Name>' -ExcludeNoGroups 
    #>

    [CmdletBinding()]
    Param(
    [Parameter(Mandatory=$False)]
    [string]$UserOU = (Get-addomain).DistinguishedName,
    [Parameter(Mandatory=$False)]
    [string]$GroupOU = (Get-addomain).DistinguishedName,
    [Parameter(Mandatory=$False)]
    [string]$ReportPath,
    [Parameter(Mandatory=$False)]
    [switch]$ExcludeNoGroups 
    )

    #get users, filitered to OU 
    $users = Get-ADUser -SearchBase $UserOU -Filter * 

    $GroupOUForCheck = '*' + $GroupOU

    #foreach user, get groups, filter, add to report

    $Report = @() 
    foreach ($user in $users) {
        $groups = Get-ADPrincipalGroupMembership -Identity $user | Where-Object {$_.DistinguishedName -like $GroupOUForCheck} | Select-Object -ExpandProperty Name
        if ($ExcludeNoGroups -eq ($True)) {
            if ($groups -eq $null){
                Continue
            }
        }
        $ReportObject = New-Object PSobject
        Write-Output "Currently running the report for $user." 
        $ReportObject | Add-Member -type NoteProperty -name 'Name' -value ($user.Name)
        $ReportObject | Add-Member -type NoteProperty -name 'Groups' -value (($groups) -join "; ")
        $Report += $ReportObject
    } 

    #write report
    
    $ReportName = (Get-addomain).DNSRoot + ' AD Group Membership Per User ' + (Get-Date -Format "yyyy-MM-dd-HH-mm") + '.csv'
    if ($ReportPath) {
        $Report | Export-Csv -Path $ReportPath -NoTypeInformation
    } else {
        $ReportPath = $env:USERPROFILE + '\Desktop\' + $ReportName
        $Report | Export-Csv -Path $ReportPath -NoTypeInformation
    }
    
    
}
