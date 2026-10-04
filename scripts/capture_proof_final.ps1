$adb = "C:\Users\mypc\AppData\Local\Android\Sdk\platform-tools\adb.exe"
$destDir = "C:\Users\mypc\.gemini\antigravity-ide\brain\eaca8b5d-f907-4d3e-a99d-be6617936c51\.tempmediaStorage"

Write-Host "1. Tap Add Udhar button on customer screen (x=260, y=2280)..."
& $adb -s emulator-5554 shell input tap 260 2280
Start-Sleep -Seconds 1

# Capture Add Udhar Modal
& $adb -s emulator-5554 shell screencap -p /sdcard/live_add_udhar_modal.png
& $adb -s emulator-5554 pull /sdcard/live_add_udhar_modal.png (Join-Path $destDir "live_add_udhar_modal.png")

# Dropdown inside Add Udhar modal is at x=500, y=1050
Write-Host "2. Tap Customer Dropdown in modal..."
& $adb -s emulator-5554 shell input tap 500 1050
Start-Sleep -Milliseconds 600

# Capture Customer Dropdown opened with SOLID opaque surface
& $adb -s emulator-5554 shell screencap -p /sdcard/live_customer_dropdown_solid.png
& $adb -s emulator-5554 pull /sdcard/live_customer_dropdown_solid.png (Join-Path $destDir "live_customer_dropdown_solid.png")

# Tap Cancel to dismiss (x=600, y=1500)
& $adb -s emulator-5554 shell input tap 600 1500
Start-Sleep -Seconds 1

# Go Back to Customers Directory (x=70, y=140)
Write-Host "3. Go back to Customers directory..."
& $adb -s emulator-5554 shell input tap 70 140
Start-Sleep -Seconds 1

# Capture Customers Screen
& $adb -s emulator-5554 shell screencap -p /sdcard/live_cust_dir.png
& $adb -s emulator-5554 pull /sdcard/live_cust_dir.png (Join-Path $destDir "live_cust_dir.png")

# Tap Sort button (x=800, y=165)
Write-Host "4. Tap Sort Button (x=800, y=165)..."
& $adb -s emulator-5554 shell input tap 800 165
Start-Sleep -Milliseconds 600

# Capture Sort Menu with SOLID opaque surface
& $adb -s emulator-5554 shell screencap -p /sdcard/live_sort_menu_solid.png
& $adb -s emulator-5554 pull /sdcard/live_sort_menu_solid.png (Join-Path $destDir "live_sort_menu_solid.png")

Write-Host "Finished capturing live proof!"
