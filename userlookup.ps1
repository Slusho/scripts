#Gets User display name, description, email address, and telephone number.
$User = Read-Host 'Employee Number '
$StrFilter = "(&(objectCategory=User)(Description=$User))"
$ObjDomain = New-Object System.DirectoryServices.DirectoryEntry

$ObjSearcher = New-Object System.DirectoryServices.DirectorySearcher
$ObjSearcher.SearchRoot = $ObjDomain
$ObjSearcher.PageSize = 1000
$ObjSearcher.Filter = $StrFilter
$ObjSearcher.SearchScope = "Subtree"

$ColPropList = @("name", "description", "mail", "telephoneNumber")

$ColPropList | ForEach-Object {$ObjSearcher.PropertiesToLoad.Add($_)}
$ColResults = $ObjSearcher.FindAll()

$ColResults | ForEach-Object {
    $ObjItem = $_.Properties 
    Write-Output $ObjItem
}