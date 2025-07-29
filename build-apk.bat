@echo off
REM Kointos Android APK Build Script for Windows
REM This script sets up the environment and builds the Android APK

echo.
echo 🚀 Kointos Android APK Build Script
echo ====================================

REM Set up environment variables
set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
set "ANDROID_HOME=C:\Users\admin\AppData\Local\Android\Sdk"
set "PATH=%PATH%;%ANDROID_HOME%\tools;%ANDROID_HOME%\tools\bin;%ANDROID_HOME%\platform-tools"

echo ✅ Environment variables set:
echo    JAVA_HOME: %JAVA_HOME%
echo    ANDROID_HOME: %ANDROID_HOME%

REM Verify Java installation
echo.
echo 🔍 Checking Java installation...
java -version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Java is properly configured
) else (
    echo ❌ Java configuration issue
    echo Please ensure Android Studio is installed with JDK
    pause
    exit /b 1
)

REM Clean previous builds
echo.
echo 🧹 Cleaning previous builds...
call flutter clean
call flutter pub get

REM Accept Android licenses (if needed)
echo.
echo 📝 Accepting Android licenses...
call flutter doctor --android-licenses

REM Build the APK
echo.
echo 🔨 Building Android APK...
echo This may take several minutes for the first build...

call flutter build apk --release
if %errorlevel% equ 0 (
    echo.
    echo 🎉 APK Build Successful!
    echo.
    echo 📱 APK Location:
    dir build\app\outputs\flutter-apk\
    echo.
    echo ✨ Your Kointos APK is ready at:
    echo    build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo 📋 To install on your device:
    echo    1. Enable 'Developer options' and 'USB debugging' on your Android device
    echo    2. Connect your device via USB
    echo    3. Run: flutter install --release
    echo    OR
    echo    4. Copy the APK file to your device and install manually
) else (
    echo.
    echo ❌ APK Build Failed!
    echo Check the error messages above for details.
    echo.
    echo 🔧 Common fixes:
    echo    1. Ensure Android Studio is properly installed
    echo    2. Check that JAVA_HOME points to a valid JDK
    echo    3. Run 'flutter doctor' to check for issues
    echo    4. Try running 'flutter clean' and rebuild
    pause
    exit /b 1
)

echo.
echo Press any key to exit...
pause >nul
