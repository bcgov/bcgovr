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
#' @param path Directory path (default `"."`)
#' @param project Name of the project. Defaults to the name of the Rstudio project/working directory
#' @param package Is this a package or a regular project? (Default  `FALSE`)
#'
#' @export
#' @seealso [use_bcgov_contributing()], [use_bcgov_license()], [use_bcgov_code_of_conduct()]
#' @return NULL
use_bcgov_readme <- function(project = NULL, package = FALSE) {
  add_readme(project = project, package = package, extension = ".md")
}

#' @inherit use_bcgov_readme
#' @export
use_bcgov_readme_rmd <- function(project = NULL, package = FALSE) {
  add_readme(project = project, package = package, extension = ".Rmd")
}

add_readme <- function(project, package, extension) {
  if (is.null(project)) {
    project = basename(usethis::proj_get())
  }
  
  fbase <- ifelse(package, "pkg-README", "README")
  
  usethis::use_template(template = paste0(fbase, extension), 
                        save_as = paste0("README", extension),
                        data = list(project_name = project, 
                                    year = format(Sys.Date(), "%Y")), 
                        ignore = package,
                        package = "bcgovr")
}

#' Add a CONTRIBUTING.md file to the project directory
#' 
#' @inheritParams use_bcgov_readme
#' @export
#' @seealso [use_bcgov_readme()], [use_bcgov_licence()], [use_bcgov_code_of_conduct()]
#' @return `TRUE` (invisibly)
use_bcgov_contributing <- function(package = FALSE) {
  usethis::use_template(template = "CONTRIBUTING.md", 
                        ignore = package, package = "bcgovr")
}

#' Add a CODE_OF_CONDUCT.md file to the project directory
#' 
#' @inheritParams use_bcgov_readme
#' @param coc_email Contact email address(es) for the Code of Conduct.
#' @export
#' @seealso  [use_bcgov_readme()], [use_bcgov_licence()], [add_license_header()]
#' @return `TRUE` (invisibly)
use_bcgov_code_of_conduct <- function(package = FALSE, coc_email = getOption("bcgovr.coc.email", default = NULL)) {
  usethis::use_template(template = "CoC.md", 
                        save_as = "CODE_OF_CONDUCT.md",
                        ignore = package, 
                        data = list(COC_CONTACT_EMAIL = coc_email),
                        package = "bcgovr")
  
  if (is.null(coc_email)) {
    message("No contact email has been added to your CODE_OF_CONDUCT.md.", 
            "Please do so manually")
  }
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
    not_done(paste(outfile, "already exists. Not adding a new one"))
  } else {
    usethis:::done("Adding ", usethis:::value(basename(outfile)), " file")
    
    template_path <- system.file("templates", fname, package = pkg)
    
    copied <- file.copy(template_path, outfile)
    if (!copied) {
      stop("Unable to copy ", template_path, " to ", outfile, call. = FALSE)
    }
  }
  
  invisible(outfile)
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
  usethis:::done("Adding Apache boilerplate header to the top of ", usethis:::value(file))
  
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
