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
#' @importFrom git2r repository init clone
#'  
#' @param  path location to create new analysis. If \code{"."} (the default), 
#'   the name of the working directory will be taken as the analysis name. If 
#'   not \code{"."}, the last component of the given path will be used as the 
#'   analysis name.
#' @param git_init Create a new git repository? Logical, default \code{TRUE}.
#' @param git_clone the url of a git repo to clone.
#' @param rstudio Create an Rstudio project file? If true, a new RStudio session will open for \code{analysis_skeleton}
#'   while only a \code{.Rproj} file is created for \code{package_skeleton}. 
#' @param apache Add licensing info for release under Apache 2.0? Default \code{TRUE}.
#' @param CoC Should a Code of Conduct be added to the repository? Default \code{TRUE}.
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
#' @details If you are cloning a repository (\code{git_clone = "path_to_repo"}),
#'   you should run this function from the root of your dev folder and leave 
#'   \code{path = "."}, as the repository will be cloned into a new folder. If 
#'   you are setting up a new project (with or without git), \code{path} should 
#'   be \code{"."} if you are within an already created project directory, or 
#'   the name of the folder you want to create.
#' @export
#' 
#' @examples \donttest{
#'  bcgovr::analysis_skeleton(path = "c:/_dev/tarballs")
#' }
analysis_skeleton <- function(path = ".", git_init = TRUE, git_clone = NULL, 
                              rstudio = TRUE, apache = TRUE, CoC = TRUE, rmarkdown = FALSE,
                              coc_email = getOption("bcgovr.coc.email", default = NULL),
                              dir_struct = getOption("bcgovr.dir.struct", default = NULL),
                              copyright_holder = "Province of British Columbia") {


  ## Create directory is path is not current working directory
  ## Suppress warning if directory is already there. 
  if (path != ".") dir.create(path, recursive = TRUE, showWarnings = FALSE)
  
  ## Convert file path to canonical
  npath <- normalizePath(path, winslash = "/", mustWork = TRUE)

  
  if (is.character(git_clone)) {
    git2r::clone(git_clone, npath)
    git_init = FALSE
  }
  
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
    #if (git) unlink(c(".git", ".gitignore", recursive = TRUE, force = TRUE)
    stop("It looks as though you already have an analysis set up here!")
  }
  
  ## Add the necessary R files and directories
  usethis:::done("Creating new analysis in ", npath)
  usethis:::done("Adding folders and files to ", npath, ": ", paste(dir_struct, collapse = ", "))
  lapply(c(dirs, filedirs), dir.create, recursive = TRUE, showWarnings = FALSE)
  lapply(files, file.create)

  if (default_str) {
    cat('source("01_load.R")\nsource("02_clean.R")\nsource("03_analysis.R")\nsource("04_output.R")\n', 
        file = file.path(npath,"run_all.R"))
  }
  
  add_contributing(npath)
  
  if (CoC) add_code_of_conduct(npath, package = FALSE, coc_email = coc_email)
  
  add_readme(npath, package = FALSE, rmd = rmarkdown)
  
  if (apache) {
    add_license(npath)
    lapply(files, add_license_header, year = substr(Sys.Date(), 1, 4), 
           copyright_holder = copyright_holder)
  }
  
  if (git_init) {
    if (file.exists(file.path(npath,".git"))) {
      not_done("This directory is already a git repository. Not creating a new one")
    } else {
      git2r::init(npath)
    }
  }
  
  if (git_init || is.character(git_clone)) {
    write_gitignore(".Rproj.user", ".Rhistory", ".RData", "out/", 
                    "internal.R", "*.DS_Store", path = npath)
  }
  
  # Use when these functions are available on CRAN
  if (rstudio && rstudioapi::isAvailable()) {
    rstudioapi::openProject(npath, newSession = TRUE)
    usethis:::done("Initializing and opening new Rstudio project in ", npath)
  } else {
  usethis:::done("Setting working directory to ", npath)
  setwd(npath)
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
