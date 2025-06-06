% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_upload.R
\name{make_upload}
\alias{make_upload}
\title{Create a file for uploading wasp data to the Kotka database}
\usage{
make_upload(
  x,
  nwasps = 1,
  verify = TRUE,
  subsample = FALSE,
  upload_file = "kotka_upload.csv",
  problems_file = "kotka_upload_problems.csv"
)
}
\arguments{
\item{x}{One of the following:
\itemize{
\item A data frame with column "sample" or "label", and optionally other columns. The samples will be used to fill in the Kotka upload. If labels are given, data is extracted from them with \code{\link[=get_labeldata]{get_labeldata()}} and added to the data frame (without overwriting).
\item A vector, in which case it is assumed to contain sample IDs.
}}

\item{nwasps}{How many wasps each label or sample corresponds to. Numeric vector of same length (or number of rows) as 'x', or of length 1. Default is "1", every label corresponds to a single wasp.}

\item{verify}{If TRUE (the default), checks the input data in \code{x}. See Details.}

\item{subsample}{If TRUE, gives an upload for subsamples, e.g. jars of wasps or miscellaneous insects separated from the Ugandan and Peruvian Malaise samples. Default is FALSE: gives data for individual specimens, typically pinned wasps.}

\item{upload_file}{File path where to save the Kotka upload. Default is to save "kotka_upload.csv" in the working directory + return the data frame invisibly. If NA, the Kotka upload will only be returned invisibly.}

\item{problems_file}{File path where to save problems identified by \code{\link[=verify_data]{verify_data()}}. Default is to save "kotka_upload_problems.csv" in the working directory. If NA, problems are not saved to file.}
}
\value{
A data frame with the Kotka upload. \cr
}
\description{
Creates a Kotka upload file out of the data given to it. The data can e.g. be a data frame with labels, or a vector of sample identifiers.
}
\details{
Handles wasps from the Malaise trapping in Uganda (2014-2015), Peru (1998-2011) and other collecting events in the sample data (e.g. Skanssi2024), and from the canopy fogging in Ecuador. Other specimens will be included in the upload, but will only have minimal data.

Verification is handled by \code{\link[=verify_data]{verify_data()}}. Checks that the samples actually exist. If columns "date_begin" and "date_end" were given, also checks they match the sample collecting dates. If there are problems, a message is displayed, and optionally details on the problems are saved to file.
The problem file contains all the input data, any data extracted from labels, and a column highlighting problems such as non-existent samples. (Note that the dates, if given, are those extracted from the labels, not necessarily those that go in the Kotka upload!)

The input data (\code{x}) must contain column "sample" or "label" (or be a vector of samples). If only "label" is given, samples and other data will be extracted from the labels, and added to 'x'. Existing data is not overwritten: creates a new column if one didn't exist, otherwise only fills in gaps in the column.

The following columns of 'x', if present, are matched to their equivalents in Kotka:
\itemize{
\item box
\item date_begin
\item date_end
\item label
\item sex
}

Any other columns are currently ignored.
}
\examples{
# example labels 1
labels = c(  
"cct1-141022",  
"PERU, Allpahuayo 1.-15.12.2000, Sääksjärvi I.E I1/17 Occia sp. 1. ♀",  
"ECUADOR, Tiputini, 22. Oct 1998, Canopy fogging Lot# 1966 Meniscomorpha sp. 2",  
"cct1-141023 incorrect sample ID",  
"PERU, Allpahuayo 3.-16.12.2000, dates are wrong, Sääksjärvi I.E I1/17"
)

# save as data frame
x = data.frame(label=labels)

# create upload but don't save to file
upload1 = make_upload(x, upload_file=NA, problems_file=NA)


# example labels 2 (real labels from Peru and Ecuador)
x = example_labels

# create upload but don't save to file
upload2 = make_upload(x, upload_file=NA, problems_file=NA)
}
\seealso{
\code{\link[=get_labeldata]{get_labeldata()}} which gets data from labels, \code{\link[=verify_data]{verify_data()}} which checks the data for problems.
}
