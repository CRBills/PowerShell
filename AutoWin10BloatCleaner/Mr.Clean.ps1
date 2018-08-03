Set-ExecutionPolicy ByPass -scope Process -Force
Write-Host "Give me a go no go for launch..."
Write-Host "Computer Name?..."
$name = Read-Host 'New Computer Name'
Rename-Computer -NewName $name -LocalCredential Administrator
Write-Host "That's a Go Flight." -ForegroundColor Green
Write-Host "User Access Control?.."
New-ItemProperty -Path "HKLM:Software\Microsoft\Windows\CurrentVersion\policies\system" -Name EnableLUA -PropertyType DWord -Value 0 -Force | out-null
Write-Host "Go." -ForegroundColor Green
Write-Host "Firewalls?.."
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
Write-Host "Go." -ForegroundColor Green
Write-Host "Services?..." -nonewline
Stop-service DiagTrack
Stop-service diagnosticshub.standardcollector.service
Stop-service dmwappushservice
Stop-service WMPNetworkSvc
Stop-service WSearch
Stop-service wuauserv | Set-service wuauserv -StartupType disabled
Write-Host "Go." -ForegroundColor Green
Write-Host "Scheduled Tasks?..." -nonewline
& SCHTASKS /Change /DISABLE /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | out-null
& SCHTASKS /Change /DISABLE /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | out-null
& SCHTASKS /Change /DISABLE /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" | out-null
& SCHTASKS /Change /DISABLE /TN "Microsoft\Windows\Application Experience\StartupAppTask" | out-null
& SCHTASKS /Change /DISABLE /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | out-null
& SCHTASKS /Change /DISABLE /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" | out-null
& SCHTASKS /Change /DISABLE /TN "Microsoft\Windows\WindowsUpdate\Scheduled Start" | out-null
& SCHTASKS /Change /DISABLE /TN "Microsoft\Windows\WindowsUpdate\sih" | out-null
Write-Host "Go." -ForegroundColor Green
Write-Host "Telemetry and Data Collection..." -NoNewline
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" -Name PreventDeviceMetadataFromNetwork -PropertyType DWord -Value 1 -Force  | out-null
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name AllowTelemetry -PropertyType DWord -Value 0 -Force  | out-null
New-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\UnattendSettings\SQMClient" -Name CEIPEnable -PropertyType DWord -Value 0 -Force  | out-null
New-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\DataCollection" -Name AllowTelemetry -PropertyType DWord -Value 0 -Force  | out-null
New-ItemProperty -Path "HKLM:\SYSTEM\ControlSet001\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" -Name Start -PropertyType DWord -Value 0 -Force  | out-null
New-ItemProperty -Path "HKLM:\SYSTEM\ControlSet001\Control\WMI\Autologger\SQMLogger" -Name Start -PropertyType DWord -Value 0 -Force  | out-null
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Start_TrackDocs -PropertyType DWord -Value 0 -Force  | out-null
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name SystemPaneSuggestionsEnabled -PropertyType DWord -Value 0 -Force  | out-null
Write-Host "Go." -ForegroundColor Green
Write-Host "Apps?..." -NoNewline
Get-AppxPackage *3DBuilder* | Remove-AppxPackage  | out-null
Get-AppxPackage *Getstarted* | Remove-AppxPackage  | out-null
Get-AppxPackage *WindowsAlarms* | Remove-AppxPackage  | out-null
Get-AppxPackage *WindowsCamera* | Remove-AppxPackage  | out-null
Get-AppxPackage *bing* | Remove-AppxPackage  | out-null
Get-AppxPackage *MicrosoftOfficeHub* | Remove-AppxPackage  | out-null
Get-AppxPackage *OneNote* | Remove-AppxPackage  | out-null
Get-AppxPackage *WindowsPhone* | Remove-AppxPackage  | out-null
Get-AppxPackage *photos* | Remove-AppxPackage  | out-null
Get-AppxPackage *SkypeApp* | Remove-AppxPackage  | out-null
Get-AppxPackage *solit* | Remove-AppxPackage  | out-null
Get-AppxPackage *WindowsSoundRecorder* | Remove-AppxPackage  | out-null
Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage  | out-null
Get-AppxPackage *zune* | Remove-AppxPackage  | out-null
Get-AppxPackage *Sway* | Remove-AppxPackage  | out-null
Get-AppxPackage *CommsPhone* | Remove-AppxPackage  | out-null
Get-AppxPackage *ConnectivityStore* | Remove-AppxPackage  | out-null
Get-AppxPackage *Microsoft.Messaging* | Remove-AppxPackage  | out-null
Get-AppxPackage *Microsoft.WindowsStore* | Remove-AppxPackage  | out-null
Get-AppxPackage *DisneyMagicKingdoms* | Remove-AppxPackage  | out-null
Get-AppxPackage *Minecraft* | Remove-AppxPackage  | out-null
Get-AppxPackage *City* | Remove-AppxPackage  | out-null
Get-AppxPackage *Candy* | Remove-AppxPackage  | out-null
Get-AppxPackage *xboxapp* | Remove-AppxPackage  | out-null
Get-AppxPackage *Cooking* | Remove-AppxPackage  | out-null
Get-AppxPackage *Bubble* | Remove-AppxPackage | out-null
Get-AppxPackage *Dragon* | Remove-AppxPackage | out-null
Write-Host "Go." -ForegroundColor Green
Write-Host "Power?..." -NoNewline
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c  | out-null
powercfg /change disk-timeout-ac 0  | out-null
powercfg /change standby-timeout-ac 0  | out-null
powercfg /change hibernate-timeout-ac 0  | out-null
powercfg /change monitor-timeout-ac 0  | out-null
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name HiberbootEnabled -PropertyType DWord -Value 0 -Force  | out-null
Write-Host "Go." -ForegroundColor Green
Write-Host "GPO?.." -NoNewLine
$USBDRIVE = Get-WmiObject Win32_Volume -Filter "DriveType='2'" | Select-Object -expand driveletter
Copy-Item -path $USBDRIVE\GPO\* -Destination C:\Windows\System32\GroupPolicy\ -recurse -force
cmd.exe /c "GpUpdate /Force"
Write-Host "Go." -ForegroundColor Green
Write-Host "Network?..." -NoNewline
$network = Get-WmiObject -class win32_networkadapter -filter "NetConnectionStatus = 2" | Get-NetAdapter | select-object -ExpandProperty Name
Get-NetAdapter -Name $network | Rename-NetAdapter -NewName Network
Write-Host "Go." -ForegroundColor Green
Write-Host "One Drive?..."
Start-Process $USBDRIVE\OneDrive.bat -Verb runAs
Write-Host "Go." -ForegroundColor Green
Write-Host "Houston we are Go for launch."
cmd /c Pause
Restart-Computer

