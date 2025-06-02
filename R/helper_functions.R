#' Add problem messages to a vector
#'
#' This is a helper function used by [verify_data()]. Adds any problem messages of a wasp label to a character vector, so that new problem messages go on a new line.  
#'
#' @param x Character vector of existing problem messages.
#' @param what Character string detailing the problem. Added to every item of `x`.
#'
#' @return The input vector (`x`) with the message added to each item. 
#'
#' @seealso [verify_data()]
add = function(x, what=""){
	
	# check which items of x are blank
	i = is.na(x) | x == ""
	
	# add the problem message as is to blank items, but on a new line if there's already text there
	x[i] = what
	x[!i] = paste0(x[!i], "\n", what)
	
	# return
	return(x)
}


#' Add Ecuadorian data to Kotka upload
#'
#' This is a helper function used by [make_upload()]. Adds basic Ecuadorian data to a Kotka upload. Recognises Ecuadorian wasps by looking at the labels.
#'
#' @param k A data frame containing the Kotka upload. 
#' @param x A data frame containing the user input. If there is no column "label", this function does nothing.
#'
#' @return The data frame containing the Kotka upload (`k`) with Ecuadorian data added.
#'
#' @seealso [make_upload()]
add_ecuadordata = function(k, x){
	
	# do nothing if there is no column "label"
	if ("label" %in% colnames(x)){	
	
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
	
	}
	
	# return
	return(k)
}


#' Add user-input data to Kotka upload
#'
#' This is a helper function used by [make_upload()]. Adds data columns input by the user to a Kotka upload. Ignores column "sample", tries to find the right Kotka column for everything else.
#'
#' Any columns that can't be matched to a Kotka column are ignored.
#' 
#' @param k A data frame containing the Kotka upload. 
#' @param x A data frame containing the user input.
#'
#' @return The data frame containing the Kotka upload (`k`) with user input added to the matching columns.
#'
#' @seealso [make_upload()]
add_inputdata = function(k, x){
	
	# get data frame which tells what user input matches what Kotka column
	f = system.file("extdata", "input_field_kotka_equivalents.csv", package = "wasps2kotka", mustWork = TRUE)
	equivalents = utils::read.csv(f, colClasses = "character", check.names=F)
	
	# get all column names except for "sample"
	cnames = colnames(x)
	cnames = cnames[! cnames %in% c("sample")]
	
	# add the user input to 'k'
	for (cname in cnames){
		
		# check this column has an equivalent in Kotka
		if (cname %in% equivalents$input){
			
			# find out what this column is called in Kotka
			kname = equivalents$kotka[equivalents$input == cname]
		
			# get rows that are not empty
			i = which(! is.na(x[, cname]) & as.character(x[, cname]) != "")
		
			# add the non-empty rows to the correct column in 'k'
			k[i, kname] = as.character(x[i, cname])
		
		}
				
	}
	
	# return
	return(k)
}


