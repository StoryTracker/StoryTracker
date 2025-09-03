@echo off
setlocal enabledelayedexpansion

REM StoryTracker PostgreSQL Docker Manager for Windows

if "%1"=="" goto help

if "%1"=="start" goto start
if "%1"=="stop" goto stop
if "%1"=="restart" goto restart
if "%1"=="status" goto status
if "%1"=="connect" goto connect
if "%1"=="help" goto help

echo [ERROR] Unknown command: %1
goto help

:start
echo [INFO] Starting PostgreSQL database...
docker-compose up -d postgres
echo [INFO] PostgreSQL database is ready!
echo   Host: localhost, Port: 5432
echo   Database: storytracker, User: storyuser
goto end

:stop
echo [INFO] Stopping PostgreSQL database...
docker-compose down
goto end

:restart
call :stop
call :start
goto end

:status
echo [INFO] Checking database status...
docker-compose ps postgres
goto end

:connect
echo [INFO] Connecting to database...
docker-compose exec postgres psql -U storyuser -d storytracker
goto end

:help
echo StoryTracker PostgreSQL Docker Manager
echo.
echo Usage: %0 [COMMAND]
echo.
echo Commands:
echo   start     Start the database
echo   stop      Stop the database
echo   restart   Restart the database
echo   status    Show database status
echo   connect   Connect to database
echo   help      Show this help message
echo.
echo Examples:
echo   %0 start
echo   %0 status

:end
endlocal
