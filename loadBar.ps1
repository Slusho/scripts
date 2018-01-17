<# Run this script on local or remote machines to see connected hard disk status
with nifty bar graph! #>

$myDisk = Get-WmiObject -class win32_logicaldisk
$myDisk | ForEach-Object {
$free = ($_.freespace)
$total = ($_.size)
$used = $total - $free
$perUsed = ($used / $total) * 100
$perFree = ($free / $total) * 100
$t = [math]::Round($total/1gb)
$f = [math]::Round($free/1gb)
$u = [math]::Round($used/1gb)
$pu = [math]::Round($perUsed)
$pf = [math]::Round($perFree)

write-host "Volume:    "$_.VolumeName
write-host "DeviceID:  "$_.DeviceID
echo "Total:      $t\Gb"
echo "Used:       $u\Gb"
echo "Free:       $f\Gb"
echo "% used:     $pu%"
echo "% free:     $pf%"

function drawBar{
    $click
    Write-Host '['-NoNewline
    While($click++ -le $pu/100*30-1){  
        write-Host "$([char]0x25A0)" -NoNewline
        Start-Sleep -Milliseconds 5
    }
    $spaceLeft = ((100/100)*30) - $click
    $add = 0
    While($add++ -le $spaceLeft){
    Write-Host ' ' -NoNewline
    }
    Write-Host ']'
    "`n"
}

drawBar
}
