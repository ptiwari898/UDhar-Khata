$adb = "C:\Users\mypc\AppData\Local\Android\Sdk\platform-tools\adb.exe"
$destDir = "C:\Users\mypc\.gemini\antigravity-ide\brain\eaca8b5d-f907-4d3e-a99d-be6617936c51\.tempmediaStorage"

Write-Host "1. Press Back key twice..."
& $adb -s emulator-5554 shell input keyevent 4
Start-Sleep -Seconds 1
& $adb -s emulator-5554 shell input keyevent 4
Start-Sleep -Seconds 1

Write-Host "2. Tap Customers tab (x=380, y=2320)..."
& $adb -s emulator-5554 shell input tap 380 2320
Start-Sleep -Seconds 1

# Capture Customers Directory
& $adb -s emulator-5554 shell screencap -p /sdcard/cust_dir_ready.png
& $adb -s emulator-5554 pull /sdcard/cust_dir_ready.png (Join-Path $destDir "cust_dir_ready.png")

# Tapping the Sort Dropdown container at top right (x=800, y=165)
Write-Host "3. Tapping Sort Dropdown..."
& $adb -s emulator-5554 shell input tap 800 165
Start-Sleep -Milliseconds 600

# Capture Sort Dropdown opened
& $adb -s emulator-5554 shell screencap -p /sdcard/sort_dropdown_proof_solid.png
& $adb -s emulator-5554 pull /sdcard/sort_dropdown_proof_solid.png (Join-Path $destDir "sort_dropdown_proof_solid.png")

Write-Host "Done!"
