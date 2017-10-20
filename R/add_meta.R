# Copyright 2015 Province of British Columbia
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

#' Add a README.md file to the project directory
#' 
#' @param path Directory path (default \code{"."})
#' @param package Is this a package or a regular project? (Default \code{FALSE})
#' @param rmd Should rmarkdown file be used (Default \code{FALSE})
#' @export
#' @seealso \code{\link{add_contributing}}, \code{\link{add_license}}, \code{\link{add_license_header}}
#' @return NULL
add_readme <- function(path = ".",
                       package = FALSE,
                       rmd = FALSE) {
  
  ext <- ifelse(rmd, ".Rmd", ".md")
  fbase <- ifelse(package, "pkg-README", "README")

  add_file_from_template(path, 
                         fname = paste0(fbase, ext), 
                         outfile = paste0("README", ext))
  
  invisible(TRUE)
} 

#' Add a CONTRIBUTING.md file to the project directory
#' 
#' @param path Directory path (default \code{"."})
#' @param package Is this a package or a regular project? (Default \code{FALSE}). 
#'                If \code{TRUE}, "CONTRIBUTING.md" will be added to .Rbuildignore
#' @export
#' @seealso \code{\link{add_readme}}, \code{\link{add_license}}, \code{\link{add_license_header}}
#' @return \code{TRUE} (invisibly)
add_contributing <- function(path = ".", package = FALSE) {
  add_file_from_template(path, "CONTRIBUTING.md")
  if (package) add_to_rbuildignore(path = path, text = "CONTRIBUTING.md")
  invisible(TRUE)
}

#' Add a CODE_OF_CONDUCT.md file to the project directory
#' 
#' @param path Directory path (default \code{"."})
#' @param package Is this a package or a regular project? (Default \code{FALSE}). 
#'                If \code{TRUE}, "CODE_OF_CONDUCT.md" will be added to .Rbuildignore
#' @param coc_email Contact email address(es) for the Code of Conduct.
#' @export
#' @seealso \code{\link{add_readme}}, \code{\link{add_license}}, \code{\link{add_license_header}}
#' @return \code{TRUE} (invisibly)
add_code_of_conduct <- function(path = ".", package = FALSE, coc_email = getOption("bcgovr.coc.email")) {
  add_file_from_template(path, "CODE_OF_CONDUCT.md")
  if (package) add_to_rbuildignore(path = path, text = "CODE_OF_CONDUCT.md")

  if (!is.null(coc_email)) {
    coc_path <- normalizePath(file.path(path, "CODE_OF_CONDUCT.md"), 
                              winslash = "/", mustWork = TRUE)
    coc_text <- readLines(coc_path)
    coc_text <- gsub("{COC_CONTACT_EMAIL}", coc_email, coc_text, fixed = TRUE)
    writeLines(coc_text, coc_path)
  }
  
  #message("* Don't forget to describe the code of conduct in your README.md/Rmd:")
  #message("Please note that this project is released with a ", 
  #        "[Contributor Code of Conduct](CODE_OF_CONDUCT.md). ", 
  #        "By participating in this project you agree to abide by its terms.")
  invisible(TRUE)
}

#' Add a LICENSE file (Apache 2.0) to the project directory
#' 
#' @param path Directory path (default \code{"."})
#' @param package_desc Should the license be added to the DESCRIPTION file if this is a package?
#'
#' @export
#' @seealso \code{\link{add_readme}}, \code{\link{add_contributing}}, \code{\link{add_license_header}}
#' @return NULL
add_license <- function(path = ".", package_desc = FALSE) {
  add_file_from_template(path, "LICENSE")
  #if (package_desc) {
  #  desc <- readLines(file.path(path, "DESCRIPTION"))
  #  desc[grep("License:", desc)] <- "License: Apache License (== 2.0) | file LICENSE"
  #  writeLines(desc, "DESCRIPTION")
  #}
  invisible(TRUE)
}

#' Add an RProject file to a directory
#'
#' @param  path folder path of the project. Default \code{"."}
#' @param outfile the name of the RProj file
#' @export
#' @seealso \code{\link{add_readme}}, \code{\link{add_license}}, \code{\link{add_license_header}}
#' @return NULL
#' 
add_rproj <- function(path = ".", outfile) {
 add_file_from_template(path, "template.Rproj", outfile)
}

#add_rproj <- function(path = ".") {
#  rstudioapi::initializeProject(path)
#  invisible(TRUE)
#}

#' Add a file to a directory from a template in inst/templates
#'
#' Should really only be called by other functions
#' 
#' @param path Directory path (default \code{"."})
#' @param fname the name of the template file in inst/templates
#' @param outfile name of the file to be written, if different from the name of the template file
#' @param pkg package from which to load the template
#' @keywords internal
#' @seealso \code{\link{add_readme}}, \code{\link{add_contributing}}, \code{\link{add_license}}
#' @return NULL
add_file_from_template <- function(path, fname, outfile = NULL, pkg = "bcgovr") {

  if (!dir.exists(path)) dir.create(path)
  
  path <- normalizePath(path, winslash = "/", mustWork = TRUE)
  
  if (is.null(outfile)) {
    outfile <- file.path(path, fname)
  } else {
    outfile <- file.path(path, outfile)
  }
  
  if (file.exists(outfile)) {
    warning(paste(outfile, "already exists. Not adding a new one"))
  } else {
    message(paste("Adding file", outfile))
    
    template_path <- system.file("templates", fname, package = pkg)
    
    file.copy(template_path, outfile)
  }
  
  invisible(TRUE)
}

#' Add the boilerplate Apache header to the top of a source code file
#' 
#' @param file Path to the file
#' @param year The year the license should apply (Default current year)
#' @param copyright_holder Copyright holder (Default "Province of British Columbia")
#' @export
#' @seealso \code{\link{add_license}}
#' @return NULL
add_license_header <- function(file, year = format(Sys.Date(), "%Y"), copyright_holder = "Province of British Columbia") {
  
  file_text <- readLines(file)
  
  license_text <- make_license_header_text(year, copyright_holder)

  writeLines(c(license_text, file_text), file)
  message("Adding Apache boilerplate header to the top of ", file)
  
  invisible(TRUE)
}

make_license_header_text <- function(year = NULL, copyright_holder = NULL) {
  license_txt <- '# Copyright {YYYY} {COPYRIGHT_HOLDER}
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

'
  
  if (!is.null(year)) {
    license_txt <- gsub("{YYYY}", year, license_txt, fixed = TRUE)
  }
  
  if (!is.null(copyright_holder)) {
    license_txt <- gsub("{COPYRIGHT_HOLDER}", copyright_holder, license_txt, fixed = TRUE)
  }
  
  license_txt
}

#' Add text to Rbuildignore
#'
#' @param path 
#' @param text 
#'
#' @return TRUE
#' @keywords internal
add_to_rbuildignore <- function(path, text) {
  fpath <- file.path(path, ".Rbuildignore")
  rbuildignore <- character(0)
  if (file.exists(fpath)) rbuildignore <- readLines(fpath)
  if (!any(grepl(text, rbuildignore))) { 
    rbuildignore <- c(rbuildignore, text)
    writeLines(rbuildignore, fpath)
  }
  invisible(TRUE)
}



