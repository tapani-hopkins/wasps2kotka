# wasps2kotka

Folder "extdata" contains templates for creating a Kotka upload, and other files used by the script.

## templates

Modifying these changes what the script does.

The data is added to the Kotka upload in the order: kotka_template -> user input -> kotka_template_Ecuador -> kotka_template_malaise -> Malaise sample data. If the same data is given by several templates, the later ones overwrite the earlier ones. 

-  **kotka_template.csv**  Default data to add to the Kotka upload. This is the basic data shared by all wasps. The Kotka upload will be in the same format as this file. If you want to change the column order of the upload file, change the order here. If you want to have more columns, download them from Kotka and add here. (At the moment, the other template files will need to have the same column order for the script to work properly, so change in them too.)


-  **kotka_template_Ecuador.csv**  Ecuadorian data to add to the Kotka uploads. This is the basic data shared by all wasps caught by canopy fogging in Tiputini and Onkone Gare. Different format to the other templates (only one header row and different data for Tiputini and Onkone Gare).


-  **kotka_template_malaise.csv**  Malaise sample data to add to the Kotka uploads. This is the basic data shared by all wasps caught by Malaise trapping in Peru and Uganda. Often not needed, since the default data and sample data will often already contain everything in here.

-  **kotka_template_subsample.csv**  Data to add to the Kotka uploads for subsamples. This is data for subsamples such as braconids, miscellaneous insects etc, separated from the main Malaise samples. Overwrites some of the basic data shared by individual wasps (e.g. "count", since there are several individuals).


## other files

-  **input_field_kotka_equivalents.csv**  is used by the script to place user-input data in the correct column in Kotka. E.g. if the user inputs a column called "sex", the equivalent column in the Kotka data is "MYGathering[0][MYUnit][0][MYSex]". Used by the script to add user-input data to the upload. If changing these, update the documentation for function *verify_data()*.

-  **kotka_desired_malaise_sample_columns.csv**  What columns to extract from the Malaise sample data ("malaise_samples_kotka_format.rda"). The data in these columns will be added to the Kotka upload. Each column name (1st header row in Kotka) is on its own row in this file.

-  **malaise_samples.csv**  contains the basic data on the malaise samples. To add new samples to the package, add them here, then save as "m.rda" in folder "data". You'll need to read them in to R before saving with e.g. `read.csv("malaise_samples.csv", check.names=FALSE, colClasses="character")`

-  **malaise_samples_kotka.csv**  contains the complete data on the malaise samples. To add new samples to the package, add them here, then save as "m_kotka.rda" in folder "data". You'll need to read them in to R before saving with e.g. `read.csv("malaise_samples_kotka.csv", check.names=FALSE, colClasses="character")`. Make sure the sample identifier is in column "MYOriginalSpecimenID", the script checks the sample from that column!


