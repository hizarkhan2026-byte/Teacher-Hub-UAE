@echo off
title Build Teacher Hub UAE for Android
cd /d "%~dp0"
where node >nul 2>nul
if errorlevel 1 (
  echo Node.js is missing. Installing it...
  winget install -e --id OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements
  echo Close this window and double-click build.bat again.
  pause & exit /b
)
if not defined JAVA_HOME if exist "C:\Program Files\Android\Android Studio\jbr" set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
if not defined ANDROID_HOME if exist "%LOCALAPPDATA%\Android\Sdk" set "ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk"
if not defined JAVA_HOME (
  echo Android Studio was not found. Install it from https://developer.android.com/studio
  echo Open it once so it downloads the Android SDK, then run build.bat again.
  pause & exit /b
)
call npm install || goto fail
if not exist android call npx cap add android || goto fail
call npx capacitor-assets generate --android || goto fail
call npx cap sync android || goto fail
echo sdk.dir=%ANDROID_HOME:\=/%> android\local.properties
cd android
call gradlew.bat assembleDebug || goto fail
cd ..
echo.
echo Done! Your APK is here:
echo %~dp0android\app\build\outputs\apk\debug\app-debug.apk
start "" "%~dp0android\app\build\outputs\apk\debug"
pause & exit /b
:fail
echo.
echo Something went wrong. Take a photo of this window and send it to me.
pause
