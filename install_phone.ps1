$adb = "C:\Users\mypc\AppData\Local\Android\Sdk\platform-tools\adb.exe"
$apk = "E:\ne w project bhai\UDhar-Khata\flutter_app\build\app\outputs\flutter-apk\app-debug.apk"

Write-Host "Listing connected devices:"
& $adb devices -l

$devices = & $adb devices | Select-String -Pattern "device$" | ForEach-Object { ($_ -split "`t")[0] }

Write-Host "Found devices: $($devices -join ', ')"

foreach ($dev in $devices) {
    Write-Host "Installing APK onto device: $dev ..."
    & $adb -s $dev install -r $apk
    Write-Host "Starting MainActivity on device: $dev ..."
    & $adb -s $dev shell am start -n com.aistudio.udhar_khata_flutter/com.aistudio.udhar_khata_flutter.MainActivity
}
Write-Host "All installations completed!"
