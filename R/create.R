# Copyright 2017 Province of British Columbia
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

#' Creates the framework of a new analysis development folder
#' 
#' Creates the folder structure for a new analysis in your current working directory.
#' 
#' @inheritParams use_bcgov_req 
#'  

#' @param dir_struct alternative analysis directory structure. This should be specified as
#' a character vector of directory and file paths (relative to the root of the project). 
#' Directories should be identified by having a trailing forward-slash (e.g., \code{"dir/"}).
#' 
#' The default is: \code{c("R/","out/", "graphics/", "data/", "01_load.R", "02_clean.R", "03_analysis.R", "04_output.R", "internal.R", "run_all.R")}.
#' 
#' This can also be set as an option \code{bcgovr.dir.struct}. You may want to set this in your 
#' .Rprofile file so that every time you start a new analysis, your custom structure is set up.
#' The line in your \code{.Rprofile} file would look something like this: 
#' \code{options("bcgovr.dir.struct" = c("doc/", "data/", "bin/", "results/", "src/01_load.R", "src/02_clean.R", "src/03_analysis.r", "src/04_output.R", "src/runall.R"))}
#'
#' @export
#' 
#' @examples \donttest{
#'  bcgovr::create_bcgov_project()
#' }
create_bcgov_project <- function(rmarkdown = TRUE, 
                                 licence = "apache2",
                                 coc_email = getOption("bcgovr.coc.email", default = NULL),
                                 dir_struct = getOption("bcgovr.dir.struct", default = NULL)) {
  
  ## Add in bcgov repo requirements
  use_bcgov_req(licence = licence, rmarkdown = rmarkdown, coc_email = coc_email)
  
  ## Need to check for analysis structure
  if (is.null(dir_struct)) {
    dir_struct <- c("out/", "graphics/", "data/", "01_load.R", "02_clean.R", "03_analysis.R", "04_output.R", "internal.R", "run_all.R")
    default_str <- TRUE
  } else {
    default_str <- FALSE
  }
  dirs <- file.path(dir_struct[grepl("/$", dir_struct)])
  files <- setdiff(file.path(dir_struct), dirs)
  filedirs <- dirname(files)
  
  if (any(file.exists(files, dirs))) { ## file.exists is case-insensitive
    stop("It looks as though you already have an analysis set up here!", call. = FALSE)
  }
  
  ## Add the necessary R files and directories
  usethis:::done("Creating new analysis")
  usethis:::done("Populating with directory structure")
  lapply(c(dirs, filedirs), dir.create, recursive = TRUE, showWarnings = FALSE)
  lapply(files, file.create)
  # Insert appropriate licence header into source files
  insert_licence_header <- switch(licence, 
                                  "apache2" = insert_bcgov_apache_header,
                                  "cc-by" = insert_bcgov_cc_header)
  lapply(files, insert_licence_header)

  if (default_str) {
    cat('source("01_load.R")\nsource("02_clean.R")\nsource("03_analysis.R")\nsource("04_output.R")\n', 
        file = file.path("run_all.R"))
  }
  
  
  invisible(TRUE)
}


#' Creates the framework of a new package development folder
#' 
#'
#'  
#' @inheritParams create_bcgov_project
#' @param rmarkdown Should an rmarkdown file be added to the repository
#'   with its corresponding markdown file? Default \code{TRUE}.
#' 
#' @inherit create_bcgov_project details
#'
#' @export
#' 
#' @examples \donttest{
#'  bcgovr::create_bcgov_package()
#' }
create_bcgov_package <- function(rmarkdown = TRUE, 
                                 coc_email = getOption("bcgovr.coc.email", default = NULL),
                                 dir_struct = getOption("bcgovr.dir.struct", default = NULL)) {
  

  
  package_name <- sub('.*\\/', '', getwd())
  
  congrats("Setting up the ", package_name, " package")

  
  
  bcgovr_desc = list("Package" = package_name,
                     "License" = "Apache License (== 2.0) | file LICENSE",
                     "Authors@R" = paste0('c(person("First", "Last", email = "first.last@example.com", role = c("aut", "cre")), 
                                          person("Province of British Columbia", role = "cph"))')
  )
  
  
  
  ## Add in package setup files
  usethis::create_package(path = ".", fields = bcgovr_desc, rstudio = TRUE)
  
  ## Add individual elements via usethis
  usethis::use_news_md()
  usethis::use_roxygen_md()
  usethis::use_vignette(name = package_name)
  
  ## Add in bcgov repo requirements
  ## A package will only ever need apache2 licence
  use_bcgov_req(licence = "apache2", rmarkdown = rmarkdown, coc_email = coc_email)
  
  
  
  ## Add all bcgov files into RBuildignore
  usethis::use_build_ignore("CONTRIBUTING.md")
  usethis::use_build_ignore("CODE_OF_CONDUCT.md")
  usethis::use_build_ignore("README.md")
  usethis::use_build_ignore("README.Rmd")
  
 
  invisible(TRUE)
}


# Function to be executed on error, to clean up files that were created
# error_cleanup <- function(t) {
#   info <- file.info(list.files(all.files = TRUE, include.dirs = TRUE, no.. = TRUE))
#   del_files <- rownames(info[t < info$ctime, ])
#   cat("Deleting generatedfiles:", del_files)
#   unlink(del_files, recursive = TRUE, force = TRUE)
# }
