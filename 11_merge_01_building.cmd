:: Name:     11_merge_02_build_process.cmd
:: Purpose:  Add default git repositories for development projects in current directory
::           and create master and develop branch for new project 
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

:: get the name of the folder in an environment variable
:: https://superuser.com/questions/160702/get-current-folder-name-by-a-dos-command
:: http://www.robvanderwoude.com/ntfor.php
::
FOR %%I IN (.) DO SET extensionFolderName=%%~nxI

CD "%cmd_dir%"
CD 02_build_process

:: Get current branch in environment variable
:: https://ss64.com/nt/for_cmd.html
::
FOR /F %%G IN ('git rev-parse --abbrev-ref HEAD') DO SET currentGitBranch=%%G

:: remove spaces in name
:: http://www.dostips.com/DtTipsStringManipulation.php
:: 
SET currentGitBranch=%currentGitBranch: =%

:: show the result 
echo Current branch: %currentGitBranch%

IF "%currentGitBranch%"=="release-%extensionFolderName%" (
   :: go back to master
   git checkout master
   git merge --no-ff "release-%extensionFolderName%"
) ELSE (
   IF "%currentGitBranch%"=="master" (
      :: already on master
      git merge --no-ff "release-%extensionFolderName%"
   ) ELSE (
      SET ERROR_MESSAGE=Unexpected branch: %currentGitBranch%
      GOTO ERROR_EXIT
   )
)

GOTO CLEAN_EXIT

:ERROR_EXIT
CD "%cmd_dir%" 
ECHO *******************
ECHO Error: %ERROR_MESSAGE%
ECHO *******************

   
:CLEAN_EXIT   
timeout /T 10
