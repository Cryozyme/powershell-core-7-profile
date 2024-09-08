#Path Variables#
$env:Path += ";$env:PROGRAMFILES\PuTTY"
$env:Path += ";$env:PROGRAMFILES\Mozilla Firefox"
$env:Path += ";$env:PROGRAMFILES\NTLite"
$env:Path += ";$env:PROGRAMFILES(x86)\Steam"
$env:Path += ";$env:PROGRAMFILES(x86)\OpenOffice 4\program"
$env:Path += ";$env:PROGRAMFILES(x86)\Adobe\Acrobat Reader DC\Reader"
$env:Path += ";$env:PROGRAMFILES(x86)\Resource Hacker"
$env:Path += ";$env:LOCALAPPDATA\Thorium\Application"
$env:Path += ";$env:PROGRAMFILES\ookla-speedtest-1.2.0-win64"
$env:Path += ";$env:LOCALAPPDATA\Programs\signal-desktop"
$env:Path += ";$env:PROGRAMFILES\SysinternalsSuite"
#Path Variables End#

#Functions#
function shutdown() {

    [CmdletBinding()]
    param(
    
        [String[]]$arguments
    
    )

    try {

        if($null -eq $arguments) {
            
            Write-Verbose -Message "No Arguments Supplied"

            shutdown.exe /?
        
        } elseif($arguments -eq "now") {
            
            Write-Verbose -Message "Shutting Down Immediately"

            shutdown.exe /s /t 0

        } elseif($arguments[0] -eq "/t" -and($arguments[1].ToInt32($null) -is [Int32])) {
            
            Write-Verbose -Message "Shutting Down In $($arguments[1]) Seconds"

            [String[]]$arguments = $arguments.Trim(",")
            shutdown.exe /s $arguments

        } else {
            
            Write-Verbose -Message "Other Arguments Supplied. Passing Straight Through To Shutdown.exe"

            [String[]]$arguments = [String[]]$arguments.Trim(",")
            shutdown.exe $arguments

        }
    
    } catch {

        Write-Debug -Message "$_"

    }

    return

}

function restart() {

    [CmdletBinding()]
    param(
    
        [String[]]$arguments
    
    )

    try {

        if($null -eq $arguments) {
            
            Write-Verbose -Message "No Arguments Supplied"

            shutdown.exe /?
        
        } elseif($arguments -eq "now") {
            
            Write-Verbose -Message "Restarting Immediately"

            shutdown.exe /r /t 0

        } elseif($arguments[0] -eq "/t" -and($arguments[1].ToInt32($null) -is [Int32])) {
            
            Write-Verbose -Message "Restarting In $($arguments[1]) Seconds"

            [String[]]$arguments = $arguments.Trim(",")
            shutdown.exe /r $arguments

        } else {
            
            Write-Verbose -Message "Other Arguments Supplied. Passing Straight Through To Shutdown.exe"

            [String[]]$arguments = [String[]]$arguments.Trim(",")
            shutdown.exe $arguments

        }
    
    } catch {

        Write-Debug -Message "$_"

    }

    return

}

function ytdl() {

    Clear-Host

    [String]$youtube_link = Read-Host "Enter YouTube Video Link"
    [String]$creator_name = Read-Host "Enter the Name of the YouTube Creator"
    [String]$output_path = "$($env:USERPROFILE)\Videos\$($creator_name)\"

    ${yt-dlp_start} = Start-Process -FilePath "yt-dlp.exe" -ArgumentList "$($youtube_link) --audio-multistreams --video-multistreams --format `"bv+ba/b`" -S `"ext,proto`" --paths `"$($output_path)`"" -NoNewWindow -Wait -PassThru

    [String]$run_again = "$(Read-Host -Prompt "Do you want to download another song/album?")"

    if($run_again.ToLower() -eq "yes" -or ($run_again.ToLower() -eq "y")) {

        ytdl

    } else {

        return

    }

    return

}

