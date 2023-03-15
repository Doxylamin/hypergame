if (!(Get-WmiObject Win32_VideoController | Where-Object name -like "Parsec Virtual Display Adapter")) {
    (New-Object System.Net.WebClient).DownloadFile("https://ninite.com/.netx7-7zip-chrome-steam/ninite.exe", "C:\Users\$env:USERNAME\Downloads\ninite.exe")
        Start-Process "C:\Users\$env:USERNAME\Downloads\ninite.exe"
}

