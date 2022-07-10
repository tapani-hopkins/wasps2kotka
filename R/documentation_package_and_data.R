#' @details 
#' Typical usage is to get data from labels with [get_labeldata()], verify the extracted data with [verify_labeldata()], then use [make_kotkaupload()] to create an upload file.  
#' 
#' Before using, you will need to load the labels texts to R. Typically this will be by reading a text file, or a csv file you've exported from Excel.  
#' 
#' After you've got the upload file, you'll need to add any missing fields and remove extra columns. The extra columns show if any problems occurred, but are not accepted by Kotka.
#'
#' @examples
#' # example labels
#' labels = c(  
#' "cct1-141022",  
#' "PERU, Allpahuayo 1.-15.12.2000, Sääksjärvi I.E I1/17",  
#' "ECUADOR, Tiputini, 22. Oct 1998, Canopy fogging Lot# 1966 Meniscomorpha sp. 2"  
#' )
#' 
#' # get data from the labels
#' x = get_labeldata(labels)
#' 
#' # check the extracted data (optional but strongly recommended!)
#' x = verify_labeldata(x)
#' 
#' # create a Kotka upload file for these wasps (but do not save it)
#' upload = make_kotkaupload(x, write.csv=FALSE)
#' upload
#' @keywords internal
"_PACKAGE"


#' Malaise samples collected in Peru and Uganda (overview)
#'
#' An abbreviated version of the `malaise_samples_kotka_format` dataset. Contains basic data on what Malaise samples were collected in Peru and Uganda, including how the samples might be written on labels. Used by the script to e.g. recognise sample IDs from labels.
#'
#' @format A data frame with 1519 rows (one row for each sample) and 11 variables:
#' \describe{
#'   \item{sample}{Sample ID, plaintext form used at the Turku Zoological Museum}
#'   \item{event}{Malaise trapping that collected the sample, e.g. "Amazon 1998"}
#'   \item{trap}{Malaise trap that collected the sample}
#'   \item{sample_number}{Latter half of the sample ID, telling which of the trap's samples this is}
#'   \item{date_begin}{When the Malaise sample started to be collected. Finnish date format *day.month.year*.}
#'   \item{date_end}{When the Malaise sample stopped being collected. Finnish date format *day.month.year*.}
#'   \item{sample_1998_2000}{How the sample ID is typically written on labels related to the Amazon 1998 and Amazon 2000 Malaise trapping.}
#'   \item{MYDatasetID\[0\]}{Dataset identifier used by the Kotka. This dataset gives the collecting event.}
#'   \item{MYDatasetID\[1\]}{Dataset identifier used by the Kotka. This dataset gives the forest type.}
#'   \item{MYDatasetID\[2\]}{Dataset identifier used by the Kotka. This dataset gives the trap.}
#'   \item{MYDatasetID\[3\]}{Dataset identifier used by the Kotka. This dataset marks any damaged samples.}
#' }
"malaise_samples"


#' Malaise samples collected in Peru and Uganda (Kotka format)
#'
#' Data on the Malaise samples collected in Peru and Uganda, in the format Kotka uses. Contains almost everything that is in Kotka (some irrelevant columns may have been omitted). Used by the script to get the collecting dates, coordinates etc data for wasps caught in these samples.
#'
#' This file has been downloaded from the Kotka Collection Management System in Excel format. If a new version is ever needed:
#' - download from Kotka
#' - remove second header row
#' - convert to csv
#' - read in to R keeping the column names intact, e.g. `read.csv(file, colClasses="character", check.names=F)`
#'
#' @format A data frame with 1519 rows (one row for each sample) and 46 variables. The variables are described in [https://kotka.luomus.fi/documentation/field](https://kotka.luomus.fi/documentation/field).
"malaise_samples_kotka_format"
