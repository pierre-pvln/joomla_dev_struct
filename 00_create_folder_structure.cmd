:: Name:     00_create_folder_structure.cmd
:: Purpose:  Create the baseline folder structure for development projects in current directory
:: Author:   pierre@pvln.nl
:: Revision: 2018 07 31 - initial version
::           2018 12 24 - added some folders
::
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

:: Create folder structure
::
IF NOT EXIST 00_dev_code      (md 00_dev_code)
IF NOT EXIST 01_building      (md 01_building)
IF NOT EXIST 02_staging       (md 02_staging)
IF NOT EXIST 03_deploying     (md 03_deploying)
IF NOT EXIST 04_settings      (md 04_settings)
IF NOT EXIST 05_testing       (md 05_testing)
IF NOT EXIST 06_output        (md 06_output)
IF NOT EXIST 07_documentation (md 07_documentation)
IF NOT EXIST 08_sources       (md 08_sources)
IF NOT EXIST 09_temporary     (md 09_temporary)
IF NOT EXIST @_started_*      (md @_started_%date:~9,4%_%date:~6,2%_%date:~3,2%_@)

:: Wait some time and exit the script
::
timeout /T 5
