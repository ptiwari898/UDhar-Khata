$adb = "C:\Users\mypc\AppData\Local\Android\Sdk\platform-tools\adb.exe"
$apk = "E:\ne w project bhai\UDhar-Khata\flutter_app\build\app\outputs\flutter-apk\app-debug.apk"
$destDir = "C:\Users\mypc\.gemini\antigravity-ide\brain\eaca8b5d-f907-4d3e-a99d-be6617936c51\.tempmediaStorage"

Write-Host "1. Installing APK to emulator-5554..."
& $adb -s emulator-5554 install -r $apk

Write-Host "2. Starting MainActivity..."
& $adb -s emulator-5554 shell am start -S -n com.aistudio.udhar_khata_flutter/com.aistudio.udhar_khata_flutter.MainActivity
Start-Sleep -Seconds 3

Write-Host "3. Navigating to Customers Tab..."
# Customers tab is 2nd destination at bottom
& $adb -s emulator-5554 shell input tap 380 2260
Start-Sleep -Seconds 2

# Capture Customers Screen
& $adb -s emulator-5554 shell screencap -p /sdcard/fixed_cust_screen.png
& $adb -s emulator-5554 pull /sdcard/fixed_cust_screen.png (Join-Path $destDir "fixed_cust_screen.png")

Write-Host "4. Tapping Sort Dropdown (approx x=900, y=140)..."
& $adb -s emulator-5554 shell input tap 900 140
Start-Sleep -Seconds 1
& $adb -s emulator-5554 shell screencap -p /sdcard/fixed_sort_dropdown.png
& $adb -s emulator-5554 pull /sdcard/fixed_sort_dropdown.png (Join-Path $destDir "fixed_sort_dropdown.png")

# Tap outside to dismiss sort dropdown
& $adb -s emulator-5554 shell input tap 500 500
Start-Sleep -Seconds 1

Write-Host "5. Opening Orders Tab..."
& $adb -s emulator-5554 shell input tap 680 2260
Start-Sleep -Seconds 1

Write-Host "6. Opening Create Order Modal (FAB)..."
& $adb -s emulator-5554 shell input tap 850 2180
Start-Sleep -Seconds 1

Write-Host "7. Tapping Customer Dropdown inside modal..."
& $adb -s emulator-5554 shell input tap 500 1030
Start-Sleep -Seconds 1
& $adb -s emulator-5554 shell screencap -p /sdcard/fixed_customer_picker.png
& $adb -s emulator-5554 pull /sdcard/fixed_customer_picker.png (Join-Path $destDir "fixed_customer_picker.png")

Write-Host "Done verifying dropdowns!"
