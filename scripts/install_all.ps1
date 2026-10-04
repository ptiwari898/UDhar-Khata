$adb = "C:\Users\mypc\AppData\Local\Android\Sdk\platform-tools\adb.exe"
$releaseApk = "E:\ne w project bhai\UDhar-Khata\flutter_app\build\app\outputs\flutter-apk\app-release.apk"
$debugApk = "E:\ne w project bhai\UDhar-Khata\flutter_app\build\app\outputs\flutter-apk\app-debug.apk"

$apkToInstall = if (Test-Path $releaseApk) { $releaseApk } else { $debugApk }

Write-Host "=================================================="
Write-Host "  UDHAR KHATA - 1-CLICK PHONE INSTALLER (PAWAN)   "
Write-Host "=================================================="
Write-Host "APK Source: $apkToInstall"

$lines = & $adb devices
$count = 0

foreach ($line in $lines) {
    if ($line -match "^([^\s]+)\s+device$") {
        $devId = $matches[1]
        $count++
        Write-Host "--------------------------------------------------"
        Write-Host "[$count] Installing Udhar Khata on device: $devId ..."
        & $adb -s $devId install -r -d -g $apkToInstall
        Write-Host "Launching app on $devId ..."
        & $adb -s $devId shell am start -S -n com.aistudio.udhar_khata_flutter/com.aistudio.udhar_khata_flutter.MainActivity
        Write-Host "Successfully installed and running on $devId!"
    }
}

if ($count -eq 0) {
    Write-Host "No device found yet! Please connect your phone with USB Debugging enabled and run again."
} else {
    Write-Host "=================================================="
    Write-Host "ALL DONE! Udhar Khata is live on your phone."
    Write-Host "=================================================="
}
