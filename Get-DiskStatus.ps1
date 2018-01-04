# Run this script to see connected hard disk status with nifty bar graph!

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
    echo "Total:      $t/Gb"
    echo "Used:       $u/Gb"
    echo "Free:       $f/Gb"
    echo "% used:     $pu%"
    echo "% free:     $pf%"
    
    # Create bar graph
    function drawBar{
        # Tracks how many ticks to draw
        $tick
        Write-Host '['-NoNewline
        # Loop that animates the bar also scales the percentage so bar does not take up too much space
        While($tick++ -le $pu/100*30-1){  
            write-Host "$([char]0x25A0)" -NoNewline
            # Smaller number, faster animation
            Start-Sleep -Milliseconds 5
        }
        # Calculates how much free space at end of the graph
        $spaceLeft = ((100/100)*30) - $tick
        # Tracks empty space to draw to push end of graph
        $add
        # Loop draws empty space and end of graph
        While($add++ -le $spaceLeft){
        Write-Host ' ' -NoNewline
        }
        Write-Host ']'
        # Makes space between reports
        "`n"
    }
    #Calls bar graph function
    drawBar
}
