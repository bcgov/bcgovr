#' Populate the boilerplate roxygen template at the top of the file containing the function.
#'
#' @param  funfile path to the .R file containing the function
#' @details File must have the argument list and the opening \code{\{} all on one line: 
#'            \code{myFun <- function(arg1, arg2, arg3) \{}
#' @export
#' @return nothing, but adds the roxygen template to the top of the file
#' @examples \dontrun{
#'
#'}
roxygen_template <- function(funfile) {
  ##
  ## funfile: path to the .R file containing the function
  ## 
  ## File must have the argument list and the opening "{" all on one line: 
  ##    myFun <- function(arg1, arg2, arg3) {
  ## 
  ## Inspired by Karthik Ram's RTools Sublime Text 2 plugin:
  ## https://github.com/karthik/Rtools
  
  fun_text <- readLines(funfile, warn=FALSE)
  
  if (grepl("^#'", fun_text[1])) {
    stop("It appears you already have roxygen documentation in your function!")
  }
  
  # Find the function and parameter definition line:
  matches <- regexpr("(?<=\\().+?(?=\\)\\s*?\\{)", fun_text, perl=TRUE)
  params_line <- regmatches(fun_text,matches)[1]
  
  # Parse out and clean the parameter names:
  params <- strsplit(params_line, ",")[[1]]
  params <- gsub("^\\s+|\\s+$|=.+", "", params)
  
  # Put together the roxygen fields:
  params <- paste0("#' @param  ", params, " <parameter description goes here>")
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
  writeLines(c(roxy, fun_text), funfile)
  
  # Open the file to fill in documentation
  file.edit(funfile)
}
