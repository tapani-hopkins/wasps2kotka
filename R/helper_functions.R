#' Add any problems to the problem list
#'
#' This is a helper function used by [verify_labeldata()]. Add any problem messages of a wasp label to the list of problems.  
#'
#' @param problems A list of character vectors, with one list item per label. Each vector item is a separate problem.
#' @param add The string to be added to the each vector in the list. This will be some kind of message detailing the problem.
#'
#' @return The input list (`problems`) with the message added to each list item. 
#'
#' @seealso [verify_labeldata()]
add = function(problems, add=""){
	# Adds any problems to the problem list
	# Helper function for 'verify_labeldata'.
	# Returns the problem list with problem text added to each list item
	#  problems  list of character vectors, each vector item a separate problem
	#  add  the text to add to each item of the list, stating what the problem is
	
	# add problem text to the list
	problems = lapply(problems, c, add)
	
	# return
	return(problems)
}


#' Add Ecuadorian data to Kotka upload
#'
#' This is a helper function used by [make_kotkaupload()]. Add basic Ecuadorian data to a Kotka upload.  
#'
#' @param k A data frame containing the Kotka upload. 
#' @param x A data frame returned by [get_labeldata()] or [verify_labeldata()].
#'
#' @return The data frame containing the Kotka upload (`k`) with Ecuadorian data added.
#'
#' @seealso [make_kotkaupload()]
add_ecuadordata = function(k, x){
	# Adds basic Ecuadorian data to a Kotka upload.
	# Helper function for 'make_kotkaupload'.
	# Returns the Kotka upload with Ecuadorian data added.
	#  k  data frame in Kotka upload format
	#  x  data frame returned by 'get_labeldata'
	
	# load Kotka template for Ecuador data
	f = system.file("extdata", "kotka_template_Ecuador.csv", package = "wasps2kotka", mustWork = TRUE)
	kotka_template = utils::read.csv(f, row.names=1, colClasses = "character", check.names=F)
	
	# find Ecuadorian Tiputini and Onkone Gare labels 
	# (make sure they are canopy fogging)
	fog = grepl("Canopy fog", x$label, ignore.case=T)
	tip = grepl("Tiputini", x$label, ignore.case=T) & fog
	onk = grepl("Onkone Gare", x$label, ignore.case=T) & fog
	
	# check which columns of the template contain data
	i = which(kotka_template["tiputini", ] != "")
	tipcols = names(kotka_template)[i]
	i = which(kotka_template["onkone", ] != "")
	onkcols = names(kotka_template)[i]
	
	# copy the Ecuadorian template data to 'k' 	
	k[tip, tipcols] = kotka_template["tiputini", tipcols]
	k[onk, onkcols] = kotka_template["onkone", onkcols]
	
	# return
	return(k)
}


