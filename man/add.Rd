% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helper_functions.R
\name{add}
\alias{add}
\title{Add problem messages to a vector}
\usage{
add(x, what = "")
}
\arguments{
\item{x}{Character vector of existing problem messages.}

\item{what}{Character string detailing the problem. Added to every item of \code{x}.}
}
\value{
The input vector (\code{x}) with the message added to each item.
}
\description{
This is a helper function used by \code{\link[=verify_data]{verify_data()}}. Adds any problem messages of a wasp label to a character vector, so that new problem messages go on a new line.
}
\seealso{
\code{\link[=verify_data]{verify_data()}}
}
