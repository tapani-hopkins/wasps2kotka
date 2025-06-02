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