#' Add Peruvian and Ugandan data to Kotka upload
#'
#' This is a helper function used by [make_kotkaupload()]. Add data on Peruvian and Ugandan wasps caught by Malaise trapping to a Kotka upload. Add basic data from a template file, and sample data by matching each wasp's sample ID with the sample it came from. 
#'
#' @param k A data frame containing the Kotka upload. 
#' @param x A data frame returned by [get_labeldata()] or [verify_labeldata()].
#'
#' @return The data frame containing the Kotka upload (`k`) with Peruvian and Ugandan data added.
#'
#' @seealso [make_kotkaupload()], and [read()] which is used by this function
add_malaisedata = function(k, x){
	# Adds data on the Peruvian and Ugandan Malaise samples to a Kotka upload
	# Uses helper function 'read'.
	# Used by 'make_kotkaupload'
	# Returns the Kotka upload with Malaise sampling data added.
	#  k  data frame in Kotka upload format
	#  x  data frame returned by 'get_labeldata'
	
	# load the Malaise sample data
	# (in two files: Kotka format, and overview file)
	samples = wasps2kotka::malaise_samples_kotka_format
	samples2 = wasps2kotka::malaise_samples
	
	# overwrite the datasets with those of the overview file
	# (the Kotka data contains irrelevant datasets)
	i = match(samples$"MYOriginalSpecimenID", samples2$sample)
	samples2 = samples2[i, ]
	dcols = c("MYDatasetID[0]", "MYDatasetID[1]", "MYDatasetID[2]", "MYDatasetID[3]")
	samples[dcols] = samples2[dcols]
	
	# load the columns of sample data which should be copied to the Kotka upload
	# add the dataset columns
	f = system.file("extdata", "kotka_desired_malaise_sample_columns.csv", package = "wasps2kotka", mustWork = TRUE)
	what_cols = read(f, 0)[,1]
	what_cols = c(what_cols, dcols)
	
	# load Kotka template for Malaise data (=data shared by all samples)
	f = system.file("extdata", "kotka_template_malaise.csv", package = "wasps2kotka", mustWork = TRUE)
	kotka_template = read(f, 2)
	
	# find the specimens which are from Peruvian or Ugandan Malaise samples,
	# and the index of the corresponding samples
	malaise = !is.na(x$sample)
	s = match(tolower(x$sample[malaise]), tolower(samples$"MYOriginalSpecimenID"))	
	
	# copy the default data (shared by all samples) from the Kotka template to 'k'
	cols = which(kotka_template[1, ] != "")
	k[malaise, cols] = kotka_template[, cols]
	
	# copy the sample data to 'k'
	k[malaise, what_cols] = samples[s, what_cols]
	
	# add the sample the specimen came from to 'k'
	sampleID = samples$"MYObjectID"[s]
	sampleID = paste0("http://mus.utu.fi/ZMUT.", sampleID)
	k$"MYSeparatedFrom"[malaise] = sampleID
	
	# return
	return(k)
	
}


#' Get the start date from Peruvian wasp labels
#'
#' This is a helper function used by [get_dates()]. Figure out what the start date is for Peruvian labels, whose date is typically written along the lines of *1.-15.12.2000*.  
#'
#' @param x A string giving the collecting dates of a Peruvian label (e.g. *1.-15.12.2000*). 
#' @param d_end An object of class `Date` giving the end date (e.g. *2000-12-15*). This is used to get the start month and year if they are not written out in full. 
#'
#' @return An object of class `Date` giving the start date.
#'
#' @seealso [get_dates()]
get_d_begin = function(x, d_end){
	# Gets the start date from dates of the Peruvian format (e.g. "1.-15.12.2000").
	# Helper function for 'get_dates'
	# Returns the start date as a Date object.
	#  x  date as a string  (e.g. "1.-15.12.2000")
	#  d_end  end date as a Date object (e.g. "2000-12-15"), this is used to get the month and year if need be.
	
	# get everything before the "-"
	d_begin = getreg(".+-", x)

	# remove trailing "-"
	d_begin = substr(d_begin, 1, nchar(d_begin)-1)
	
	# split by full stops (e.g. "17.12." becomes 17 and 12)
	dlist = strsplit(d_begin, "\\.")

	for (i in 1:length(dlist)){
	
		# if only the day is given, get month and year from the end date
		if (length(dlist[[i]])==1){
			d = dlist[[i]]
			D = paste0(format(d_end[i], "%Y-%m-"), d)
		
		# if only the day and month are given, get year from the end date
		} else if (length(dlist[[i]])==2){
			d = dlist[[i]][1]
			m = dlist[[i]][2]
			D = paste0(format(d_end[i], "%Y-"), m, "-", d)
		
		# get year, month, and day if all are given
		} else if (length(dlist[[i]])==3){
			d = dlist[[i]][1]
			m = dlist[[i]][2]
			Y = dlist[[i]][3]
			D = paste0(Y, "-", m, "-", d)
	
		# blank if could not get any of day, month, year
		} else {
			D = ""
		}
	
		# save this start date
		d_begin[i] = D
	
	}

	# convert to Date object 
	d_begin = as.Date(d_begin)

	return(d_begin)
}


