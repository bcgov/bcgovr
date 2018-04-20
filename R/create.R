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
#' Creates the folder structure for a new analysis.
#'  
#' @param  path location to create new analysis. If \code{"."} (the default), 
#'   the name of the working directory will be taken as the analysis name. If 
#'   not \code{"."}, the last component of the given path will be used as the 
#'   analysis name.
#' @param newSession If using RStudio do you want a new RStudio session to open? Defaults to FALSE. 
#' @param rmarkdown Should an rmarkdown file be added to the repository
#'   with its corresponding markdown file? Default \code{FALSE}.
#' @param coc_email Contact email address(es) for the Code of Conduct. 
#' 
#' You may want to set this option (\code{options("bcgovr.coc.email" = "my.email@gov.bc.ca")}) in your 
#' .Rprofile file so that every time you start a new analysis, it will be automatically populated.
#' @param copyright_holder the name of the copyright holder (default 
#' "Province of British Columbia). Only necessary if adding a license
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
#'  bcgovr::create_bcgov_project(path = "c:/_dev/tarballs")
#' }
create_bcgov_project <- function(path = ".", 
                              rstudio = TRUE, newSession = FALSE, 
                              dir_struct = getOption("bcgovr.dir.struct", default = NULL),
                              copyright_holder = "Province of British Columbia") {


  ## Create directory is path is not current working directory
  ## Suppress warning if directory is already there. 
  if (path != ".") dir.create(path, recursive = TRUE, showWarnings = FALSE)
  
  ## Convert file path to canonical
  npath <- normalizePath(path, winslash = "/", mustWork = TRUE)
  
  ## Need to check for analysis structure
  if (is.null(dir_struct)) {
    dir_struct <- c("R/","out/", "graphics/", "data/", "01_load.R", "02_clean.R", "03_analysis.R", "04_output.R", "internal.R", "run_all.R")
    default_str <- TRUE
  } else {
    default_str <- FALSE
  }
  dirs <- file.path(npath, dir_struct[grepl("/$", dir_struct)])
  files <- setdiff(file.path(npath, dir_struct), dirs)
  filedirs <- dirname(files)
  
  if (any(file.exists(files, dirs))) { ## file.exists is case-insensitive
    stop("It looks as though you already have an analysis set up here!")
  }
  
  ## Add the necessary R files and directories
  usethis:::done("Creating new analysis in ", usethis:::value(npath))
  usethis:::done("Populating ", usethis:::value(npath), " with directory structure")
  lapply(c(dirs, filedirs), dir.create, recursive = TRUE, showWarnings = FALSE)
  lapply(files, file.create)

  if (default_str) {
    cat('source("01_load.R")\nsource("02_clean.R")\nsource("03_analysis.R")\nsource("04_output.R")\n', 
        file = file.path(npath,"run_all.R"))
  }
  
  
  invisible(npath)
}


# Function to be executed on error, to clean up files that were created
# error_cleanup <- function(t) {
#   info <- file.info(list.files(all.files = TRUE, include.dirs = TRUE, no.. = TRUE))
#   del_files <- rownames(info[t < info$ctime, ])
#   cat("Deleting generatedfiles:", del_files)
#   unlink(del_files, recursive = TRUE, force = TRUE)
# }
