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

#' Creates the framework of a new analysis development folder
#' 
#' Creates the folder structure for a new analysis.
#'
#' @importFrom git2r repository init
#'  
#' @param  path location to create new analysis. If \code{"."} (the default), 
#'   the name of the working directory will be taken as the analysis name. If 
#'   not \code{"."}, the last component of the given path will be used as the 
#'   analysis name.
#' @param git_init Create a new git repository? Logical, default \code{TRUE}.
#' @param git_clone the url of a git repo to clone.
#' @param rstudio Create an Rstudio project file?
#' @param apache Add licensing info for release under Apache 2.0? Default \code{TRUE}.
#' @param copyright_holder the name of the copyright holder (default 
#' "Province of British Columbia). Only necessary if adding a license
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
#'  analysis_skeleton(path = "c:/_dev/tarballs", rstudio = TRUE)
#' }
analysis_skeleton <- function(path = ".", git_init = TRUE, git_clone = NULL, 
                              rstudio = TRUE, apache = TRUE, 
                              copyright_holder = "Province of British Columbia") {

#   now <- Sys.time()
#   options(error = quote(error_cleanup(now)))
#   on.exit(options(error = NULL), add = TRUE)
  
  if (path != ".") dir.create(path, recursive = TRUE)
  
  npath <- normalizePath(path, winslash = "/", mustWork = TRUE)

  if (is.character(git_clone)) {
    clone_git(git_clone, npath)
    git_init = FALSE
  }
  
  ## Need to check for analysis structure
  Rfiles <- file.path(npath, c("01_load.R", "02_clean.R", "03_analysis.R", "04_output.R", 
              "internal.R", "run_all.R"))
  dirs <- file.path(npath, c("out", "tmp", "data"))
  
  if (any(file.exists(Rfiles, dirs))) { ## file.exists is case-insensitive
    #if (git) unlink(c(".git", ".gitignore", recursive = TRUE, force = TRUE)
    stop("It looks as though you already have an analysis set up here!")
  }
  
  ## Add the necessary R files and directories
  message("Creating new analysis in ", npath)
  lapply(Rfiles, file.create)
  lapply(dirs, dir.create)
  add_contributing(npath)
  add_readme(npath, package = FALSE)
  
  cat('source("01_load.R")
source("02_clean.R")
source("03_analysis.R")
source("04_output.R")

## Make print version
mon_year <- format(Sys.Date(), "%B%Y")
outfile <- paste0("envreportbc_[indicator_name]_", mon_year, ".pdf")
rmarkdown::render("print_ver/[indicator_name].Rmd", output_file = outfile)
extrafont::embed_fonts(file.path("print_ver/", outfile))
## You will likely want to "optimize pdf" in Acrobat to make the print version smaller.\n', 
      file = file.path(npath,"run_all.R"))
  
  if (apache) {
    add_license(npath)
    lapply(Rfiles, add_license_header, year = substr(Sys.Date(), 1, 4), 
           copyright_holder = copyright_holder)
  }
  
  if (rstudio) {
    if (!length(list.files(npath, pattern = "*.Rproj", ignore.case = TRUE))) {
      add_rproj(npath, paste0(basename(npath), ".Rproj"))
    } else {
      warning("Rproj file already exists, so not adding a new one")
    }
  }

  if (git_init) {
    if (file.exists(file.path(npath,".git"))) {
      warning("This directory is already a git repository. Not creating a new one")
    } else {
      init(npath)
    }
  }
  
  if (git_init || is.character(git_clone)) {
    write_gitignore(".Rproj.user", ".Rhistory", ".RData", "out/", "tmp/", 
                    "internal.R", path = npath)
  }
  setwd(npath)
  message("Setting working directory to ", npath)
  invisible(npath)
}

# Function to be executed on error, to clean up files that were created
# error_cleanup <- function(t) {
#   info <- file.info(list.files(all.files = TRUE, include.dirs = TRUE, no.. = TRUE))
#   del_files <- rownames(info[t < info$ctime, ])
#   cat("Deleting generatedfiles:", del_files)
#   unlink(del_files, recursive = TRUE, force = TRUE)
# }
