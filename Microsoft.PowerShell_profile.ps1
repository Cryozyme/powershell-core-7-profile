#Path Variables#
$env:Path += ";$env:PROGRAMFILES\PuTTY"
$env:Path += ";$env:PROGRAMFILES\Mozilla Firefox"
$env:Path += ";$env:PROGRAMFILES\NTLite"
$env:Path += ";$env:PROGRAMFILES(x86)\Steam"
$env:Path += ";$env:PROGRAMFILES(x86)\OpenOffice 4\program"
$env:Path += ";$env:PROGRAMFILES(x86)\Adobe\Acrobat Reader DC\Reader"
$env:Path += ";$env:PROGRAMFILES(x86)\Resource Hacker"
$env:Path += ";$env:PROGRAMFILES\Google\Chrome\Application"
$env:Path += ";$env:PROGRAMFILES\ookla-speedtest-1.2.0-win64"
$env:Path += ";$env:PROGRAMFILES(x86)\GnuWin32\bin"
$env:Path += ";$env:LOCALAPPDATA\Programs\signal-desktop"
$env:Path += ";$env:PROGRAMFILES\SysinternalsSuite"
#Path Variables End#

#Functions#
function shutdown([String]$argument0, [String]$argument1, [String]$argument2, [String]$argument3, [String]$argument4, [String]$argument5, [String]$argument6, [String]$argument7, [String]$argument8, [String]$argument9) {

    [String[]]$arguments=$argument0, $argument1, $argument2, $argument3, $argument4, $argument5, $argument6, $argument7, $argument8, $argument9
    
    $arguments.ForEach(

        {

            $i=0

            if($null -eq $arguments[$i]) {
                
                $i++
                $arguments[$i]=$arguments[$i].Replace($null, "")

            } else {

                $i++
                $arguments[$i]=$arguments[$i].Trim("`n").Trim(" ").ToLower()

            }

        }

    )

    if($arguments -eq "now") {

        shutdown.exe /s /t 0

    } elseif($arguments[0] -eq "/t" -and($arguments[1].ToInt32($null) -is [Int32])) {

        shutdown.exe /s /t $arguments[1]

    } elseif($arguments -eq "/a") {

        shutdown.exe /a

    } else {

        shutdown.exe $arguments[0] $arguments[1] $arguments[2] $arguments[3] $arguments[4] $arguments[5] $arguments[6] $arguments[7] $arguments[8] $arguments[9]

    }

    return

}

function restart([String]$argument0, [String]$argument1, [String]$argument2, [String]$argument3, [String]$argument4, [String]$argument5, [String]$argument6, [String]$argument7, [String]$argument8, [String]$argument9) {

    [String[]]$arguments=$argument0, $argument1, $argument2, $argument3, $argument4, $argument5, $argument6, $argument7, $argument8, $argument9
    
    $arguments.ForEach(

        {

            $i=0

            if($null -eq $arguments[$i]) {
                
                $i++
                $arguments[$i]=$arguments[$i].Replace($null, "")

            } else {

                $i++
                $arguments[$i]=$arguments[$i].Trim("`n").Trim(" ").ToLower()

            }

        }

    )

    if($arguments -eq "now") {

        shutdown.exe /r /t 0

    } elseif($arguments[0] -eq "/t" -and($arguments[1].ToInt32($null) -is [Int32])) {

        shutdown.exe /r /t $arguments[1]

    } elseif($arguments -eq "/a") {

        shutdown.exe /a

    } else {

        shutdown.exe $arguments[0] $arguments[1] $arguments[2] $arguments[3] $arguments[4] $arguments[5] $arguments[6] $arguments[7] $arguments[8] $arguments[9]

    }

    return

}

function cancel {

    shutdown.exe /a *> $null
    taskkill.exe /IM "speedtest.exe" /T /F *> $null
    taskkill.exe /IM "sfc.exe" /T /F *> $null
    taskkill.exe /IM "Dism.exe" /T /F *> $null
    
    return

}

function speedtest([String]$argument0, [String]$argument1, [String]$argument2, [String]$argument3, [String]$argument4, [String]$argument5, [String]$argument6, [String]$argument7, [String]$argument8) {

    [String[]]$arguments=$argument0, $argument1, $argument2, $argument3, $argument4, $argument5, $argument6, $argument7, $argument8

    $arguments.ForEach(

        {

            $i=0

            if($null -eq $arguments[$i]) {
                
                $i++
                $arguments[$i]=$arguments[$i].Replace($null, "")

            } else {

                $i++
                $arguments[$i]=$arguments[$i].Trim("`n").Trim(" ").ToLower()

            }

        }

    )

    if($arguments -eq "--l") {

        $dateyear=Get-Date -Format "yyyy"
        $datemonth=Get-Date -Format "MM"
        $dateday=Get-Date -Format "dd"
        $date=Get-Date -Format "HH.mm.ss"
        
        New-Item -Path "$env:USERPROFILE\Documents\speedtests\$dateyear\$datemonth\$dateday" -ItemType Directory -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue -ProgressAction SilentlyContinue -Force *> $null

        for($i=0; $i -le 4; $i++) {

            Start-Process -FilePath "pwsh.exe" -ArgumentList "-NoLogo -Command `"speedtest.exe -P 8 -f human-readable | Out-File -FilePath `"$env:USERPROFILE\Documents\speedtests\$dateyear\$datemonth\$dateday\speedtest_$date.log`" -Append -Force`"" -NoNewWindow -Wait

        }

        $down=(Get-Content -Path "$env:USERPROFILE\Documents\speedtests\$dateyear\$datemonth\$dateday\speedtest_$date.log" -Force | findstr.exe "Download").Trim("`n").Trim(" ")
        $up=(Get-Content -Path "$env:USERPROFILE\Documents\speedtests\$dateyear\$datemonth\$dateday\speedtest_$date.log" -Force | findstr.exe "Upload").Trim("`n").Trim(" ")
        
        $down | Format-Table
        $up | Format-Table

    } else {

        speedtest.exe $arguments[0] $arguments[1] $arguments[2] $arguments[3] $arguments[4] $arguments[5] $arguments[6] $arguments[7] $arguments[8]

    }

    return

}

function repair {

    try {
    
        Start-Process -FilePath "pwsh.exe" -ArgumentList "-NoLogo -Command `"sfc.exe /verifyonly;sfc.exe /verifyonly;sfc.exe /verifyonly;sfc.exe /scannow;sfc.exe /scannow;sfc.exe /scannow;Dism.exe /Online /Cleanup-Image /CheckHealth;Dism.exe /Online /Cleanup-Image /ScanHealth;Dism.exe /Online /Cleanup-Image /RestoreHealth`"" -Verb RunAs  -WindowStyle Minimized

    } catch [System.InvalidOperationException] {
        
        Write-Output -InputObject "Elevation Request Denied. Cannot Continue!"

    }
    
    return

}

#Aliases
Set-Alias -Name "reboot" -Value "restart"
Set-Alias -Name "reboot-cancel" -Value "cancel"
Set-Alias -Name "restart-cancel" -Value "cancel"
Set-Alias -Name "shutdown-cancel" -Value "cancel"
Set-Alias -Name "whereis" -Value "where.exe"
Set-Alias -Name "repairme" -Value "repair"
Set-Alias -Name "windowsrepair" -Value "repair"
Set-Alias -Name "fast.com" -Value "speedtest"
Set-Alias -Name "speedtest.net" -Value "speedtest"