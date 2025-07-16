@echo off
REM Unified script to generate index.js files for both cards and scenarios directories

setlocal enabledelayedexpansion

REM Get current UTC timestamp
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set year=%datetime:~0,4%
set month=%datetime:~4,2%
set day=%datetime:~6,2%
set hour=%datetime:~8,2%
set minute=%datetime:~10,2%
set second=%datetime:~12,2%
set timestamp=%year%-%month%-%day%T%hour%:%minute%:%second%Z

set cards_success=0
set scenarios_success=0

REM Generate cards index
call :generate_cards
if !errorlevel! equ 0 set cards_success=1

REM Generate scenarios index
call :generate_scenarios
if !errorlevel! equ 0 set scenarios_success=1

REM Check results and exit
if !cards_success! equ 1 goto :success
if !scenarios_success! equ 1 goto :success
echo No index files were generated. Please check that cards/ and/or scenarios/ directories exist.
exit /b 1

:success
echo Index files have been generated. You can now use the ViBBS application.
exit /b 0

REM Function to generate cards index
:generate_cards
set CARDS_DIR=cards
set OUTPUT_FILE=%CARDS_DIR%\index.js

REM Check if cards directory exists
if not exist "%CARDS_DIR%" (
    echo ✗ Failed to generate cards/index.js - directory not found
    exit /b 1
)

REM Create the index.js file
echo // Auto-generated file - edit to add filenames manually at your own risk > "%OUTPUT_FILE%"
echo // Last generated: %timestamp% >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo export const files = [ >> "%OUTPUT_FILE%"

REM Find all PNG files and add them to the array
set count=0
for /f "delims=" %%F in ('dir /b "%CARDS_DIR%\*.png" 2^>nul ^| sort') do (
    echo   "%%F", >> "%OUTPUT_FILE%"
    set /a count+=1
)

echo ]; >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo export const lastGenerated = "%timestamp%"; >> "%OUTPUT_FILE%"

echo ✓ Generated %OUTPUT_FILE% with !count! files
exit /b 0

REM Function to generate scenarios index
:generate_scenarios
set SCENARIOS_DIR=scenarios
set OUTPUT_FILE=%SCENARIOS_DIR%\index.js

REM Check if scenarios directory exists
if not exist "%SCENARIOS_DIR%" (
    echo ✗ Failed to generate scenarios/index.js - directory not found
    exit /b 1
)

REM Create the index.js file
echo // Auto-generated file - edit to add filenames manually at your own risk > "%OUTPUT_FILE%"
echo // Last generated: %timestamp% >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo export const files = [ >> "%OUTPUT_FILE%"

REM Find all image files and add them to the array
set count=0
for /f "delims=" %%F in ('dir /b "%SCENARIOS_DIR%\*.png" "%SCENARIOS_DIR%\*.jpg" "%SCENARIOS_DIR%\*.jpeg" 2^>nul ^| sort') do (
    echo   "%%F", >> "%OUTPUT_FILE%"
    set /a count+=1
)

echo ]; >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo export const lastGenerated = "%timestamp%"; >> "%OUTPUT_FILE%"

echo ✓ Generated %OUTPUT_FILE% with !count! files
exit /b 0