#' Get dates from Peruvian or Ecuadorian wasp labels
#'
#' This is a helper function used by [get_labeldata()]. Extract those strings in Peruvian and Ecuadorian labels which represent dates (e.g. *1.-15.12.2000* or *22. Oct 1998*).  
#'
#' @param lab A character vector of label texts. 
#'
#' @return A data frame with two columns, giving the start and end dates as objects of class `Date`.
#'
#' @seealso [get_labeldata()], and [getreg()] and [get_d_begin()] which are used by this function
get_dates = function(lab){
	# Extract the dates from Peruvian or Ecuadorian museum labels.
	# Uses helper functions 'getreg' and 'get_d_begin'.
	# Used by function 'get_labeldata'.
	# Returns the start and end dates as a data frame.	
	#  lab  vector of label texts
			
	# get typical Peruvian dates from the labels as string
	# e.g. "1.-15.12.2000"
	dates = getreg("[0-9,\\.,-]+\\.[0-9]{4}", lab)
	
	# save end dates (NA for labels without Peruvian format dates)
	d_end = getreg("-.+", dates)
	d_end = as.Date(d_end, format="-%d.%m.%Y")
	
	# save start dates (NA for labels without Peruvian format dates)
	d_begin = get_d_begin(dates, d_end)
	
	# get typical Ecuadorian dates from the labels as string
	# e.g. "22. Oct 1998" or "5. July 1998"
	dates = getreg("[0-9,.]{1,3} [a-z,A-Z]{3,4} [0-9]{4}", lab)
	
	# remove full stops and convert to date format
	dates = sub("\\.", "", dates)
	dates = as.Date(dates, format="%d %b %Y")
	
	# save those start dates which are in Ecuadorian format
	# (Ecuadorian samples were collected in one day, so no end date)
	valid = which(!is.na(dates))
	d_begin[valid] = dates[valid]

	# return as data frame		
	return(data.frame(date_begin=d_begin, date_end=d_end))
}


#' Get strings which match a regular expression
#'
#' This is a helper function used by [get_dates()] to extract dates from labels. Look for matches to a regular expression in text, return the strings that match.  
#'
#' @param reg A string containing a regular expression. 
#' @param x A string or character vector to search with the regular expression. 
#'
#' @return A string or character vector giving the string(s) that matched the regular expression.
#'
#' @seealso [get_dates()], and [regexpr()] which this is largely a wrapper for
getreg = function(reg, x){
	# Gets the text that matches a regular expression
	# Helper function for 'get_dates'
	#  reg  regular expression as string or character vector
	#  x  string or character vector to search with the regular expression
	
	# get index where the substring starts, and string length
	i = regexpr(reg, x)
	
	# get the substring
	res = substr(x, i, i + attr(i, "match.length")-1)
	
	return(res)
}


#' Read csv files that have multiple headers
#'
#' This is a helper function used by [add_malaisedata()]. Help read the kind of csv files typically used by Kotka, which contain more than one header row (and are otherwise hard to read with [utils::read.csv()]). Any extra header rows are discarded. 
#'
#' @param file The name of the file to be read from. 
#' @param nheaders An integer giving the number of header rows in the file. Only the first header row will be kept. 
#' @param ... Further arguments to be passed to [utils::read.csv()].
#'
#' @return A data frame with the contents of the file.
#'
#' @seealso [add_malaisedata()], and [utils::read.csv()] which this is a wrapper for
read = function(file, nheaders=2, ...){
	# Reads csv files
	# Helper function for 'add_malaisedata'
	# Returns the file as a data frame.
	#  file  name of the file to be read
	#  nheaders  Number of rows of header. First header row will be used, others discarded.
	
	# first read the column names from the first row
	cnames = utils::read.csv(file, header=F, colClasses="character", check.names=F, nrows=1, ...)
	
	# then read the contents of the file, ignoring header rows, and add the column names
	a = utils::read.csv(file, header=F, colClasses="character", check.names=F, blank.lines.skip=F, skip=nheaders, col.names=cnames, ...)
	
	# return
	return(a)
	
}