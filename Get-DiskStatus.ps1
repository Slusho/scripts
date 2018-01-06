# Run this script to see connected hard disk status with nifty bar graph!
Begin {
    function Get-BarGraph($Percent){
        # Max width of graph
        $Width = 20
        Write-Host '['-NoNewline
        # Loop that animates the bar also scales the percentage so bar does not take up too much space
        While($tick++ -le $Percent/100*$Width-1){  
            if ($tick -le $Width / 1.7) {
                Write-Host "$([char]0x25A0)" -NoNewline -ForegroundColor Green
            }
            elseif ($tick -le $Width / 1.1) {
                Write-Host "$([char]0x25A0)" -NoNewline -ForegroundColor Yellow
            }
            else {
                Write-Host "$([char]0x25A0)" -NoNewline -ForegroundColor Red
            } 
            # Smaller number, faster animation
            Start-Sleep -Milliseconds 5
        }
        # Calculates how much free space at end of the graph
        $spaceLeft = ((1)*$Width) - $tick
        # Loop draws empty space and end of graph
        While($add++ -le $spaceLeft){
            Write-Host ' ' -NoNewline
        }
        Write-Host ']'
        # Makes space between reports
        "`n"
    }
    $myDisk = Get-WmiObject -class win32_logicaldisk
}

Process {
    $myDisk | ForEach-Object {
        if ($_.Drivetype -ne 4) {
            $TotalSpace = [Math]::Round($_.Size / 1gb)
            $FreeSpace = [Math]::Round($_.Freespace / 1gb)
            $UsedSpace = [Math]::Round(($_.Size - $_.FreeSpace) / 1gb)
            $PercentUsed = [Math]::Round((($_.Size - $_.FreeSpace) / $_.Size) * 100)
            $PercentFree = [Math]::Round(($_.FreeSpace / $_.Size) * 100)
            
            $param = @{
                Volume = $_.VolumeName
                DriveLetter = $_.DeviceID
                TotalSpace = "$TotalSpace GB"
                UsedSpace = "$UsedSpace GB"
                FreeSpace = "$FreeSpace GB"
                PercentUsed = "$PercentUsed %"
                PercentFree = "$PercentFree %"
            }
            $Results = New-Object -TypeName PSObject -Property $param
            $Results | ft
            Get-BarGraph $Results.PercentUsed.Replace('%', '')
        }
    }
}