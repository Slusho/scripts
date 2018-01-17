$CSV = Import-Csv .\IahHangar.csv

$CSV | ForEach-Object {
    $TestConnection = Test-Connection -ComputerName ($_ | select -ExpandProperty "Service Tag") -BufferSize 16 -Count 1 -ErrorAction 0
    if(!($TestConnection)){
        $param = @{
            "Service Tag" = $_."Service Tag"
            "Asset Tag" = $_."Asset Tag"
            Location = $_.Location
            Site = $_."Site Location"
            Notes = $_.Notes
            Model = $_.Model
            IPAddress = "No connection"
        }
        $Workstation = New-Object -TypeName psobject -Property $param
        $Workstation
     }
     else
     {
         $param = @{
            "Service Tag" = $_."Service Tag"
            "Asset Tag" = $_."Asset Tag"
            Location = $_.Location
            Site = $_."Site Location"
            Notes = $_.Notes
            Model = $_.Model
            IPAddress = $TestConnection.IPV4Address.IPAddressToString
        }
        $Workstation = New-Object -TypeName psobject -Property $param
        $Workstation 
     }       
}
        