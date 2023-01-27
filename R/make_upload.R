#' Create a file for uploading wasp data to the Kotka database
#'
#' Creates a Kotka upload file out of the data given to it. The data can e.g. be a data frame given by [get_labeldata()], or a vector of sample IDs. 
#'
#' Handles wasps from the Malaise trapping in Uganda (2014-2015) and Peru (1998-2011), and from the canopy fogging in Ecuador. Other specimens will be included in the upload, but will only have minimal data.  
#'
#' Verification is handled by [verify_data()]. Checks that the samples actually exist. If columns "date_begin" and "date_end" were given, also checks they match the sample collecting dates. If there are problems, a message is displayed, and optionally details on the problems are saved to file.
#'
#' The input data (`x`) must contain column "sample" (or be a vector). The following columns, if present, are matched to their equivalents in Kotka:
#' * box
#' * date_begin
#' * date_end
#' * label
#' * sex
#' 
#' Any other columns are ignored.
#'
#' @param x A data frame with column "sample" and optionally other columns, e.g. as returned by [get_labeldata()]. Can also be a vector, in which case it is assumed to contain sample IDs. 
#' @param verify If TRUE (the default), checks the input data in `x`. See Details. 
#' @param upload_file File path where to save the Kotka upload. Default is to save "kotka_upload.csv" in the working directory + return the data frame invisibly. If NA, the Kotka upload will only be returned invisibly.
#' @param problems_file File path where to save problems identified by [verify_data()]. Default is to save "kotka_upload_problems.csv" in the working directory. If NA, problems are not saved to file.
#'
#' @return A data frame with the Kotka upload. \cr
#'  
#' @export
#'
#' @seealso [get_labeldata()] which extracts the data used by this function, [verify_data()] which checks the extracted data for problems.
#' 
#' @examples
#' lab = c("cct1-141022", 
#' "PERU 1.-15.12.2000 I1/17", 
#' "Not a wasp label at all", 
#' "PERU 1.-16.12.2000 wrong date for I1/17", 
#' "cct1-141023 non-existent sample")
#' x = get_labeldata(lab)
#' upload = make_upload(x, upload_file=NA, problems_file=NA)
make_upload = function(x, verify=TRUE, upload_file="kotka_upload.csv", problems_file="kotka_upload_problems.csv"){
	
	# if 'x' is a vector instead of a data frame, assume it contains samples
	if(is.vector(x)){
		x = data.frame(sample=x)
	}
	
	# convert samples to upper case to make sure they compare properly
	x$sample = toupper(x$sample)
	
	# verify input data
	if (verify){
		
		# check that samples exist and their dates match user-input dates
		x = verify_data(x, check_missing=FALSE, check_sample=TRUE)
		
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