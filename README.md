# Create Joomla! extension development structure
After running the scripts a default folder structure is available for the development of Joomla! website extensions.

Below folder structure is created on the workstation on which development is done:
```
extensionname\00_dev_code       folder with the code for the Joomla! extension, 
                                which gets installed on the Joomla! website
             \02_build_process  folder with scripts to build the extension zipfile
                                and deploy it to the Joomla! webserver
             \04_settings       folder with settings used by scripts in 02_build_process
             \06_output         folder with the ouput files from the 02_build_process scripts
             \07_documentation  folder with documentation on the extension, the ToDo list
             \08_sources        folder with relevant information links and inspiration
                                used to create the extension
```
The following scripts are included:
```
00_create_folder_structure.cmd  Creates the above folderstructure.
```
``` 
01_add_default_git.cmd          - Adds default joomla! development scripts for extensions in 02_build_process;
                                - Creates a new repository on GitHub for the new developed extension;
                                - Initiates git in the \00_dev_code folder and links it to github;  
                                - Switches the 02_build_process from master to a new branch.
```
``` 
02_add_default_files.cmd        Adds some additional files.
```
``` 
11_merge_02_build_process.cmd   Merges the changes in the 02_build_process folder back to master.
```
# Getting the scripts
- Create the folder in which the extension is developed. Foldername should be the name of the extension.
- Goto into this new folder.
- Run the following commands. (Curl should be available on your system)
```
curl -LJO https://raw.githubusercontent.com/pierre-pvln/joomla_dev_struct/master/00_create_folder_structure.cmd
curl -LJO https://raw.githubusercontent.com/pierre-pvln/joomla_dev_struct/master/01_add_default_git.cmd
curl -LJO https://raw.githubusercontent.com/pierre-pvln/joomla_dev_struct/master/02_add_default_files.cmd
curl -LJO https://raw.githubusercontent.com/pierre-pvln/joomla_dev_struct/master/11_merge_02_build_process.cmd
```
