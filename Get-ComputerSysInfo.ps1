$HostName = Read-Host "HostName: "
Get-WmiObject -class win32_computersystem -ComputerName $HostName