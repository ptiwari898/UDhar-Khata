@echo off
title Udhar Khata - Launch Android Emulator
echo ===================================================
echo     LAUNCHING VISIBLE ANDROID EMULATOR (GUI)      
echo ===================================================

set EMULATOR=C:\Users\mypc\AppData\Local\Android\Sdk\emulator\emulator.exe
set ADB=C:\Users\mypc\AppData\Local\Android\Sdk\platform-tools\adb.exe

echo Starting Android Emulator window...
start "" "%EMULATOR%" -avd Medium_Phone -gpu host

echo Waiting for emulator to boot up...
"%ADB%" wait-for-device

echo Emulator ready! Starting Udhar Khata app...
"%ADB%" shell am start -S -n com.aistudio.udhar_khata_flutter/com.aistudio.udhar_khata_flutter.MainActivity

echo ===================================================
echo   EMULATOR WINDOW IS NOW VISIBLE ON YOUR SCREEN!  
echo ===================================================
timeout /t 5
