\name{roxygen_template}
\alias{roxygen_template}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
roxygen_template(funfile)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{funfile}{
%%     ~~Describe \code{funfile} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (funfile) 
{
    fun_text <- readLines(funfile, warn = FALSE)
    if (grepl("^#'", fun_text[1])) {
        stop("It appears you already have roxygen documentation in your function!")
    }
    matches <- regexpr("(?<=\\().+?(?=\\)\\s*?\\{)", fun_text, 
        perl = TRUE)
    params_line <- regmatches(fun_text, matches)[1]
    params <- strsplit(params_line, ",")[[1]]
    params <- gsub("^\\s+|\\s+$|=.+", "", params)
    params <- paste0("#' @param  ", params, " <parameter description goes here>")
    top <- "#' <brief description of function>\n#'\n#' <full description of function>\n#' \n#' @import <list required packages separated by spaces>\n#' @importFrom <list package and functions: package functiona functionb>"
    end <- "#' @export\n#' @keywords <may delete this line>\n#' @seealso <may delete this line>\n#' @return\n#' @alias <may delete this line>\n#' @examples \\dontrun{\n#' \n#'}"
    roxy <- paste(c(top, params, end), sep = "")
    writeLines(c(roxy, fun_text), funfile)
    file.edit(funfile)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
