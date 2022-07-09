#' Verify data extracted from wasp labels
#'
#' Check that the data extracted by [get_labeldata()] looks right, and highlight any problems.  
#'
#' Typically used before feeding in the data to function [make_kotkaupload()]. Any problems will be added as a separate column to the data. When the Kotka upload file has been made, it is easy to skim through the problem column and fix any issues before uploading. 
#' Checks include: 
#' - That a start date was extracted and the dates match the sample the wasp came from.
#' - That the wasp came from a recognised Peruvian or Ugandan Malaise sample, or from Ecuadorian canopy fogging. (If not, most data will be blank.)
#' - That the sex of the wasp (male/female) was detected. 
#'
#' @param x A data frame returned by [get_labeldata()].
#'
#' @return The input data frame with an extra column `problems`. 
#' @export
#'
#' @seealso [get_labeldata()] whose data this function checks, [make_kotkaupload()] which creates a Kotka upload file out of the returned data frame.
#' 
#' @examples
#' \dontrun{
#' lab = c("cct1-141022", "PERU 1.-15.12.2000 I1/17")
#' x = get_labeldata(lab)
#' x = verify_labeldata(x)
#' }
verify_labeldata = function(x){
	# Checks that data extracted from labels looks right.
	# Uses helper function 'add'
	# Returns the data with an extra column highlighting any problems.
	#  x  data frame returned by 'get_labeldata'
	
	# load the sample list, convert dates to date object
	f = system.file("extdata", "malaise_samples.csv", package = "wasps2kotka")
	samples = utils::read.csv(f, as.is=T)
	samples$date_begin = as.Date(samples$date_begin, format="%d.%m.%Y")
	samples$date_end = as.Date(samples$date_end, format="%d.%m.%Y")
	
	# create empty list for saving any problems
	problems = vector("list", length=nrow(x))
	
	# sex is missing
	i = is.na(x$sex)
	problems[i] = add(problems[i], "uncertain sex")
	
	# start date is missing
	i = is.na(x$date_begin)
	problems[i] = add(problems[i], "missing start date")
	
	# end date is missing for a Peruvian or Ugandan wasp
	i = is.na(x$date_end) & !is.na(x$sample)
	problems[i] = add(problems[i], "missing end date")
	
	# dates on label do not match dates in sample data
	i = !is.na(x$sample)
	s = match(x$sample[i], samples$sample)
	datesmatch_begin = x$date_begin[i] == samples$date_begin[s]
	datesmatch_end = x$date_end[i] == samples$date_end[s]
	ii = which(!datesmatch_begin | !datesmatch_end)
	problems[i][ii]= add(problems[i][ii], "label dates do not match those of sample")
	
	# not a Peruvian, Ugandan or Ecuadorian wasp (cannot get data)
	peru_uganda = !is.na(x$sample)
	fog = grepl("ECUADOR.+Canopy fog", x$label, ignore.case=T)
	i = !peru_uganda & !fog
	problems[i] = add(problems[i], "not from Malaise sample or Ecuador canopy fogging")
	
	# collapse the problems so there is one text per row of 'x'
	# (blank if no problems)
	problems = lapply(problems, paste0, collapse="\n")
	problems = unlist(problems)
	
	# add the problems to the start of 'x'
	X = cbind(problems, x)
	
	return(X)
}
