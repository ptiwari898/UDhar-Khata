$adb = "C:\Users\mypc\AppData\Local\Android\Sdk\platform-tools\adb.exe"
$destDir = "C:\Users\mypc\.gemini\antigravity-ide\brain\eaca8b5d-f907-4d3e-a99d-be6617936c51\.tempmediaStorage"

Write-Host "Restarting App cleanly..."
& $adb -s emulator-5554 shell am force-stop com.aistudio.udhar_khata_flutter
& $adb -s emulator-5554 shell am start -n com.aistudio.udhar_khata_flutter/com.aistudio.udhar_khata_flutter.MainActivity
Start-Sleep -Seconds 3

Write-Host "1. Tap Customers Tab (x=380, y=2320)..."
& $adb -s emulator-5554 shell input tap 380 2320
Start-Sleep -Seconds 2

# Sort Dropdown is located at x=800, y=165 in Customers Tab
Write-Host "2. Tap Sort Dropdown (x=800, y=165)..."
& $adb -s emulator-5554 shell input tap 800 165
Start-Sleep -Milliseconds 600

# Capture Open Sort Menu
& $adb -s emulator-5554 shell screencap -p /sdcard/live_sort_menu_opaque.png
& $adb -s emulator-5554 pull /sdcard/live_sort_menu_opaque.png (Join-Path $destDir "live_sort_menu_opaque.png")

# Tap 'Sort: Name' (x=800, y=360) to close and sort
& $adb -s emulator-5554 shell input tap 800 360
Start-Sleep -Seconds 1

Write-Host "3. Tap FAB 'Add Customer' (x=760, y=2050)..."
& $adb -s emulator-5554 shell input tap 760 2050
Start-Sleep -Seconds 1

# Capture Add Customer Modal
& $adb -s emulator-5554 shell screencap -p /sdcard/live_add_customer_modal.png
& $adb -s emulator-5554 pull /sdcard/live_add_customer_modal.png (Join-Path $destDir "live_add_customer_modal.png")

# Risk Level dropdown is inside Add Customer modal (approx x=750, y=1180)
Write-Host "4. Tap Risk Dropdown (x=750, y=1180)..."
& $adb -s emulator-5554 shell input tap 750 1180
Start-Sleep -Milliseconds 600

# Capture Open Risk Dropdown Menu
& $adb -s emulator-5554 shell screencap -p /sdcard/live_risk_dropdown_opaque.png
& $adb -s emulator-5554 pull /sdcard/live_risk_dropdown_opaque.png (Join-Path $destDir "live_risk_dropdown_opaque.png")

# Dismiss Modal
& $adb -s emulator-5554 shell input tap 300 1600
Start-Sleep -Seconds 1

Write-Host "5. Open Drawer (x=100, y=140)..."
& $adb -s emulator-5554 shell input tap 100 140
Start-Sleep -Seconds 1

# Tap 'Record Entry' in Drawer (x=300, y=600)
Write-Host "6. Tap 'Record Entry' in Drawer..."
& $adb -s emulator-5554 shell input tap 300 600
Start-Sleep -Seconds 2

# Customer Dropdown on Record Entry screen is at x=500, y=480
Write-Host "7. Tap Customer Dropdown on Record Entry (x=500, y=480)..."
& $adb -s emulator-5554 shell input tap 500 480
Start-Sleep -Milliseconds 600

# Capture Customer Dropdown List
& $adb -s emulator-5554 shell screencap -p /sdcard/live_customer_dropdown_opaque.png
& $adb -s emulator-5554 pull /sdcard/live_customer_dropdown_opaque.png (Join-Path $destDir "live_customer_dropdown_opaque.png")

Write-Host "All captures complete!"
