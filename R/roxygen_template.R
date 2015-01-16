#' Populate the boilerplate roxygen template at the top of the function.
#'
#' Inspired by Karthik Ram's RTools Sublime Text 2 plugin:
#' https://github.com/karthik/Rtools
#' @param  funfile path to the .R file containing the function
#' @param  params_start The (first) line that contains the parameters for your function (default 1)
#' @param  params_end (optional) If your parameter definitions breaks across multiple lines, 
#'                    specify the ending line (default \code{NULL}).
#' @export
#' @return nothing, but adds the roxygen template to the top of the file
roxygen_template <- function(funfile, params_start=1, params_end = NULL) {
  
  fun_text <- readLines(funfile, warn=FALSE)
  
  if (is.null(params_end)) params_end <- params_start
  
  if (params_start == 1) {
    checks <- 1:5
  } else {
    checks <- (params_start - 5):params_start
  }
  
  if (any(grepl("^#'", fun_text[checks]))) {
    stop("It appears you already have roxygen documentation for your function!")
  }
  
  if (params_start == 1) {
    above <- NULL
  } else {
    above <- fun_text[1:(params_start - 1)]
  }
  the_rest <- fun_text[params_start:length(fun_text)]
  
  # Find the function and parameter definition line:
  #   
  
  ## Combine multiple lines of parameters
  params_line <- paste(fun_text[params_start:params_end], collapse = "")
  
  # Pull out the function and parameter definitions:
  matches <- regexpr("(?<=\\().+?(?=\\)\\s*?\\{)", params_line, perl=TRUE)
  params <- regmatches(params_line,matches)[1]
  
  # Parse out and clean the parameter names:
  params <- strsplit(params, ",")[[1]]
  params <- gsub("\\s+|=.+", "", params)
  
  # Put together the roxygen fields:
  params <- paste0("#' @param ", params, " <parameter description goes here>")
  top <- "#' <brief description of function>
#'
#' <full description of function>
#' 
#' @import <list required packages separated by spaces>
#' @importFrom <list package and functions: package functiona functionb>"
  end <- "#' @export
#' @keywords <may delete this line>
#' @seealso <may delete this line>
#' @return
#' @alias <may delete this line>
#' @examples \\dontrun{
#' 
#'}"
  roxy <- paste(c(top, params, end), sep="")
  
  # Write to the top of the file (without asking... should be safe, i think)
  writeLines(c(above, roxy, the_rest), funfile)
  
  # Open the file to fill in documentation
  file.edit(funfile)
}
