#' Load malaise sample data when the package is loaded
#'
#' Loads the Malaise sample data so that the package's code and the user can see it. The sample data is in two csv files in the package's external data, reads both of them and saves as 'm' (list of samples with basic data) and 'm_kotka' (complete sample data in Kotka format)
#'
#' @param libname Not used, there only to make sure this function is called properly when the package is loaded.
#' @param pkgname Not used, there only to make sure this function is called properly when the package is loaded.
#'
.onLoad = function(libname, pkgname){
	
	# load the sample list
	f = system.file("extdata", "malaise_samples.csv", package = "turkuwasps", mustWork = TRUE)
	#f = "inst/extdata/malaise_samples.csv"
	m = utils::read.csv(f, colClasses = "character", check.names=FALSE)
	
	# load the complete sample data in Kotka format
	f = system.file("extdata", "malaise_samples_kotka_format.csv", package = "turkuwasps", mustWork = TRUE)
	#f = "inst/extdata/malaise_samples_kotka_format.csv"
	m_kotka = utils::read.csv(f, colClasses = "character", check.names=FALSE)
	
	# save these as variables that the package code and the user can see
	assign('m', m, envir = topenv())
	assign('m_kotka', m_kotka, envir = topenv())
	
}