ECHO "#########################"
ECHO "#                       #"
ECHO "#   Format media tool   #"
ECHO "#   By Will Thornton    #"
ECHO "#   Version: 1.3        #"
ECHO "#                       #"
ECHO "#########################"
ECHO " "

$dl     #disk number
$disklist
$gettype
$type      #mbr or gpt
$cont      #continue selection
$cont1
$quit = "n"
$stop
$disks = @()
$disknumbers = @()
$letter = @()
$errormsg = "Invalid selection, try again."

do{
    #List current connected HHD
    ECHO "List of connected USB media"
    ECHO " " 
    Get-Disk | ForEach-Object{
        $disks += $_
    }

    for($i=0; $i -lt $disks.length; $i++){
        
        if($disks[$i].Number -ne 0){
            #Write-Host $_.Number "|" $_.FriendlyName "|" ($_.Size/1GB).ToString().Substring(0,4) GB
            $disks[$i] | Format-Table -GroupBy Number -AutoSize
        }
                elseif($disks.length -eq 1){
                ECHO "No media found. Please connect media and rerun."
                ECHO " "
                pause
                exit
            }
    }
    ECHO " "

    do{
        $dl = Read-Host "Enter selection"
        #user entry validation
        try{
            if($dl -eq ''){
                $dl = $null
            }

            elseif($dl -eq 0){
                $dl = $null
            }

            $disklist = Get-Disk -Number $dl -ErrorAction Stop

        }

        catch{
            ECHO "Choose a valid disk number"
            ECHO $disklist.DiskNumber
        }
    }

    #end do loop when valid disk number is selected
    until((($disklist.DiskNumber -eq $dl) -and ($disklist.DiskNumber -ne $null) -and ($disklist.DiskNumber -ne 0)))
    ECHO "You will format disk $dl."

    do{ 
    #continue user choice
    $cont = Read-Host "Want to continue? y/n"
    ECHO " "

    if(($cont -eq "y")){
         do{
             Write-Host "[1] NTFS (Legacy BIOS)`n`n[2] FAT32 (UEFI BIOS and EFBs)"
            $option = Read-Host "Select option from above"
            if($option -eq 1){
                $format = "NTFS"
            }
            elseif($option -eq 2){
                $format = "FAT32"
            }
            else{
                ECHO $errormsg
            }
        }
        until((($option -eq 1) -or ($option -eq 2)))

         do{
            $gettype = Read-Host "Press the letter 'f' and press ENTER to begin formatting"

            if(($gettype -eq "f")){
                $type = "mbr"
            }
            #elseif(($gettype -eq "gpt") -or ($gettype -eq "g")){
            #    $type = "gpt"
            #}
            else{
                ECHO $errormsg
            }
        }
        until((($gettype -eq "f") -or ($gettype -eq "m")))

        #array of diskpart commands 
        $myFile = @(
            "select disk $dl",
            "attributes disk clear readonly",
            "clean", 
            "convert $type",
            "create partition pri",
            "select part 1",
            "active",
            "format fs=$format label='BootMedia' quick",
            "assign",
            "list volume"
            ) | Out-File -FilePath script.txt #sends commands to script.txt
        
        $script = Get-Content script.txt

        ECHO $script | diskpart.exe > output.txt

        #output results of diskpart
        Get-Content output.txt

        ECHO "Disk $dl was formtatted successfully."

        #breaks loop
        $cont = "break"
    }
    elseif($cont -eq "n"){
        ECHO "Exiting..."
        exit
    }
    else{
        ECHO $errormsg
        $cont = "break"
    }

    }
    while($cont -ne "break")

    do{
        $cont1 = Read-Host "Choose 'y' to copy media to drive or 'n' format another drive or 'x' to exit." 

        if($cont1 -eq 'x'){
            ECHO "Exiting..."
            exit
        }
        elseif($cont1 -eq 'y'){
            $quit1 = "n"
            $quit = "y"
        }
   
        elseif($cont1 -eq 'n'){
            $quit1 = "n"
            ECHO "Remove current media and insert another media stick and press enter to continue."
            pause
            ECHO "Restarting..."
        }
        elseif(($cont1 -ne 'y') -or ($cont1 -ne 'n') -or ($cont1 -ne 'x')){
            $quit1 = "y"
            ECHO $errormsg
        }
    }
    while(($quit1 -eq "y") -and (($cont1 -ne 'y') -or ($cont1 -ne 'n') -or ($cont1 -ne 'x')))
}
#end main loop/program
while($quit -eq "n")

#starts OS file copy to media
do{
    cls

    if($cont1 -eq "y"){
        ECHO "-----------------------------------------------------------------"
        ECHO "| WORK IN PROGRESS! Use carefully!                              |"
        ECHO "-----------------------------------------------------------------"
        ECHO "Currently attached media sticks:"
        (GET-WMIOBJECT -query "SELECT * from win32_logicaldisk") | % {$i = 0} {if($_.VolumeName -eq "BootMedia"){$letter += $_.DeviceID; Write-Host -nonewline ($i+1)")", $letter[$i]; $i++}}

        ECHO " "

        try{
            do{
                $diskentry = Read-Host "Select a numbered option"

                if((($diskentry -eq 0) -or ($diskentry -eq ''))){
                    $diskentry = $null
                    ECHO $errormsg
                    $check = 0
                }
                else{
                    if($letter.Contains($letter[$diskentry-1])){
                        $FormatDisk = $letter[$diskentry-1]
                        $check = 1
                    }
                    else{
                        ECHO $errormsg
                        $check = 0
                    }
                }


            }
            while($check -eq 0)
            #Display Options
            ECHO " "
            ECHO "-------------------------------"
            ECHO "1 - Option"
            ECHO "2 - Option"
            ECHO "3 - Option"
            ECHO "4 - Option"
            ECHO "5 - Optiont"
            ECHO "6 - Option"
            ECHO "-------------------------------"
            ECHO " "
        

            do{
                $selection = Read-Host "Select an OS"
                ECHO $selection
                $os= @("1","2","3","4","5","6")
                if($os.Contains($selection)){
                    $check2 = 1
                    switch($selection){
                        #change string to OS locations
                        1 {robocopy "\\path to files" $FormatDisk /MIR}
                        2 {robocopy "\\path to files" $FormatDisk /MIR}
                        3 {robocopy "\\path to files" $FormatDisk /MIR}
                        4 {robocopy "\\path to files" $FormatDisk /MIR}
                        5 {robocopy "\\path to files" $FormatDisk /MIR}
                        6 {robocopy "\\path to files" $FormatDisk /MIR}
                    }

                    pause
        
                    exit
                }
                else{
                    ECHO $errormsg
                    $check2 = 0
                }
            }
            while($check2 -eq 0)
        }
        catch{ 
            ECHO $errormsg 
        }

    }
    elseif($cont1 -eq "n"){
        ECHO "Exiting..."
        exit
    }
    else{
        ECHO $errormsg
    }
    pause
}
while(($cont1 -ne "y") -or ($cont1 -ne "n"))
#done