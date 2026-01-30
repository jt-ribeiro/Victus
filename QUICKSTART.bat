@echo off
echo ========================================
echo   VICTUS - Quick Start Script
echo ========================================
echo.

REM Check if Node.js is installed
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Node.js nao encontrado!
    echo Por favor instala o Node.js: https://nodejs.org/
    pause
    exit /b 1
)

REM Check if MySQL is running
echo [1/5] A verificar MySQL...
netstat -an | findstr "3306" >nul
if %ERRORLEVEL% NEQ 0 (
    echo [AVISO] MySQL pode nao estar a correr na porta 3306
    echo Certifica-te que o MySQL esta iniciado
)

REM Check if database is configured
echo [2/5] A verificar configuracao da base de dados...
if not exist "server\.env" (
    echo [AVISO] Ficheiro .env nao encontrado!
    echo Por favor configura o server/.env com as tuas credenciais MySQL
    pause
)

REM Install backend dependencies (if needed)
echo [3/5] A verificar dependencias do backend...
if not exist "server\node_modules" (
    echo A instalar dependencias...
    cd server
    call npm install
    cd ..
)

REM Start the backend server
echo [4/5] A iniciar servidor backend...
start "Victus Backend Server" cmd /k "cd server && echo Servidor a correr em http://localhost:3000 && node index.js"

echo.
echo [5/5] Servidor backend iniciado!
echo.
echo ========================================
echo   Servidor: http://localhost:3000
echo ========================================
echo.
echo Proximos passos:
echo 1. Abre outro terminal
echo 2. cd app
echo 3. flutter pub get
echo 4. flutter run -d chrome
echo.
echo Credenciais de teste:
echo Email: test@example.com
echo Password: test123
echo.
pause
