:: Name:     folders.cmd
:: Purpose:  set folders for updateserver and downloadserver as an environment variable
:: Author:   pierre.veelen@pvln.nl
:: Revision: 2018 07 21 - initial version
::           2018 07 24 - build process unified and extension as environment variable
::
:: Required environment variables:
::
:: %extension% name of the extension
::

:: -OUTPUT DIRECTORY FOR BUILD
:: do not start with \ , and do not end with \
SET output_dir=..\06_output

:: -BACKUP DIRECTORY FOR OUTPUT BUILD
:: do not start with \ , and do not end with \
SET backup_dir=%output_dir%\backup

:: -FTP FOLDERS
SET ftp_update_folder=/update/joomla/modules/%extension%/
SET ftp_download_folder=/download/joomla/modules/%extension%/
