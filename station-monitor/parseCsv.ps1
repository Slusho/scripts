# Station Monitor v1 #
# Will Thornton #
$arr = @()
do{
del status.html
#del status1.csv
$date = Get-Date
echo '<html>','<head>','<link rel="stylesheet" type="text/css" href="mystyle.css">','<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>','<script src="scripts.js"></script>','</head><body><div class="header">'"Last Update: $date // "'</div>', '<div id="dept1" class="row"></div>' | Out-File -FilePath status.html
$csv = Import-Csv .\status.csv
$count = 0

#echo $date

$csv | ForEach-Object {
#   $count++
    $testcon = Test-Connection -ComputerName ($_ | select -ExpandProperty Host) -BufferSize 16 -Count 1 -ErrorAction 0
    if(!($testcon)) {
        $status1 = "DOWN"
        #$IP1 = ($testcon.IPV4Address).IPAddressToString
        $hostName1 = $_ | select -ExpandProperty Host
        #$model1 = Get-WmiObject -ComputerName $_ -class Win32_ComputerSystem
        $statusObjDown = New-Object -TypeName PSObject
        Add-Member -InputObject $statusObjDown -MemberType NoteProperty -Name Status -Value $status1
        Add-Member -InputObject $statusObjDown -MemberType NoteProperty -Name IPAddress -Value ""
        Add-Member -InputObject $statusObjDown -MemberType NoteProperty -Name Host -Value $hostName1
        Add-Member -InputObject $statusObjDown -MemberType NoteProperty -Name Model -Value ($_ |  select -ExpandProperty Model)
       Add-Member -InputObject $statusObjDown -MemberType NoteProperty -Name Location -Value ($_ |  select -ExpandProperty Location)
#       Add-Member -InputObject $statusObjDown -MemberType NoteProperty -Name Contact -Value ($_ | select -ExpandProperty Contact)
        
        $arr += $statusObjDown

#        echo '<div id=' "$count" ' class="group">',
#        '<div class="status">'$statusObjDown.Status'</div>',
#        '<div class="ip">Not found'$statusObjDown.IPAddress'</div>',
#        '<div class="host">'$statusObjDown.Host'</div>',
#        '<div class="model">'$statusObjDown.Model'</div>',
#        '<div class="loc">'$statusObjDown.Location'</div>',
#        '</div>' | Out-File -FilePath status.html -Append
#
#        echo $statusObjDown| Export-Csv -Path status1.csv -NoTypeInformation -Force -Append
    }
    else
    {
        #Set-Content -Path results.txt -Value "$_, 'connected'"
        $status = "UP"
        $IP = ($testcon.IPV4Address).IPAddressToString
        $hostName = ($_ | select -ExpandProperty Host)
        $model = Get-WmiObject -ComputerName ($_ | select -ExpandProperty Host) -class Win32_ComputerSystem
        #"$_,",($testcon.IPV4Address).IPAddressToString | Out-File -Encoding ascii -Append results.txt  
        $statusObj = New-Object -TypeName PSObject
        Add-Member -InputObject $statusObj -MemberType NoteProperty -Name Status -Value $status
        Add-Member -InputObject $statusObj -MemberType NoteProperty -Name IPAddress -Value $IP
        Add-Member -InputObject $statusObj -MemberType NoteProperty -Name Host -Value $hostName
        Add-Member -InputObject $statusObj -MemberType NoteProperty -Name Model -Value $model.Model
       Add-Member -InputObject $statusObj -MemberType NoteProperty -Name Location -Value ($_ |  select -ExpandProperty Location)
#       Add-Member -InputObject $statusObj -MemberType NoteProperty -Name Contact -Value ($_ | select -ExpandProperty Contact)
        #echo $model.Model
        $arr += $statusObj
#        echo $statusObj | Export-Csv -Path status1.csv -NoTypeInformation -Append
#        echo '<div id=' "$count" ' class="group">',
#             '<div class="status">'$statusObj.Status'</div>',
#             '<div class="ip">'$statusObj.IPAddress'</div>',
#             '<div class="host">'$statusObj.Host'</div>',
#             '<div class="model">'$statusObj.Model'</div>',
#             '<div class="loc">'$statusObj.Location'</div>',
#             '</div>' | Out-File -FilePath status.html -Append
    }
}

#echo '</body></html>' | Out-File -FilePath status.html -Append
echo $arr | Sort-Object Location -descending
echo $arr | Sort-Object Location -descending | Export-Csv -Path status1.csv -NoTypeInformation 
foreach($item in $arr | Sort-Object Location -descending){
$count++
$ip
if($item.IPAddress -eq ''){
    $ip = 'IP not found'
}
else{$ip = $item.IPAddress}
echo '<div class="item">',
     '<div id=' "id_$count" ' class="group">',
     '<div class="status">'$item.Status'</div>',
     '<div class="ip">'$ip '</div>',
     '<div class="host">'$item.Host'</div>',
     '<div class="model">'$item.Model'</div>',
     '<div class="loc">'$item.Location'</div>',
#    '<div class="contact">'$item.Contact'</div>',
     '</div>',
     '</div>' | Out-File -FilePath status.html -Append
}

echo '</body></html>' | Out-File -FilePath status.html -Append

$shell = New-Object -ComObject Shell.Application
$shell.Windows() | 
               Where-Object { $_.Document.url -like '*' } | 
               ForEach-Object { $_.Refresh() }

start-sleep 500;

$arr = @()

}

while(1)

#   function Refresh-WebPages {
#        param(
#            $interval = 5
#        )
#        "Refreshing IE Windows every $interval seconds."
#        "Press any key to stop."
#        $shell = New-Object -ComObject Shell.Application
#        do {
#            'Refreshing ALL HTML'
#            $shell.Windows() | 
#                Where-Object { $_.Document.url -like '*' } | 
#                ForEach-Object { $_.Refresh() }
#            Start-Sleep -Seconds $interval
#        } until ( [System.Console]::KeyAvailable )
#        [System.Console]::ReadKey($true) | Out-Null
#    }
#
#    Refresh-WebPages -interval 30