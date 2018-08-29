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
::                        independent of the state of the folders when the script is run.\
::           2018 08 29 - git settings added   

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

:: STATIC VARIABLES
:: ================
cd ..\..\..\_secrets
IF EXIST git_settings.cmd (
   CALL git_settings.cmd
) ELSE (
   SET ERROR_MESSAGE=File with git settings doesn't exist
   GOTO ERROR_EXIT
)
cd "%cmd_dir%"

:: ==================================
::  DETERMINE EXTENSION NAME
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
SET currentGitBranch=NONE

CD "%cmd_dir%"
CD 02_build_process

IF %VERBOSE%==YES ECHO ... Currently running in %CD%

:: check if folder is under git control
::
IF %VERBOSE%==YES ECHO ... Check if folder is under git control
git status
IF %ERRORLEVEL% NEQ 0 (
:: initialize git in folder and start tracking
   IF %VERBOSE%==YES ECHO ... This folder is not under git control: Initializing git
   git init
   git config --global user.name Pierre Veelen
   git config --global user.email pierre@pvln.nl
   git config --global color.ui auto
   
   IF %VERBOSE%==YES ECHO ... Adding remote repository %git_username%/joomla-build
   git remote add origin git@github.com:%git_username%/joomla-build.git
   
   IF %VERBOSE%==YES ECHO ... Pulling remote files from git master branch
   git pull origin master
)

IF %VERBOSE%==YES ECHO ... Determine current local branch name
:: Get current branch in environment variable
:: https://ss64.com/nt/for_cmd.html
::
FOR /F %%G IN ('git rev-parse --abbrev-ref HEAD') DO SET currentGitBranch=%%G

:: remove spaces in name
:: http://www.dostips.com/DtTipsStringManipulation.php
:: 
SET currentGitBranch=%currentGitBranch: =%
   
:: show the result 
IF %VERBOSE%==YES ECHO ... Current branch: %currentGitBranch%

:: current git branch is determined 

:: The assumption is that during the development of the extension the build process is updated also.
:: Therefore we create another local branch for the changes in the build process of the extension
:: So we can merge them to production (master branch) and/or development (develop branch) at a later stage
IF %currentGitBranch%==master (
   IF %VERBOSE%==YES ECHO ... Trying to create updates-from-%extensionFolderName% branch
   git branch "updates-from-%extensionFolderName%" master
   git checkout "updates-from-%extensionFolderName%"
)

:: display current branch
IF %VERBOSE%==YES (
   ECHO Currently using the following branch for 02_build_process:
   git rev-parse --abbrev-ref HEAD
)

:: ==================================
:: FOLDER: 00_dev_code
:: ==================================
SET currentGitBranch=NONE
SET createdGitRepo=NO

CD "%cmd_dir%"
CD 00_dev_code

IF %VERBOSE%==YES ECHO ... Currently running in %CD%

:: check if folder is under git control
::
IF %VERBOSE%==YES ECHO ... Check if folder is under git control
git status
IF %ERRORLEVEL% NEQ 0 (
:: initialize git in folder and start tracking
   IF %VERBOSE%==YES ECHO ... This folder is not under git control: Initializing git
   git init
   git config --global user.name Pierre Veelen
   git config --global user.email pierre@pvln.nl
   git config --global color.ui auto
   
   IF %VERBOSE%==YES ECHO ... Adding remote repository %git_username%/%extensionFolderName%
   git remote add origin git@github.com:%git_username%/%extensionFolderName%.git
)

IF %VERBOSE%==YES ECHO ... Pulling remote files from git master branch
git pull origin master
IF %ERRORLEVEL% NEQ 0 (
   IF %VERBOSE%==YES ECHO ... Repository doens't exist on github so creating it ...
   git remote set-url origin https://github.com/%git_username%/%extensionFolderName%.git
   ECHO {"name":"%extensionFolderName%", "description":"This is the repository for the %extensionFolderName% project"}>data.json
   curl -u %git_username%:%git_password% https://api.github.com/user/repos -d @data.json -X POST
   DEL data.json
   git remote set-url origin git@github.com:%git_username%/%extensionFolderName%.git
   SET createdGitRepo=YES
)

IF NOT EXIST "README.md" (
   ECHO # README file for the %extensionFolderName% Joomla! extension >README.md
)

IF NOT EXIST "CHANGELOG.md" (
ECHO --- 
ECHO #  Changelog for the %extensionFolderName% Joomla! code:
ECHO ---
ECHO ^<h4^>v.0.0.1 %date:~9,4%-%date:~6,2%-%date:~3,2%^</h4^>
ECHO ^<ul^>
ECHO ^<li^>Initial version^</li^>
ECHO ^</ul^>
) >CHANGELOG.md

IF %createdGitRepo%==YES (
   git add .
   git commit -m "First master branch commit"
   git push -u origin master
   
   git branch develop master
   git checkout develop
   git commit -m "First develop branch commit"
   git push -u origin develop
   
   git checkout master
)

IF %VERBOSE%==YES ECHO ... Pulling remote files from git master branch again
git pull origin master

IF %VERBOSE%==YES ECHO ... Determine current local branch name
:: Get current branch in environment variable
:: https://ss64.com/nt/for_cmd.html
::
FOR /F %%G IN ('git rev-parse --abbrev-ref HEAD') DO SET currentGitBranch=%%G

:: remove spaces in name
:: http://www.dostips.com/DtTipsStringManipulation.php
:: 
SET currentGitBranch=%currentGitBranch: =%
   
:: show the result 
IF %VERBOSE%==YES ECHO ... Current branch: %currentGitBranch%

:: current git branch is determined 

:: The assumption is that during the development of the extension the build process is updated also.
:: Therefore we create another local branch for the changes in the build process of the extension
:: So we can merge them to production (master branch) and/or development (develop branch) at a later stage
IF %currentGitBranch%==master (
   IF %VERBOSE%==YES ECHO ... Trying to create updates-for-%extensionFolderName% branch
   git branch "updates-for-%extensionFolderName%" master
   git checkout "updates-for-%extensionFolderName%"
)

:: display current branch
IF %VERBOSE%==YES (
   ECHO Currently using the following branch for 00_dev_code:
   git rev-parse --abbrev-ref HEAD
)

GOTO CLEAN_EXIT

:ERROR_EXIT
CD "%cmd_dir%" 
ECHO *******************
ECHO Error: %ERROR_MESSAGE%
ECHO *******************


:CLEAN_EXIT
Timeout /T 10
