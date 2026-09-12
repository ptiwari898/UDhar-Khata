$adb = "C:\Users\mypc\AppData\Local\Android\Sdk\platform-tools\adb.exe"
$destDir = "C:\Users\mypc\.gemini\antigravity-ide\brain\eaca8b5d-f907-4d3e-a99d-be6617936c51\.tempmediaStorage"

Write-Host "1. Tap Customers tab (x=380, y=2320)..."
& $adb -s emulator-5554 shell input tap 380 2320
Start-Sleep -Seconds 2

# Capture Customers directory
& $adb -s emulator-5554 shell screencap -p /sdcard/step1_customers.png
& $adb -s emulator-5554 pull /sdcard/step1_customers.png (Join-Path $destDir "step1_customers.png")

Write-Host "2. Tap Sort dropdown button (top right: x=880, y=240)..."
& $adb -s emulator-5554 shell input tap 880 240
Start-Sleep -Seconds 1

# Capture open sort dropdown menu
& $adb -s emulator-5554 shell screencap -p /sdcard/step2_sort_menu.png
& $adb -s emulator-5554 pull /sdcard/step2_sort_menu.png (Join-Path $destDir "step2_sort_menu.png")

# Tap 'Sort: Low Udhar' (x=880, y=360)
& $adb -s emulator-5554 shell input tap 880 360
Start-Sleep -Seconds 1

Write-Host "3. Tap Give Udhar on Ramesh General Store (or FAB Add Udhar)..."
# In Customers tab, tap Give Udhar button on 1st card (approx x=300, y=660)
& $adb -s emulator-5554 shell input tap 300 660
Start-Sleep -Seconds 1

# Capture Add Udhar Modal
& $adb -s emulator-5554 shell screencap -p /sdcard/step3_add_udhar_modal.png
& $adb -s emulator-5554 pull /sdcard/step3_add_udhar_modal.png (Join-Path $destDir "step3_add_udhar_modal.png")

Write-Host "4. Tap Customer dropdown in Add Udhar modal (approx x=500, y=1030)..."
& $adb -s emulator-5554 shell input tap 500 1030
Start-Sleep -Seconds 1

# Capture open customer dropdown list
& $adb -s emulator-5554 shell screencap -p /sdcard/step4_customer_dropdown_list.png
& $adb -s emulator-5554 pull /sdcard/step4_customer_dropdown_list.png (Join-Path $destDir "step4_customer_dropdown_list.png")

Write-Host "Verification capture complete!"
