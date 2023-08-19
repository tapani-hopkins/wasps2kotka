#' Create a file for uploading wasp data to the Kotka database
#'
#' Creates a Kotka upload file out of the data given to it. The data can e.g. be a data frame with labels, or a vector of sample identifiers. 
#'
#' Handles wasps from the Malaise trapping in Uganda (2014-2015) and Peru (1998-2011), and from the canopy fogging in Ecuador. Other specimens will be included in the upload, but will only have minimal data.  
#'
#' Verification is handled by [verify_data()]. Checks that the samples actually exist. If columns "date_begin" and "date_end" were given, also checks they match the sample collecting dates. If there are problems, a message is displayed, and optionally details on the problems are saved to file. 
#' The problem file contains all the input data, any data extracted from labels, and a column highlighting problems such as non-existent samples. (Note that the dates, if given, are those extracted from the labels, not necessarily those that go in the Kotka upload!)
#'
#' The input data (`x`) must contain column "sample" or "label" (or be a vector of samples). If only "label" is given, samples and other data will be extracted from the labels, and added to 'x'. Existing data is not overwritten: creates a new column if one didn't exist, otherwise only fills in gaps in the column. 
#' 
#' The following columns of 'x', if present, are matched to their equivalents in Kotka:
#' * box
#' * date_begin
#' * date_end
#' * label
#' * sex
#' 
#' Any other columns are currently ignored.
#'
#' @param x One of the following:
#' * A data frame with column "sample" or "label", and optionally other columns. The samples will be used to fill in the Kotka upload. If labels are given, data is extracted from them with [get_labeldata()] and added to the data frame (without overwriting). 
#' * A vector, in which case it is assumed to contain sample IDs. 
#' @param nwasps How many wasps each label or sample corresponds to. Numeric vector of same length (or number of rows) as 'x', or of length 1. Default is "1", every label corresponds to a single wasp.
#' @param verify If TRUE (the default), checks the input data in `x`. See Details. 
#' @param upload_file File path where to save the Kotka upload. Default is to save "kotka_upload.csv" in the working directory + return the data frame invisibly. If NA, the Kotka upload will only be returned invisibly.
#' @param problems_file File path where to save problems identified by [verify_data()]. Default is to save "kotka_upload_problems.csv" in the working directory. If NA, problems are not saved to file.
#'
#' @return A data frame with the Kotka upload. \cr
#'  
#' @export
#'
#' @seealso [get_labeldata()] which gets data from labels, [verify_data()] which checks the data for problems.
#' 
#' @examples
#' # example labels 1
#' labels = c(  
#' "cct1-141022",  
#' "PERU, Allpahuayo 1.-15.12.2000, Sääksjärvi I.E I1/17 Occia sp. 1. ♀",  
#' "ECUADOR, Tiputini, 22. Oct 1998, Canopy fogging Lot# 1966 Meniscomorpha sp. 2",  
#' "cct1-141023 incorrect sample ID",  
#' "PERU, Allpahuayo 3.-16.12.2000, dates are wrong, Sääksjärvi I.E I1/17"
#' )
#' 
#' # save as data frame
#' x = data.frame(label=labels)
#'
#' # create upload but don't save to file
#' upload1 = make_upload(x, upload_file=NA, problems_file=NA)
#'
#'
#' # example labels 2 (real labels from Peru and Ecuador)
#' x = example_labels
#'
#' # create upload but don't save to file
#' upload2 = make_upload(x, upload_file=NA, problems_file=NA)
make_upload = function(x, nwasps=1, verify=TRUE, upload_file="kotka_upload.csv", problems_file="kotka_upload_problems.csv"){
	
	# if 'x' is a vector instead of a data frame, assume it contains samples
	if(is.vector(x)){
		x = data.frame(sample=x)
	}
	
	# if labels were given, get data from them and add to 'x'
	if("label" %in% colnames(x) ){
		
		# get data from labels
		X = get_labeldata(x$label)
		
		# add each column of label data to 'x'
		for (cname in colnames(X)){
			
			# if the user already gave this column, only add label data to any empty cells
			if (cname %in% colnames(x)){
				i = which( is.na(x[, cname]) | as.character(x[, cname])=="" )
				x[i, cname] = X[i, cname]
				
			# .. otherwise add the entire column of label data
			} else {
				x[, cname] = X[, cname]
			}
			
		}
		
	}
	
	# repeat each row 'nwasps' times
	if ( length(nwasps) == nrow(x) | length(nwasps) == 1 ){
		x = x[rep(1:nrow(x), nwasps), , drop=FALSE]
	} else {
		stop("'nwasps' should be the same length as the number of samples or labels, or of length 1.")
	}
	
	# convert samples to upper case to make sure they compare properly
	x$sample = toupper(x$sample)
	
	# verify input data
	if (verify){
		
		# check that samples exist and their dates match user-input dates
		x = verify_data(x)
		
		# if there are problems, show a warning message and (optionally) save problems to file
		if (sum(x$sample_problem != "") > 0){
			
			# tell how many rows of data have problems
			message(paste(sum(x$sample_problem != ""), "specimen(s) had incorrect sample IDs, or the sample dates do not match columns date_begin and date_end."))
			
			# write 'x' to file, with problems column included
			if (! is.na(problems_file)){
				utils::write.csv(x, problems_file, row.names=F, na="")
			}
				
		}	
		
	}
	
	# get a basic Kotka upload from template
	f = system.file("extdata", "kotka_template.csv", package = "wasps2kotka", mustWork = TRUE)
	k = utils::read.csv(f, colClasses = "character", check.names=F, nrows=2)
	
	# save 2nd header row, then remove it from 'k'
	# (Kotka inconveniently uses two header rows, ignore 2nd one until end of script)
	k2 = unlist(k[1, ])
	k = k[-1, ]
	
	# make 'k' the right size, fill with default data from template
	k[1:nrow(x), ] = k[1, ]
	
	# add data from 'x' (e.g. sex and dates extracted from labels)
	k = add_inputdata(k, x)
	
	# add Ecuadorian data from template to 'k'
	k = add_ecuadordata(k, x)
	
	# add Peruvian and Ugandan data from template and from sample data
	k = add_malaisedata(k, x)
	
	# make sure all the columns are character
	k[] = lapply(k, as.character)
	
	# return the 2nd header row (Kotka uses two header rows)
	k = rbind(k2, k)
	
	# save as file
	if(! is.na(upload_file)){
		utils::write.csv(k, upload_file, row.names=F, na="")
	}
	
	# return
	invisible(k)
	
}