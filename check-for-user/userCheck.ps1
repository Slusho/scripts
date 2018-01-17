# Script to check if a user has a profile folder on the target host.
# Usage: Enter host names of desired machines in to a text file named 'hostNames' and save in same folder with the script file.

#Variables
$empNum
$compName
$userFolder
Write-Host "Enter emp#:"
$empNum = Read-Host
$compName = Get-Content hostNames.txt
$count = 0
$total = 0
foreach($computer in $compName){
    $userFolder = "\\$computer\c$\Users"
    $Profile = Get-ChildItem $userFolder -Name

    if($Profile -eq $empNum){
        $count++
        Write-Host $empNum "is found on" $computer 
    }
    else{ Write-Host "User not found on" $computer }
    $total++
}

Write-Host $count "out of" $total "hosts."
#del hostNames.txt
#Write-Host "hostNames.txt has been deleted"