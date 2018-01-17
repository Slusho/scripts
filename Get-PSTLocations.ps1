$Outlook = New-Object -ComObject "Outlook.Application"
$Mapi = $Outlook.GetNameSpace("mapi")
$Items = $Mapi.GetDefaultFolder(6)
echo $Items