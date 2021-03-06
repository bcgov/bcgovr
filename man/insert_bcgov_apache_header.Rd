% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/licence_header.R
\name{insert_bcgov_apache_header}
\alias{insert_bcgov_apache_header}
\title{Add the boilerplate Apache header to the top of a source code file}
\usage{
insert_bcgov_apache_header(file, year = format(Sys.Date(), "\%Y"))
}
\arguments{
\item{file}{Path to the file}

\item{year}{The year the licence should apply (Default current year)}
}
\description{
Add the boilerplate Apache header to the top of a source code file
}
\seealso{
\code{\link[=use_bcgov_licence]{use_bcgov_licence()}} \code{\link[=insert_bcgov_cc_header]{insert_bcgov_cc_header()}}
}
