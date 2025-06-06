% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/documentation_package_and_data.R
\docType{package}
\name{wasps2kotka-package}
\alias{wasps2kotka}
\alias{wasps2kotka-package}
\title{wasps2kotka: Get wasp data from labels or sample identifiers, and upload to the Kotka database}
\description{
Functions for use at the Zoological Museum of the University of Turku. Mainly used to get data from wasp labels or from wasp sample IDs, and then create a csv file for uploading the data to the Kotka database. Works with the large wasp collections at Turku: wasps collected by Malaise trapping in Peru and Uganda, wasps collected by canopy fogging in Ecuador, and wasps collected in Skanssi, Finland.
}
\details{
Typical usage is one of the following:
\itemize{
\item Write down the sample which wasps came from, and create an upload file for the wasps with \code{\link[=make_upload]{make_upload()}}.
\item Write down the wasp labels, then use \code{\link[=make_upload]{make_upload()}} to extract data from the labels and create an upload file for the wasps.
}

Before using, you will need to load the label texts or sample identifiers to R. Typically this will be by reading a text file, or a csv file you've exported from Excel.

After you've got the upload file, you'll need to add any missing fields. It is also worth checking if any problems occurred: the script highlights any incorrect sample identifiers or date mismatches between labels and samples.
}
\examples{
# example labels
labels = c(  
"cct1-141022",  
"PERU, Allpahuayo 1.-15.12.2000, Sääksjärvi I.E I1/17 Occia sp. 1. ♀ ",  
"ECUADOR, Tiputini, 22. Oct 1998, Canopy fogging Lot# 1966 Meniscomorpha sp. 2 ♀ ",  
"cct1-141023 incorrect sample ID",  
"PERU, Allpahuayo 3.-16.12.2000, dates are wrong, Sääksjärvi I.E I1/17"
)

# example data on sex (note that wasp 2 contradicts label)
sex = c("F", "M", NA, NA, NA)

# save data
x = data.frame(label=labels, sex=sex)

# create a Kotka upload for these wasps (but do not save to file)
upload = make_upload(x, upload_file=NA, problems_file=NA)
upload
}
\seealso{
Useful links:
\itemize{
  \item \url{https://github.com/tapani-hopkins/wasps2kotka}
  \item Report bugs at \url{https://github.com/tapani-hopkins/wasps2kotka/issues}
}

}
\author{
\strong{Maintainer}: Tapani Hopkins \email{tapani-hopkins@users.noreply.github.com} (\href{https://orcid.org/0000-0002-2256-0098}{ORCID})

}
\keyword{internal}
