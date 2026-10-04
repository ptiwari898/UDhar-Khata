$adb = "C:\Users\mypc\AppData\Local\Android\Sdk\platform-tools\adb.exe"
$apk = "E:\ne w project bhai\UDhar-Khata\flutter_app\build\app\outputs\flutter-apk\app-debug.apk"
$destDir = "C:\Users\mypc\.gemini\antigravity-ide\brain\eaca8b5d-f907-4d3e-a99d-be6617936c51\.tempmediaStorage"

Write-Host "1. Installing APK to emulator-5554..."
& $adb -s emulator-5554 install -r $apk

Write-Host "2. Starting MainActivity on Emulator..."
& $adb -s emulator-5554 shell am start -S -n com.aistudio.udhar_khata_flutter/com.aistudio.udhar_khata_flutter.MainActivity
Start-Sleep -Seconds 3

# 1. Capture Dashboard (Screen 4)
Write-Host "3. Capturing Dashboard..."
& $adb -s emulator-5554 shell screencap -p /sdcard/ui_dashboard.png
& $adb -s emulator-5554 pull /sdcard/ui_dashboard.png (Join-Path $destDir "ui_dashboard.png")

# 2. Tap Customers Tab (x=330, y=2320)
Write-Host "4. Capturing Customers Screen (Screen 5)..."
& $adb -s emulator-5554 shell input tap 330 2320
Start-Sleep -Seconds 2
& $adb -s emulator-5554 shell screencap -p /sdcard/ui_customers.png
& $adb -s emulator-5554 pull /sdcard/ui_customers.png (Join-Path $destDir "ui_customers.png")

# 3. Tap First Customer (Ramesh Kumar: x=500, y=400) -> Customer Detail (Screen 7)
Write-Host "5. Capturing Customer Detail (Screen 7)..."
& $adb -s emulator-5554 shell input tap 500 400
Start-Sleep -Seconds 2
& $adb -s emulator-5554 shell screencap -p /sdcard/ui_customer_detail.png
& $adb -s emulator-5554 pull /sdcard/ui_customer_detail.png (Join-Path $destDir "ui_customer_detail.png")

# 4. Tap WhatsApp Button on Customer Detail (x=380, y=260) -> Send Reminder (Screen 13)
Write-Host "6. Capturing WhatsApp Reminder (Screen 13)..."
& $adb -s emulator-5554 shell input tap 380 260
Start-Sleep -Seconds 2
& $adb -s emulator-5554 shell screencap -p /sdcard/ui_whatsapp_reminder.png
& $adb -s emulator-5554 pull /sdcard/ui_whatsapp_reminder.png (Join-Path $destDir "ui_whatsapp_reminder.png")

# Go back
& $adb -s emulator-5554 shell input keyevent 4
Start-Sleep -Seconds 1

# 5. Tap UPI Button on Customer Detail (x=630, y=260) -> UPI Payment (Screen 14)
Write-Host "7. Capturing UPI Payment (Screen 14)..."
& $adb -s emulator-5554 shell input tap 630 260
Start-Sleep -Seconds 2
& $adb -s emulator-5554 shell screencap -p /sdcard/ui_upi_payment.png
& $adb -s emulator-5554 pull /sdcard/ui_upi_payment.png (Join-Path $destDir "ui_upi_payment.png")

# Go back to Customers directory
& $adb -s emulator-5554 shell input keyevent 4
Start-Sleep -Seconds 1
& $adb -s emulator-5554 shell input keyevent 4
Start-Sleep -Seconds 1

# 6. Tap Reports Tab (x=770, y=2320) -> Reports (Screen 11)
Write-Host "8. Capturing Reports Screen (Screen 11)..."
& $adb -s emulator-5554 shell input tap 770 2320
Start-Sleep -Seconds 2
& $adb -s emulator-5554 shell screencap -p /sdcard/ui_reports.png
& $adb -s emulator-5554 pull /sdcard/ui_reports.png (Join-Path $destDir "ui_reports.png")

# 7. Tap Home Tab (x=110, y=2320) -> Tap Voice Entry circle (x=930, y=1030) -> Voice Entry (Screen 9)
Write-Host "9. Capturing Voice Entry Screen (Screen 9)..."
& $adb -s emulator-5554 shell input tap 110 2320
Start-Sleep -Seconds 1
& $adb -s emulator-5554 shell input tap 930 1030
Start-Sleep -Seconds 2
& $adb -s emulator-5554 shell screencap -p /sdcard/ui_voice_entry.png
& $adb -s emulator-5554 pull /sdcard/ui_voice_entry.png (Join-Path $destDir "ui_voice_entry.png")

Write-Host "All UI validations captured successfully!"
