# Pings all ipaddresses in given subnet ip range
# Neatly shows IP address, hostname, manufacturer, and model according to WMI
Write-Host 'Enter desired subnet without last octet. Example xxx.xxx.xxx.'
$subNet = Read-Host 
$ipFrom = Read-Host 'Last octet range FROM '
$ipTo = Read-Host 'Last octet range TO   '

function testRange ($from, $to){
    if($from -gt $to){
        Write-Host 'Invalid IP range!'-ForegroundColor Red
        exit
    }
    else{
        $diff = $to - $from
    }
    $ipArray = @()
    for($i = [Int32]$from; $i -le $diff + [Int32]$from; $i++){
            $ipArray += "$subNet$i"
    }
    $ipArray | ForEach-Object{
        $status = New-Object -TypeName psobject
        $testConn = Test-Connection -ComputerName $_ -BufferSize 16 -Count 2 -ErrorAction 0
        if(!($testConn)){
             #Write-Output "{$_ Not Responding}"
             Add-Member -InputObject $status -MemberType NoteProperty -Name 'IP Address' -Value $_
             Add-Member -InputObject $status -MemberType NoteProperty -Name Name -Value 'IP not in use'
             echo $status |ft -AutoSize
        }
        else{
            $obj = Get-WmiObject -ComputerName $_ -Class Win32_ComputerSystem 

            Add-Member -InputObject $status -MemberType NoteProperty -Name 'IP Address' -Value $_
            Add-Member -InputObject $status -MemberType NoteProperty -Name Name -Value $obj.Name
            Add-Member -InputObject $status -MemberType NoteProperty -Name Manufacturer -Value $obj.Manufacturer
            Add-Member -InputObject $status -MemberType NoteProperty -Name Model -Value $obj.Model
            echo $status | ft -AutoSize
        }
    }
}

testRange $ipFrom $ipTo