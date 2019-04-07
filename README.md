# Create Joomla! extension development structure
After running the scripts a default folder structure is available for the development of Joomla! website extensions.

Below folder structure is created on the workstation on which development is done:
```
extensionname\00_dev_code       folder with the code for the Joomla! extension, 
                                which gets installed on the Joomla! website
             \01_building       folder with scripts to build the extension zipfile            
             \02_staging        folder with scripts to stage the extension zipfile to download server
             \03_deploying      folder with scripts for deploying files to (production) server
             \04_settings       folder with settings used by scripts in other folders
             \05_testing        folder with testing scripts
             \06_output         folder with the ouput files from the 01_building scripts
             \07_documentation  folder with documentation on the extension, the ToDo list
             \08_sources        folder with relevant information links and inspiration
                                used to create the extension
             \09_temporary      folder with temporary files
```
The following scripts are included:
```
00_create_folder_structure.cmd  Creates the above folderstructure.
```
``` 
01_add_default_git.cmd          - Adds default joomla! development scripts for extensions in 01_building;
                                - Creates a new repository on GitHub for the new developed extension;
                                - Initiates git in the \00_dev_code folder and links it to github;  
                                - Switches the 01_building from master to a new branch.
```
``` 
02_add_default_files.cmd        Adds some additional files.
```
``` 
11_merge_01_building.cmd        Merges the changes in the 01_building folder back to master.
```
# Getting the scripts
- Create the folder in which the extension is developed. Foldername should be the name of the extension.
- Goto into this new folder.
- Run the following commands. (<a href="https://curl.haxx.se/download.html" target="_blank">curl</a> should be present on your system)
```
curl -LJO https://raw.githubusercontent.com/pierre-pvln/joomla_dev_struct/master/00_create_folder_structure.cmd
curl -LJO https://raw.githubusercontent.com/pierre-pvln/joomla_dev_struct/master/01_add_default_git.cmd
curl -LJO https://raw.githubusercontent.com/pierre-pvln/joomla_dev_struct/master/02_add_default_files.cmd
curl -LJO https://raw.githubusercontent.com/pierre-pvln/joomla_dev_struct/master/11_merge_01_building.cmd
mkdir 04_settings
cd 04_settings
curl -LJO https://raw.githubusercontent.com/pierre-pvln/joomla_dev_struct/master/04_settings/00_name.cmd
curl -LJO https://raw.githubusercontent.com/pierre-pvln/joomla_dev_struct/master/04_settings/02_version.cmd
curl -LJO https://raw.githubusercontent.com/pierre-pvln/joomla_dev_struct/master/04_settings/04_folders.cmd
curl -LJO https://raw.githubusercontent.com/pierre-pvln/joomla_dev_struct/master/04_settings/files_to_exclude_in_zip.txt
cd ..

```
