:: Name:     02_add_default_git.cmd
:: Purpose:  Add default git repositories for development projects in current extension folder
::           and create master and develop branch for new project.
:: 
::           The end-state of this script:
::           - folder 02_build_process:
::             - is under git control,
::             - was initialized with the production release for github.
::             - is then given an own git branch name
::             - using that branch name
::
::           - folder 00_dev_code:
::             - is under git control,
::             - a repository is created on github
::             - github repository contains a master and develop branch
::             - local is connected to github develop branch for this repository
::
:: Author:   pierre.veelen@pvln.nl
:: Revision: 2018 08 21 - initial version
::           2018 08 26 - additional git commands added to be able to reach the defined end-state
::                        independent of the state of the folders when the script is run.   

@ECHO off
SETLOCAL ENABLEEXTENSIONS

SET VERBOSE=YES

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

:: ==================================
::  DETERMIN EXTENSION NAME
:: ==================================

:: get the name of the folder in an environment variable
:: https://superuser.com/questions/160702/get-current-folder-name-by-a-dos-command
:: http://www.robvanderwoude.com/ntfor.php
::
IF %VERBOSE%==YES ECHO ... Determining extension name based on foldername
for %%I in (.) do set extensionFolderName=%%~nxI

:: remove spaces in name
:: http://www.dostips.com/DtTipsStringManipulation.php
:: 
SET extensionFolderName=%extensionFolderName: =%

:: Convert extension to lowercase
:: http://www.robvanderwoude.com/battech_convertcase.php
::
FOR %%i IN ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i" "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r" "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z") DO CALL SET "extensionFolderName=%%extensionFolderName:%%~i%%"

IF %VERBOSE%==YES ECHO ... Extension name is: %extensionFolderName%

:: ==================================
::  FOLDER: 02_build_process
:: ==================================
CD "%cmd_dir%"
CD 02_build_process

IF %VERBOSE%==YES ECHO ... Currently running in %CD%

:: check if folder is under git control
::
IF %VERBOSE%==YES ECHO ... Check if folder is under git control
git status
IF %ERRORLEVEL% NEQ 0 (
:: if not initialize folder 
   IF %VERBOSE%==YES ECHO ... This folder is not under git control: Initializing git
   git init
   git config --global user.name Pierre Veelen
   git config --global user.email pierre@pvln.nl
   git config --global color.ui auto
   IF %VERBOSE%==YES ECHO ... Adding remote repository
   git remote add origin git@github.com:pierre-pvln/joomla-build.git
)

:: Get the files from github master branch. 
:: These contain the latest production release
IF %VERBOSE%==YES ECHO Pulling remote files from git master branch ...
git pull origin master
IF %ERRORLEVEL% NEQ 0 (
   IF %VERBOSE%==YES ECHO Error pulling remote files from git ...
   SET ERROR_MESSAGE=Error pulling files from git@github.com:pierre-pvln/joomla-build.git
   GOTO ERROR_EXIT
) 

:: The assumption is that during the development of the extension the build process is updated also.
:: Therefore we create another branch for the changes in the build process of the extension
:: So we can merge them to production (master branch) at a later stage
git checkout -b "updates-from-%extensionFolderName%" master
IF %ERRORLEVEL% NEQ 0 (
   ::branch already existed so only go to branch and not also create it from master
   git checkout "updates-from-%extensionFolderName%"
)

:: display current branch
ECHO Currently using the following branch for 02_build_process:
git rev-parse --abbrev-ref HEAD


:: ==================================
:: FOLDER: 00_dev_code
:: ==================================
CD "%cmd_dir%"
CD 00_dev_code
IF %VERBOSE%==YES ECHO Currently running in %CD%

:: check if folder is under git control
::
IF %VERBOSE%==YES ECHO Check if folder is under git control ...
git status
IF %ERRORLEVEL% NEQ 0 (
:: if not initialize folder
  IF %VERBOSE%==YES ECHO ... This folder is not under git control: Initializing git
   git init
   git config --global user.name Pierre Veelen
   git config --global user.email pierre@pvln.nl
   git config --global color.ui auto
   IF %VERBOSE%==YES ECHO Adding remote repository ...
   git remote add origin git@github.com:pierre-pvln/%extensionFolderName%.git
)

Pause

:: Get the files from github master branch. 
:: These contain the latest production release
git pull origin master
IF %ERRORLEVEL% NEQ 0 (
   :: origin not set
   :: repository pierre-pvln/%extensionFolderName% should hold the files
   ::
   IF %VERBOSE%==YES ECHO Adding remote repository ...
   git remote add origin git@github.com:pierre-pvln/%extensionFolderName%.git
   :: origin initialized
   :: and now get files
   git pull origin master
   IF %ERRORLEVEL% NEQ 0 (
   :: repository doesn't exist.
   :: create it on github.
   :: switch remote URLs from SSH to HTTPS
      IF %VERBOSE%==YES ECHO Repository doens't exist on github so creating it ...
      git remote set-url origin https://github.com/pierre-pvln/%extensionFolderName%.git
	  ECHO {"name":"%extensionFolderName%", "description":"This is the repository for the %extensionFolderName% project"}>data.json
	  curl -u pierre-pvln:<<PASSWORD>> https://api.github.com/user/repos -d @data.json -X POST
      git remote set-url origin git@github.com:pierre-pvln/%extensionFolderName%.git
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
