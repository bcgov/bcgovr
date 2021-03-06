% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/devex_badge.R
\name{insert_bcgov_lifecycle_badge}
\alias{insert_bcgov_lifecycle_badge}
\title{Add html for inserting a bcgov project lifecycle badge}
\usage{
insert_bcgov_lifecycle_badge(project_state, cat = TRUE)
}
\arguments{
\item{project_state}{One of: 'experimental', 'maturing', 'dormant', 'stable' or 'retired'. A lifecycle
badge can be included in a readme to indicate the current state of a project. Recognized project states are
described at \url{https://github.com/bcgov/repomountie/blob/master/doc/lifecycle-badges.md}}

\item{cat}{Use cat to print the result (\code{TRUE}; default) or return a character vector (\code{FALSE})?}
}
\value{
html
}
\description{
Add html for inserting a bcgov project lifecycle badge
}
