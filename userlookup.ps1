# Gets User display name, description, email address, telephone number and login name.

$User = Read-Host 'Employee Search'
$StrFilter = "(&(objectCategory=User)(|((sAMAccountName=$User)(Description=$User)(Name=$User))))"
$ObjDomain = New-Object System.DirectoryServices.DirectoryEntry

$ObjSearcher = New-Object System.DirectoryServices.DirectorySearcher
$ObjSearcher.SearchRoot = $ObjDomain
$ObjSearcher.PageSize = 1000
$ObjSearcher.Filter = $StrFilter
$ObjSearcher.SearchScope = "Subtree"

# AD propeties to display
$ColPropList = @("name", "description", "mail", "telephoneNumber", "sAMAccountName")
# Added *> $null to suppress unwanted output :)
$ColPropList | ForEach-Object {$ObjSearcher.PropertiesToLoad.Add($_) *> $null}
$ColResults = $ObjSearcher.FindAll()

$ColResults | ForEach-Object {
    $ObjItem = $_.Properties 
    $ObjItem
    Write-Host ' '
}