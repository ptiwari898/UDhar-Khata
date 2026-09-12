$emulator = "C:\Users\mypc\AppData\Local\Android\Sdk\emulator\emulator.exe"
$adb = "C:\Users\mypc\AppData\Local\Android\Sdk\platform-tools\adb.exe"
$apk = "E:\ne w project bhai\UDhar-Khata\flutter_app\build\app\outputs\flutter-apk\app-release.apk"

Write-Host "Starting Android Emulator (Medium_Phone)..."
Start-Process $emulator -ArgumentList "-avd","Medium_Phone","-gpu","host" -WindowStyle Normal

Write-Host "Waiting for emulator device connection..."
& $adb wait-for-device

Write-Host "Waiting for Android system boot completion..."
$booted = $false
for ($i = 0; $i -lt 30; $i++) {
    $res = (& $adb shell getprop sys.boot_completed)
    if ($res -match "1") {
        $booted = $true
        break
    }
    Start-Sleep -Seconds 2
}

Write-Host "Installing latest Udhar Khata release APK..."
& $adb install -r -d -g $apk

Write-Host "Launching Udhar Khata on Emulator..."
& $adb shell am start -S -n com.aistudio.udhar_khata_flutter/com.aistudio.udhar_khata_flutter.MainActivity

Write-Host "============================================="
Write-Host " Udhar Khata is running on Android Emulator! "
Write-Host "============================================="
