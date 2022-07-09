#' Extract data from wasp labels
#'
#' Extract dates, sample ID and other data from the wasp labels typically found at the museum. Handles wasp labels from the Malaise trapping in Peru (1998-2011), and from the canopy fogging in Ecuador. The resulting data frame can be used as is, or used as the basis for creating a Kotka upload.
#'
#' @param lab A character vector of label texts.
#'
#' @return A data frame with the labels and corresponding data. 
#' @export
#'
#' @seealso [verify_labeldata()] which checks the results, [make_kotkaupload()] which creates a Kotka upload file out of the returned (and optionally verified) data frame.
#' 
#' @examples
#' \dontrun{
#' lab = c(  
#' "cct1-141022",  
#' "h1/1",  
#' "PERU, Allpahuayo 1.-15.12.2000, Sääksjärvi I.E I1/17",  
#' "ECUADOR, Tiputini, 22. Oct 1998, Canopy fogging Lot# 1966 Meniscomorpha sp. 2"  
#' )
#' x = get_labeldata(lab)
#' }
get_labeldata = function(lab){
	# Extracts dates, sample and other data from wasp labels.
	# Uses function 'get_dates'.
	# Returns the labels and corresponding data as a data frame.
	#  lab  vector of label texts
	
	# create a data frame for the labels and corresponding data
	x = data.frame(label=lab, sample=NA, sex=NA)
	
	# get the start & end dates from the labels, add to 'x'
	x = cbind(x, get_dates(x$label))
	
	# get the sexes from the labels
	# NA for labels without female or male symbols, and for labels with both.
	f = grep("\u2640", x$label)
	m = grep("\u2642", x$label)
	x$sex[f] = "F"
	x$sex[m] = "M"
	x$sex[intersect(f, m)] = NA
	
	# load the sample list
	f = system.file("extdata", "malaise_samples.csv", package = "wasps2kotka")
	samples = utils::read.csv(f, as.is=T)

	# convert sample dates to Date objects
	samples$date_begin = as.Date(samples$date_begin, format="%d.%m.%Y")
	samples$date_end = as.Date(samples$date_end, format="%d.%m.%Y")

	# get 1998 and 2000 samples from the labels
	for (s in 1:nrow(samples)){	
		# search for this sample (e.g. "H1/17") in the labels
		l = grep(samples$sample_1998_2000[s], x$label, ignore.case=T)
		
		# save to 'x' in standard format (e.g. "h1-17")
		x$sample[l] = samples$sample[s]
	}
	
	# get 2008 and 2011 samples from the labels
	# (by finding "Gómez" and comparing end dates to sample list)
	# (note: this only works if no two samples have the same end date)
	g = grep("G\u00F3mez", x$label)
	i = match(x$date_end[g], samples$date_end)
	x$sample[g] = samples$sample[i]
	
	# return the labels and corresponding data
	return(x)
}