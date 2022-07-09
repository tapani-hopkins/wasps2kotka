# wasps2kotka

Folder "extdata" contains template for creating a Kotka upload from the extracted data. Modifying these changes what the script does.

The data is added to the Kotka upload in the order: kotka_template -> kotka_template_Ecuador -> kotka_template_malaise -> Malaise sample data. If the same data is given by several templates, the later ones overwrite the earlier ones. 


## kotka_desired_malaise_sample_columns.csv

What columns to extract from the Malaise sample data ("malaise_samples_kotka_format.rda"). The data in these columns will be added to the Kotka upload. Each column name (1st header row in Kotka) is on its own row in this file.


## kotka_template.csv

Default data to add to the Kotka upload. This is the basic data shared by all wasps. 

The Kotka upload will be in the same format as this file. If you want to change the column order of the upload file, change the order here. If you want to have more columns, download them from Kotka and add here.


## kotka_template_Ecuador.csv

Ecuadorian data to add to the Kotka uploads. This is the basic data shared by all wasps caught by canopy fogging in Tiputini and Onkone Gare. Different format to the other templates (only one header row and different data for Tiputini and Onkone Gare).


## kotka_template_malaise.csv

Malaise sample data to add to the Kotka uploads. This is the basic data shared by all wasps caught by Malaise trapping in Peru and Uganda. Often not needed, since the default data and sample data will often already contain everything in here.