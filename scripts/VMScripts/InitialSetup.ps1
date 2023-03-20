Function DownloadFile {
    param (
        [string]$Url,
        [string]$FileName,
        [bool]$RunAfterDownload
    )

    (New-Object System.Net.WebClient).DownloadFile($Url, "C:\Users\$env:USERNAME\Downloads\$fileName")
    if ($runAfterDownload -eq $true) {
        Start-Process "C:\Users\$env:USERNAME\Downloads\$fileName" -Wait
    }
}


if (!(Test-Path C:\ProgramData\HyperGame\completed.setup)) {
    Write-Host "Installing Ninite (.NET 7, Chrome, 7-ZIP, Steam)"
    DownloadFile -Url "https://ninite.com/.netx7-7zip-chrome-steam/ninite.exe" -FileName "ninite.exe" -RunAfterDownload $true

    $wireshark = Read-Host "Would you like to install WireShark? (y/N)"
    Switch ($wireshark) {
        Y {
            Write-Host "Downloading and Installing WireShark..."
            DownloadFile -Url "https://2.na.dl.wireshark.org/win64/Wireshark-win64-4.0.4.exe" -FileName "Wireshark-win64.exe" -RunAfterDownload $true
        }
        N {}
        default {}
    }
}

