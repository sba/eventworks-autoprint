# Script to autoprint badges downloaded by firefox
# July 2021, © Stefan Bauer / databauer


# define envroinment
$pdfdir="C:\Users\Stefan\Downloads\"
$pdfdirprinted="C:\Users\Stefan\Downloads\printed\" 
$pdfprefix = "EuropeanAthleticsIndoorChampionships2023_0_" #only print accr pdf files
$downloading = 0

function Get-TimeStamp {
    return "[{0:dd/MM/yy} {0:HH:mm:ss}]" -f (Get-Date)
} 

# infinite loop
while(1){
    # firefox produces .part file when downloading -> dont start printing if exists
    Get-ChildItem "$pdfdir*$pdfprefix*.part" | Foreach-Object { 
        $downloading = 1
    }

    if(!$downloading){
        Get-ChildItem "$pdfdir*$pdfprefix*.pdf" | Foreach-Object { 
            Write-Host $(Get-TimeStamp) -NoNewline
            Write-Host " " -NoNewline
            Write-Host $_.Name -ForegroundColor green -NoNewline
            
            # print with standard printer/settings
            Start-Process -FilePath $_.FullName –Verb Print 

            # give some time to print... increase for printing of very large file or stop script before printing
            $sec_pause = 10
            For ($i=0; $i -le $sec_pause; $i++) {
                Start-Sleep -s 1 
                Write-Host "." -NoNewline
            }

            # move printed file
            $backupfile = $pdfdirprinted + $_.Name
            Move-Item -Path $_.FullName -Destination $backupfile
            Write-Host " => moved"  -ForegroundColor yellow
        }
    }
    $downloading = 0
    
    # slow scan rate is sufficient
    Start-Sleep -s 1
}

