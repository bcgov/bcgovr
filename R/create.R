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

  if (default_str) {
    cat('source("01_load.R")\nsource("02_clean.R")\nsource("03_analysis.R")\nsource("04_output.R")\n', 
        file = file.path("run_all.R"))
  }
  
  
  invisible(TRUE)
}


#' Creates the framework of a new package development folder
#' 
#'
#' @importFrom git2r repository init
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
#'  bcgovr::create_bcgov_package(path = "c:/_dev/tarballs")
#' }
create_bcgov_package <- function(path = ".", git_init = TRUE, git_clone = NULL, apache = TRUE,
                             rstudio = TRUE, CoC = TRUE, rmarkdown = TRUE, 
                             coc_email = getOption("bcgovr.coc.email"),
                             copyright_holder = "Province of British Columbia") {
  
  ## Create directory is path is not current working directory
  ## Suppress warning if directory is already there. 
  if (path != ".") dir.create(path, recursive = TRUE, showWarnings = FALSE)
  
  npath <- normalizePath(path, winslash = "/", mustWork = TRUE)
  
  congrats("Setting up package in working directory:", npath)
  setwd(npath)
  
  if (is.character(git_clone)) {
    git2r::clone(git_clone, npath)
    git_init = FALSE
  }
  
  
  bcgovr_desc = list("Package" = sub('.*\\/', '', npath),
                     "License" = "Apache License (== 2.0) | file LICENSE",
                     "Authors@R" = paste0('c(person("First", "Last", email = "first.last@example.com", role = c("aut", "cre")), 
                                          person("Province of British Columbia", role = "cph"))')
  )
  
  
  ## Add in package setup files
  usethis::create_package(path = npath, fields = bcgovr_desc, rstudio = FALSE)
  
  ## Add individual elements
  usethis::use_news_md()
  add_readme(npath, package = TRUE, rmd = rmarkdown)
  usethis::use_roxygen_md()
  usethis::use_vignette(name = basename(npath))
  
  
  ## Add the necessary R files and directories
  #message("Creating new package in ", npath)
  add_contributing(npath)
  if (CoC) {
    add_code_of_conduct(npath, package = FALSE, coc_email = coc_email)
    usethis::use_build_ignore(file.path(npath,"CODE_OF_CONDUCT.md"))
  }
  
  
  
  
  
  ## Add all bcgov files into RBuildignore
  usethis::use_build_ignore(file.path(npath,"CONTRIBUTING.md"))
  usethis::use_build_ignore(file.path(npath,"README.md"))
  usethis::use_build_ignore(file.path(npath,"README.Rmd"))
  
  
  if (apache) {
    add_license(npath)
  }
  
  if (git_init) {
    if (file.exists(file.path(npath,".git"))) {
      not_done("This directory is already a git repository. Not creating a new one")
    } else {
      init(npath)
    }
  }
  
  if (git_init || is.character(git_clone)) {
    write_gitignore(".Rproj.user", ".Rhistory", ".RData", "out/", 
                    "internal.R", "*.DS_Store", path = npath)
  }
  
  if (rstudio && rstudioapi::isAvailable()) {
    usethis:::done("Initializing and opening new Rstudio project in ", usethis:::value(npath))
    switch_now()
    rstudioapi::openProject(npath, newSession = TRUE)
  } else {
    usethis:::done("Setting working directory to ", usethis:::value(npath))
    switch_now()
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
