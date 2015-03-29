function Get-DomainUser {
    PARAM($DisplayName)
    $Search = [adsisearcher]"(&(objectCategory=person)(objectClass=User)(displayname=$DisplayName))"
    foreach ($user in $($Search.FindAll())){
        New-Object -TypeName PSObject -Property @{
            "DisplayName" = $user.properties.displayname
            "UserName"    = $user.properties.samaccountname
            "Description" = $user.properties.description
            }
    }
}


Get-DomainUser -DisplayName "*grazi*" | Format-List