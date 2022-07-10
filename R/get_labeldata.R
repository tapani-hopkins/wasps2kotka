#' Extract data from wasp labels
#'
#' Extract dates, sample ID and other data from the wasp labels typically found at the museum. Handles wasp labels from the Malaise trapping in Peru (1998-2011), and from the canopy fogging in Ecuador. Can also recognise sample IDs from the Malaise trapping in Uganda (2014-2015). The resulting data frame can be used as is, or as the basis for creating a Kotka upload.
#'
#' @param lab A character vector of label texts.
#'
#' @return A data frame with the labels and the data extracted from them. 
#' @export
#'
#' @seealso [verify_labeldata()] which checks the results, [make_kotkaupload()] which creates a Kotka upload file out of the returned (and optionally verified) data frame.
#' 
#' @examples
#' lab = c(  
#' "cct1-141022",  
#' "h1/1",  
#' "PERU, Allpahuayo 1.-15.12.2000, Sääksjärvi I.E I1/17",  
#' "ECUADOR, Tiputini, 22. Oct 1998, Canopy fogging Lot# 1966 Meniscomorpha sp. 2"  
#' )
#' x = get_labeldata(lab)
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
	samples = wasps2kotka::malaise_samples

	# convert sample dates to Date objects
	samples$date_begin = as.Date(samples$date_begin, format="%d.%m.%Y")
	samples$date_end = as.Date(samples$date_end, format="%d.%m.%Y")

	# get 1998 and 2000 samples from the labels
	for (s in which(samples$event=="Amazon1998" | samples$event=="Amazon2000")){	
		# search for this sample (e.g. "H1/17") in the labels
		l = grep(samples$sample_1998_2000[s], x$label, ignore.case=T)
		
		# save to 'x' in standard format (e.g. "h1-17")
		x$sample[l] = samples$sample[s]
	}
	
	# get 2008 and 2011 samples from the labels
	for (s in which(samples$event=="Amazon2008" | samples$event=="Amazon2011")){	
		# search for "Gómez" in the labels
		l0 = grepl("G\u00F3mez", x$label)
		
		# search for this trap (e.g. "Malaise 2") in the labels
		l1 = grepl(samples$trap_2008_2011[s], x$label, ignore.case=T)
		
		# search for this end date (e.g. "2008-06-05") in the labels
		l2 = grepl(samples$date_end[s], x$date_end, ignore.case=T)
		
		# only get labels that match all the above
		l = which(l0 & l1 & l2)
		
		# save to 'x' in standard format (e.g. "la2-2")
		x$sample[l] = samples$sample[s]
	}
	
	# get Ugandan samples from the labels
	for (s in which(samples$event=="Uganda2014")){	
		# search for this sample (e.g. "R93T2-141009") in the labels
		l = grep(samples$sample[s], x$label, ignore.case=T)
		
		# save to 'x'
		x$sample[l] = samples$sample[s]
	}
	
	# return the labels and corresponding data
	return(x)
}