#' Add Peruvian and Ugandan data to Kotka upload
#'
#' This is a helper function used by [make_upload()]. Adds data on Peruvian and Ugandan wasps caught by Malaise trapping to a Kotka upload. Adds basic data from a template file, and sample data by matching each wasp's sample ID with the sample it came from. 
#'
#' @param k A data frame containing the Kotka upload. 
#' @param x A data frame containing the user input. If there is no column "sample", this function does nothing.
#' @param subsample If TRUE, gives data for subsamples instead of for individual pinned insects.
#'
#' @return The data frame containing the Kotka upload (`k`) with Peruvian and Ugandan data added.
#'
#' @seealso [make_upload()], and [read()] which is used by this function
add_malaisedata = function(k, x, subsample=FALSE){
	
	# do nothing if there is no column "sample" in the input data
	if ("sample" %in% colnames(x)){
		
		# load the Malaise sample data
		# (in two files: Kotka format, and overview file)
		m_kotka = wasps2kotka::m_kotka
		m = wasps2kotka::m
		
		# convert samples to upper case, to make sure they compare OK
		m_kotka$"MYOriginalSpecimenID" = toupper(m_kotka$"MYOriginalSpecimenID")
		m$sample = toupper(m$sample)
		x$sample = toupper(x$sample)
	
		# overwrite the datasets with those of the overview file
		# (the Kotka data contains irrelevant datasets)
		i = match(m_kotka$"MYOriginalSpecimenID", m$sample)
		m = m[i, ]
		dcols = c("MYDatasetID[0]", "MYDatasetID[1]", "MYDatasetID[2]", "MYDatasetID[3]")
		m_kotka[dcols] = m[dcols]
	
		# load the data frame that tells what columns of sample data should be copied to the Kotka upload
		f = system.file("extdata", "kotka_desired_malaise_sample_columns.csv", package = "wasps2kotka", mustWork = TRUE)
		what_cols = read(f, 0)[,1]
	
		# add the dataset columns
		what_cols = c(what_cols, dcols)
	
		# load Kotka template for Malaise data (=data shared by all Malaise samples)
		f = system.file("extdata", "kotka_template_malaise.csv", package = "wasps2kotka", mustWork = TRUE)
		kotka_template = read(f, 2)
		
		# load Kotka template for subsample data (=data shared by all subsamples of Malaise samples)
		f = system.file("extdata", "kotka_template_subsample.csv", package = "wasps2kotka", mustWork = TRUE)
		subsample_template = read(f, 2)
	
		# find the specimens which are from Peruvian, Ugandan, or other Malaise samples
		i = which(x$sample %in% m$sample)
	
		# get the index of the corresponding samples
		s = match(x$sample[i], m_kotka$"MYOriginalSpecimenID")	
	
		# copy the default data (shared by all samples) from the Kotka template to 'k'
		cols = which(kotka_template[1, ] != "")
		k[i, cols] = kotka_template[, cols]
	
		# copy the sample data to 'k'
		k[i, what_cols] = m_kotka[s, what_cols]
		
		# overwrite some columns with subsample data if this is a subsample
		if (subsample){
			cols = which(subsample_template[1, ] != "")
			k[i, cols] = subsample_template[, cols]
		}
	
		# add the sample the specimen came from to 'k'
		sampleID = m_kotka$"MYObjectID"[s]
		sampleID = paste0("http://mus.utu.fi/ZMUT.", sampleID)
		k$"MYSeparatedFrom"[i] = sampleID
	
	}
	
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
#' @return A data frame with two columns, giving the start and end dates as strings in Kotka format (e.g. "04.12.1998").
#'
#' @seealso [get_labeldata()], and [getreg()] and [get_d_begin()] which are used by this function
get_dates = function(lab){
			
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
	
	# convert start and end dates to Kotka format (e.g. "04.09.1998")
	d_begin = format(d_begin, "%d.%m.%Y")
	d_end = format(d_end, "%d.%m.%Y")

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
	
	# first read the column names from the first row
	cnames = utils::read.csv(file, header=F, colClasses="character", check.names=F, nrows=1, ...)
	
	# then read the contents of the file, ignoring header rows, and add the column names
	a = utils::read.csv(file, header=F, colClasses="character", check.names=F, blank.lines.skip=F, skip=nheaders, col.names=cnames, ...)
	
	# return
	return(a)
	
}


#' Verify specimen data
#'
#' This is a helper function used by [make_upload()] and [get_labeldata()]. Checks that the data they are handling looks right, and highlights any problems.
#'
#' Any problems, such as samples not existing or sample dates not matching dates on the label, will be added to a separate column to the data. 
#'
#' @param x A data frame, e.g. that created by [get_labeldata()] or received by [make_upload()]. Must include column "sample".
#'
#' @return The input data frame with extra column "sample_problem". 
#'
#' @seealso [get_labeldata()] whose data this function checks, [make_upload()] which creates a Kotka upload file out of the returned data frame.
verify_data = function(x){
	
	# load the sample list
	m = wasps2kotka::m
	
	# convert samples to upper case, to make sure they compare ok
	x$sample = toupper(x$sample)
	m$sample = toupper(m$sample)
		
	# check which samples exist (=not NA, missing or a mistype)
	sample_exists = x$sample %in% m$sample
	
	# create a column for messages about problems
	x$sample_problem = ""
		
	# find samples which do not exist (typically these are mistyped sample IDs)
	i = which(! sample_exists & ! is.na(x$sample))
	x$sample_problem[i] = add(x$sample_problem[i], "Sample does not exist.")		
		
	# find samples whose collecting dates do not match columns "date_begin" and "date_end"
	if (all(c("date_begin", "date_end") %in% colnames(x))){
		
		# get the valid samples in 'x' and what row they match in the sample list 
		i = sample_exists & !is.na(x$date_begin) & !is.na(x$date_end)
		s = match(x$sample[i], m$sample)
			
		# find specimens whose sample collecting dates don't match user input dates
		mmb = which(x$date_begin[i] != m$date_begin[s])
		mme = which(x$date_end[i] != m$date_end[s])
			
		# add to column 'sample_problem'
		x$sample_problem[i][mmb] = add(x$sample_problem[i][mmb], "Given start date does not match sample's start date.")
		x$sample_problem[i][mme] = add(x$sample_problem[i][mme], "Given end date does not match sample's end date.")
			
	}
	
	# return
	return(x)
	
}
