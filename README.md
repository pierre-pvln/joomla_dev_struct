# Create Joomla! extension development structure
Generic scripts to create a Joomla! extension folder structure.
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

The downloadable extension .zip file is available at:
```
 download.pvln.nl/joomla/<extensiontype>/<extensionname>/
```

The downloadable extension update .xml file is available at:
```
 update.pvln.nl/joomla/<extensiontype>/<extensionname>/
```