function spotdl() {

    Clear-Host

    [String]$spotify_link = Read-Host "Enter Spotify Album or Song or Artist Link"
    [String]$album_name = Read-Host "Enter the Name of the Song or Album"
    [String]$artist_name = Read-Host "Enter the Name of the Artist"
    [String]$m3u_original_filepath = "$($env:USERPROFILE)\$($album_name).m3u"
    [String]$output_path = "$($env:USERPROFILE)\Music\$($artist_name)\$($album_name)"
    [String]$m3u_new_filepath = "$($output_path)\$($album_name).m3u"
    
    $spotdl_start = Start-Process -FilePath "spotdl.exe" -ArgumentList "download $($spotify_link) --format flac --bitrate 320k --threads $((Get-WmiObject -class win32_processor -Property NumberOfLogicalProcessors).NumberOfLogicalProcessors) --audio youtube-music youtube soundcloud --preload --max-retries 5 --output `"$($output_path)`" --m3u `"$($album_name).m3u`" --scan-for-songs --overwrite metadata --sponsor-block --add-unavailable --print-errors" -NoNewWindow -Wait -PassThru

    Move-Item -Path "$($m3u_original_filepath)" -Destination "$($m3u_new_filepath)" -Force
    $user_modifies_m3u = Start-Process -FilePath "code.cmd" -ArgumentList "`"$($m3u_new_filepath)`"" -PassThru -WindowStyle Maximized

    [String]$run_again = "$(Read-Host -Prompt "Do you want to download another song/album?")"

    if($run_again.ToLower() -eq "yes" -or ($run_again.ToLower() -eq "y")) {

        spotdl

    } else {

        return

    }

    return
}

function speedtest() {

    [CmdletBinding()]
    param(
    
        [String[]]$arguments
    
    )
    
    try {
        
        if($null -eq $arguments) {

            Write-Verbose -Message "No Arguments Supplied"

            speedtest.exe

        } elseif($arguments -eq "--l") {

            [String]$dateyear = "$(Get-Date -Format "yyyy")"
            [String]$datemonth = "$(Get-Date -Format "MM")"
            [String]$dateday = "$(Get-Date -Format "dd")"
            [String]$date = "$(Get-Date -Format "HH.mm.ss")"
            [String]$folderpath = "$env:USERPROFILE\Documents\speedtests\$dateyear\$datemonth\$dateday"

            Write-Verbose -Message "Long Test Specified. Will Run speedtest.exe Five Times And Output To $($folderpath)"
            
            New-Item -Path "$($folderpath)" -ItemType Directory -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue -ProgressAction SilentlyContinue -Force *> $null
    
            for($i=0; $i -le 4; $i++) {
    
                Start-Process -FilePath "pwsh.exe" -ArgumentList "-NoLogo -Command `"speedtest.exe -P 8 -f human-readable | Out-File -FilePath `"$($folderpath)\speedtest_$date.log`" -Append -Force`"" -NoNewWindow -Wait
    
            }
    
            $down = (Get-Content -Path "$($folderpath)\speedtest_$date.log" -Force | findstr.exe "Download").Trim("`n").Trim(" ")
            $up = (Get-Content -Path "$($folderpath)\speedtest_$date.log" -Force | findstr.exe "Upload").Trim("`n").Trim(" ")
            
            $down | Format-Table
            $up | Format-Table
    
        } else {
            
            Write-Verbose -Message "Other Arguments Supplied. Passing Straight Through To speedtest.exe"

            [String[]]$arguments = [String[]]$arguments.Trim(",")

            speedtest.exe $arguments
    
        }

    } catch {
        
        Write-Debug -Message "$_"

    }

    return

}

function repair {

    try {
    
        Start-Process -FilePath "pwsh.exe" -ArgumentList "-NoLogo -Command `"sfc.exe /verifyonly;sfc.exe /verifyonly;sfc.exe /verifyonly;sfc.exe /scannow;sfc.exe /scannow;sfc.exe /scannow;Dism.exe /Online /Cleanup-Image /CheckHealth;Dism.exe /Online /Cleanup-Image /ScanHealth;Dism.exe /Online /Cleanup-Image /RestoreHealth;chkdsk.exe /F /R /X;restart`"" -Verb RunAs  -WindowStyle Minimized

    } catch [System.InvalidOperationException] {
        
        Write-Output -InputObject "Elevation Request Denied. Cannot Continue!"

    }
    
    return

}

function ssh() {

    [CmdletBinding()]
    param(

        [String[]]$arguments

    )

    [String]$router = "administrator@192.168.50.1"

    try {

        if($null -eq $arguments) {
            
            Write-Verbose -Message "No Arguments Supplied"

            ssh.exe
        
        } elseif($arguments -eq "WhichWayTree") {
            
            Write-Verbose -Message "SSH Into Router: WhichWayTree"

            ssh.exe $router

        } else {
            
            Write-Verbose -Message "Other Arguments Supplied. Passing Straight Through To ssh.exe"

            [String[]]$arguments = [String[]]$arguments.Trim(",")
            ssh.exe $arguments

        }
    
    } catch {

        Write-Debug -Message "$_"

    }

    return

}

function wua() {

    try {

        winget.exe update -u -r -h --force --accept-package-agreements --accept-source-agreements --ignore-security-hash
            
    } catch {

        Write-Debug -Message "$_"

    }

    return

}

function cancel {

    shutdown.exe /a *> $null
    taskkill.exe /IM "speedtest.exe" /T /F *> $null
    taskkill.exe /IM "sfc.exe" /T /F *> $null
    taskkill.exe /IM "Dism.exe" /T /F *> $null
    taskkill.exe /IM "code.exe" /T /F *> $null

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
Set-Alias -Name "router" -Value "ssh"