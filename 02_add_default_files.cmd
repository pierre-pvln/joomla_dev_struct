:: Name:     02_add_default_files.cmd
:: Purpose:  Create the baseline folder structure for development projects in current directory
:: Author:   pierre.veelen@pvln.nl
:: Revision: 2018 08 21 - initial version

@ECHO off
SETLOCAL ENABLEEXTENSIONS

:: BASIC SETTINGS
:: ==============
:: Setting the name of the script
SET me=%~n0
:: Setting the name of the directory with this script
SET parent=%~p0
:: Setting the drive of this commandfile
SET drive=%~d0
:: Setting the directory and drive of this commandfile
SET cmd_dir=%~dp0

:: Add default files for 00_dev_code folder
CD "%cmd_dir%"
CD 00_dev_code
IF NOT EXIST "README.md" (
ECHO # README file >README.md
)

IF NOT EXIST "CHANGELOG.md" (
ECHO --- 
ECHO #  Changelog Code:
ECHO ---
ECHO ^<h4^>v.0.0.1 %date:~9,4%-%date:~6,2%-%date:~3,2%^</h4^>
ECHO ^<ul^>
ECHO ^<li^>Initial version^</li^>
ECHO ^</ul^>
) >CHANGELOG.md

:: Add default files for 02_build_process folder
::
CD "%cmd_dir%"
CD 02_build_process
IF NOT EXIST "README.md" (
ECHO # README file >README.md
)

IF NOT EXIST "CHANGELOG.md" (
ECHO --- 
ECHO #  Changelog Build Process:
ECHO ---
ECHO ^<h4^>v.0.0.1 %date:~9,4%-%date:~6,2%-%date:~3,2%^</h4^>
ECHO ^<ul^>
ECHO ^<li^>Initial version^</li^>
ECHO ^</ul^>
) >CHANGELOG.md

:: Wait some time and exit the script
::
timeout /T 10
