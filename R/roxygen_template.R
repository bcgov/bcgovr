#' Populate the boilerplate roxygen template at the top of the function.
#' 
#' Inspired by Karthik Ram's RTools Sublime Text 2 plugin: 
#' https://github.com/karthik/Rtools
#' @param  funfile path to the .R file containing the function
#' @param  func the name of the function you want to document
#' @export
#' @return nothing, but adds the roxygen template to the top of the file
roxygen_template <- function(funfile, func) {
  
  fun_text <- readLines(funfile, warn=FALSE)
  
  fundef_start <- grep(paste0(func, "\\s*(<-|=)\\s*function\\s*\\("), fun_text)
  
  # Check the previous few lines to make sure roxygen block doesn't already exist
  if (fundef_start > 1) {
    checks <- (fundef_start - min(5, fundef_start)):(fundef_start - 1)
    if (any(grepl("^#'", fun_text[checks]))) {
      stop("It appears you already have roxygen documentation for your function!")
    }
  }
  
  if (fundef_start == 1) {
    above <- NULL
  } else {
    above <- fun_text[1:(fundef_start - 1)]
  }
  
  the_rest <- fun_text[fundef_start:length(fun_text)]
  
  source(funfile, local = TRUE)
  params <- names(formals(func))
  
  # Put together the roxygen fields:
  params <- paste0("#' @param ", params, " <parameter description goes here>")
  top <- "#' <brief description of function>
          #'
          #' <full description of function>
          #' 
          #' @import <list imported packages separated by spaces (or each on own @import line)>
          #' @importFrom <list package and functions in the form: package function_a function_b>"
  end <- "#' @export <delete this line if not an exported function>
          #' @keywords <may delete this line>
          #' @seealso <may delete this line>
          #' @return <describe what is returned by the function>
          #' @alias <may delete this line>
          #' @examples \\dontrun{
          #' 
          #'}"
  roxy <- paste(c(top, params, end), sep="")
  
  ## Strip off leading whitespace from roxy lines:
  roxy <- gsub("(^|\\n)\\s+", "\\1", roxy)
  
  # Write to the top of the file (without asking... should be safe, i think)
  writeLines(c(above, roxy, the_rest), funfile)
  
  # Open the file to fill in documentation
  file.edit(funfile)
  
  invisible(NULL)
}
