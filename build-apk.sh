#!/bin/bash

# Kointos Android APK Build Script
# This script sets up the environment and builds the Android APK

echo "🚀 Kointos Android APK Build Script"
echo "===================================="

# Set up environment variables
export JAVA_HOME="/c/Program Files/Android/Android Studio/jbr"
export ANDROID_HOME="/c/Users/admin/AppData/Local/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"

echo "✅ Environment variables set:"
echo "   JAVA_HOME: $JAVA_HOME"
echo "   ANDROID_HOME: $ANDROID_HOME"

# Verify Java installation
echo ""
echo "🔍 Checking Java installation..."
if java -version 2>&1 | grep -q "openjdk version"; then
    echo "✅ Java is properly configured"
else
    echo "❌ Java configuration issue"
    echo "Please ensure Android Studio is installed with JDK"
    exit 1
fi

# Clean previous builds
echo ""
echo "🧹 Cleaning previous builds..."
flutter clean
flutter pub get

# Accept Android licenses (if needed)
echo ""
echo "📝 Accepting Android licenses..."
flutter doctor --android-licenses || true

# Build the APK
echo ""
echo "🔨 Building Android APK..."
echo "This may take several minutes for the first build..."

if flutter build apk --release; then
    echo ""
    echo "🎉 APK Build Successful!"
    echo ""
    echo "📱 APK Location:"
    ls -la build/app/outputs/flutter-apk/
    echo ""
    echo "✨ Your Kointos APK is ready at:"
    echo "   build/app/outputs/flutter-apk/app-release.apk"
    echo ""
    echo "🔧 APK Details:"
    du -h build/app/outputs/flutter-apk/app-release.apk
    echo ""
    echo "📋 To install on your device:"
    echo "   1. Enable 'Developer options' and 'USB debugging' on your Android device"
    echo "   2. Connect your device via USB"
    echo "   3. Run: flutter install --release"
    echo "   OR"
    echo "   4. Copy the APK file to your device and install manually"
else
    echo ""
    echo "❌ APK Build Failed!"
    echo "Check the error messages above for details."
    echo ""
    echo "🔧 Common fixes:"
    echo "   1. Ensure Android Studio is properly installed"
    echo "   2. Check that JAVA_HOME points to a valid JDK"
    echo "   3. Run 'flutter doctor' to check for issues"
    echo "   4. Try running 'flutter clean' and rebuild"
    exit 1
fi
