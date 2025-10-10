@echo off
echo ========================================
echo    CHUCK NORRIS JOKES - ANDROID
echo ========================================
echo.
echo Configurando entorno para Android...
cd /d "c:\Users\Alejandro Gutierrez\Documents\GitHub\moviles"

REM Configurar variables temporales para evitar espacios en ruta
set GRADLE_USER_HOME=C:\gradle-temp
set ANDROID_USER_HOME=C:\android-temp

REM Crear directorios temporales si no existen
if not exist "C:\gradle-temp" (
    echo Creando directorio temporal para Gradle...
    mkdir "C:\gradle-temp"
)
if not exist "C:\android-temp" (
    echo Creando directorio temporal para Android...
    mkdir "C:\android-temp"
)

echo.
echo Verificando dispositivos...
flutter devices

echo.
echo Limpiando proyecto...
flutter clean

echo.
echo Obteniendo dependencias...
flutter pub get

echo.
echo Ejecutando Chuck Norris Jokes en emulador Android...
echo (Esto puede tomar unos minutos en la primera ejecucion)
flutter run lib/taller_http/main.dart -d emulator-5554

pause