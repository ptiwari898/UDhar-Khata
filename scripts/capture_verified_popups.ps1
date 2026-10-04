$adb = "C:\Users\mypc\AppData\Local\Android\Sdk\platform-tools\adb.exe"
$destDir = "C:\Users\mypc\.gemini\antigravity-ide\brain\eaca8b5d-f907-4d3e-a99d-be6617936c51\.tempmediaStorage"

Write-Host "1. Navigating to Customers Tab..."
& $adb -s emulator-5554 shell input tap 380 2320
Start-Sleep -Seconds 1

Write-Host "2. Tapping Sort Dropdown (x=800, y=165)..."
& $adb -s emulator-5554 shell input tap 800 165
Start-Sleep -Milliseconds 800

# Capture Sort Dropdown
& $adb -s emulator-5554 shell screencap -p /sdcard/sort_popup_verified.png
& $adb -s emulator-5554 pull /sdcard/sort_popup_verified.png (Join-Path $destDir "sort_popup_verified.png")

Write-Host "3. Tapping Home Tab..."
& $adb -s emulator-5554 shell input tap 150 2320
Start-Sleep -Seconds 1

Write-Host "4. Tapping Give Udhar (x=270, y=860)..."
& $adb -s emulator-5554 shell input tap 270 860
Start-Sleep -Seconds 1

# Capture Record Entry Screen
& $adb -s emulator-5554 shell screencap -p /sdcard/record_entry_screen.png
& $adb -s emulator-5554 pull /sdcard/record_entry_screen.png (Join-Path $destDir "record_entry_screen.png")

Write-Host "5. Tapping Customer Dropdown on Record Entry Screen (x=500, y=490)..."
& $adb -s emulator-5554 shell input tap 500 490
Start-Sleep -Milliseconds 800

# Capture Customer Dropdown List
& $adb -s emulator-5554 shell screencap -p /sdcard/customer_popup_verified.png
& $adb -s emulator-5554 pull /sdcard/customer_popup_verified.png (Join-Path $destDir "customer_popup_verified.png")

Write-Host "Completed!"
