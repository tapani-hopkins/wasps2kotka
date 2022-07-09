#' Create a file for uploading wasp data to the Kotka database
#'
#' Create a Kotka upload file out of the data extracted from wasp labels (or obtained from sample IDs). Handles wasps from the Malaise trapping in Peru (1998-2011), and from the canopy fogging in Ecuador. Other specimens will be included in the upload, but will only have minimal data.  
#'
#' @param x A data frame returned by [get_labeldata()] or [verify_labeldata()].
#' @param write.csv If TRUE (the default) the Kotka upload will be written to file "kotka_upload.csv", as well as returned invisibly. If FALSE, the Kotka upload will only be returned invisibly. 
#'
#' @return A data frame with the Kotka upload. Also contains the columns of the input data frame (`x`), which the upload is based on. \cr
#' 
#' The columns of `x` are there for reference before uploading. Typically, column `problems` will be checked so any issues can be fixed. These columns should be deleted before uploading to Kotka, they are marked with "delete this column" and are at the start of the file.
#' 
#' @export
#'
#' @seealso [get_labeldata()] which extracts the data used by this function, [verify_labeldata()] which checks the extracted data for problems.
#' 
#' @examples
#' lab = c("cct1-141022", "PERU 1.-15.12.2000 I1/17", "Not a wasp label at all")
#' x = get_labeldata(lab)
#' x = verify_labeldata(x)
#' upload = make_kotkaupload(x, write.csv=FALSE)
make_kotkaupload = function(x, write.csv=TRUE){
	# Converts data extracted from labels into an upload file for Kotka.
	# Uses helper function 'add_ecuadordata' and function 'add_malaisedata'.
	# Returns a data frame with the extracted data and upload data.
	# Also saves it as csv.
	# (delete the extracted data columns before upload, they are for comparison only)
	#  x  data frame returned by 'get_labeldata' or 'verify_labeldata'
	#  write.csv  set to FALSE if you don't want to save to file
	
	# create a data frame for the Kotka upload
	f = system.file("extdata", "kotka_template.csv", package = "wasps2kotka")
	k = utils::read.csv(f, colClasses = "character", check.names=F, nrows=2)
	
	# save 2nd header row, then remove it from 'k'
	# (Kotka inconveniently uses two header rows, ignore 2nd one until end of script)
	k2 = unlist(k[1, ])
	k = k[-1, ]
	
	# make 'k' the right size, fill with default data from template
	k[1:nrow(x), ] = k[1, ]
	
	# copy the labels and label data to 'k'
	k$MYLabelsVerbatim = as.character(x$label)
	k$"MYGathering[0][MYUnit][0][MYSex]" = as.character(x$sex)
	k$"MYGathering[0][MYDateBegin]" = format(x$date_begin, "%d.%m.%Y")
	k$"MYGathering[0][MYDateEnd]" = format(x$date_end, "%d.%m.%Y")
	
	# add Ecuadorian data from template to 'k'
	k = add_ecuadordata(k, x)
	
	# add Peruvian and Ugandan data from template and from sample data
	k = add_malaisedata(k, x)
	
	# join 'x' and 'k', make sure all the columns are character
	X = cbind(x, k)
	X[] = lapply(X, as.character)
	
	# create 2nd header row (Kotka uses two header rows)
	h2 = rep("delete this column", ncol(x))
	h2 = c(h2, k2)
	X = rbind(h2, X)
	
	# save as file
	if(write.csv){
		utils::write.csv(X, "kotka_upload.csv", row.names=F, na="")
	}
	
	# return
	invisible(X)
	
}