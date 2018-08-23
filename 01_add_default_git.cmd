:: Name:     02_add_default_git.cmd
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
for %%I in (.) do set extensionFolderName=%%~nxI


CD "%cmd_dir%"
CD 02_build_process

:: check if folder is under git control
::
git status
IF %ERRORLEVEL% NEQ 0 (
:: if not initialize folder 
   git init
   git config --global user.name Pierre Veelen
   git config --global user.email pierre@pvln.nl
   git config --global color.ui auto
)

:: Get the files from github master branch. 
:: These contain the latest production release
git pull origin master
IF %ERRORLEVEL% NEQ 0 (
   :: origin not set
   :: pierre-pvln/joomla-build holds the files
   ::
   git remote add origin git@github.com:pierre-pvln/joomla-build.git
   :: origin initialized
   :: and now get files
   git pull origin master
) 

:: The assumption is that during the development of the extension the build process is updated also.
:: Therefore we create another branch for the changes in the build process of the extension
:: So we can merge them to production (master branch) at a later stage
git checkout -b "release-%extensionFolderName%" master
IF %ERRORLEVEL% NEQ 0 (
   ::branch already existed so only go to branch and not also create it from master
   git checkout "release-%extensionFolderName%"
)

:: display current branch
git rev-parse --abbrev-ref HEAD

GOTO CLEAN_EXIT

:ERROR_EXIT
CD "%cmd_dir%" 
ECHO *******************
ECHO Error: %ERROR_MESSAGE%
ECHO *******************

   
:CLEAN_EXIT   
timeout /T 10
