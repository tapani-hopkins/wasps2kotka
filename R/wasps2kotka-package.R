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

## usethis namespace: start
## usethis namespace: end
NULL
