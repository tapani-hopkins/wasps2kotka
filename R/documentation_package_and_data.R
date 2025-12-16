#' @details 
#' Typical usage is one of the following:
#' * Write down the sample which wasps came from, and create an upload file for the wasps with [make_upload()]. 
#' * Write down the wasp labels, then use [make_upload()] to extract data from the labels and create an upload file for the wasps.  
#' 
#' Before using, you will need to load the label texts or sample identifiers to R. Typically this will be by reading a text file, or a csv file you've exported from Excel.  
#' 
#' After you've got the upload file, you'll need to add any missing fields. It is also worth checking if any problems occurred: the script highlights any incorrect sample identifiers or date mismatches between labels and samples.
#'
#' @examples
#' # example labels
#' labels = c(  
#' "cct1-141022",  
#' "PERU, Allpahuayo 1.-15.12.2000, Sääksjärvi I.E I1/17 Occia sp. 1. ♀ ",  
#' "ECUADOR, Tiputini, 22. Oct 1998, Canopy fogging Lot# 1966 Meniscomorpha sp. 2 ♀ ",  
#' "cct1-141023 incorrect sample ID",  
#' "PERU, Allpahuayo 3.-16.12.2000, dates are wrong, Sääksjärvi I.E I1/17"
#' )
#'
#' # example data on sex (note that wasp 2 contradicts label)
#' sex = c("F", "M", NA, NA, NA)
#' 
#' # save data
#' x = data.frame(label=labels, sex=sex)
#' 
#' # create a Kotka upload for these wasps (but do not save to file)
#' upload = make_upload(x, upload_file=NA, problems_file=NA)
#' upload
#' @keywords internal
"_PACKAGE"


#' Example labels of wasps from Peru and Ecuador
#'
#' Labels of Amazonian wasps collected in Peru and Ecuador. These give a good example of what kind of labels there are: Ecuadorian canopy fogging labels, Peruvian labels from 1998-2011, quite a few mistypes, mistakes etc.. These are real labels of Banchinae wasps.
#'
#' @format A data frame with 188 rows (one row for each wasp) and 1 variables:
#' \describe{
#'   \item{label}{Text of labels in the format expected by Kotka. Each label on a separate row, separated by carriage returns.}
#' }
"example_labels"


#' Malaise samples collected in Peru, Uganda and elsewhere (overview)
#'
#' An abbreviated version of the `m_kotka` dataset. Contains basic data on what Malaise samples were collected in e.g. Peru and Uganda, including how the samples might be written on labels. Used by the script to e.g. recognise sample IDs from labels.
#'
#' @format A data frame with 1541 rows (one row for each sample) and 12 variables:
#' \describe{
#'   \item{sample}{Sample ID, plaintext form used at the Turku Zoological Museum}
#'   \item{event}{Malaise trapping that collected the sample, e.g. "Amazon 1998"}
#'   \item{trap}{Malaise trap that collected the sample}
#'   \item{sample_number}{Latter half of the sample ID, telling which of the trap's samples this is}
#'   \item{date_begin}{When the Malaise sample started to be collected. Finnish date format *day.month.year*.}
#'   \item{date_end}{When the Malaise sample stopped being collected. Finnish date format *day.month.year*.}
#'   \item{MYDatasetID\[0\]}{Dataset identifier used by the Kotka. This dataset gives the collecting event.}
#'   \item{MYDatasetID\[1\]}{Dataset identifier used by the Kotka. This dataset gives the forest type.}
#'   \item{MYDatasetID\[2\]}{Dataset identifier used by the Kotka. This dataset gives the trap.}
#'   \item{MYDatasetID\[3\]}{Dataset identifier used by the Kotka. This dataset marks any damaged samples.}
#'   \item{sample_1998_2000}{How the sample ID is typically written on labels related to the Amazon 1998 and Amazon 2000 Malaise trapping.}
#'   \item{trap_2008_2011}{How the trap is typically written on labels related to the Amazon 2008 and Amazon 2011 Malaise trapping.}
#' }
"m"


#' Malaise samples collected in Peru, Uganda and elsewhere (Kotka format)
#'
#' Data on the Malaise samples collected in e.g. Peru and Uganda, in the format Kotka uses. Contains almost everything that is in Kotka (some irrelevant columns may have been omitted). Used by the script to get the collecting dates, coordinates etc data for wasps caught in these samples.
#'
#' This file has been downloaded from the Kotka Collection Management System in Excel format. If a new version is ever needed:
#' - download from Kotka
#' - remove second header row
#' - convert to csv
#' - read in to R keeping the column names intact, e.g. `read.csv(file, colClasses="character", check.names=F)`
#'
#' @format A data frame with 1541 rows (one row for each sample) and 46 variables. The variables are described in [https://kotka.luomus.fi/documentation/field](https://kotka.luomus.fi/documentation/field).
"m_kotka"
