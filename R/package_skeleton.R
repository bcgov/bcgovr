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

#' Creates the framework of a new package development folder
#' 
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
#' @param CoC Should a Code of Conduct be added to the repository? Default \code{TRUE}.
#' @param descrption_template Should the BC Gov DESCRIPTION template be used?
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
#'  package_skeleton(path = "c:/_dev/tarballs", rstudio = TRUE)
#' }
package_skeleton <- function(path = ".", git_init = TRUE, git_clone = NULL, 
                              rstudio = TRUE, CoC = TRUE, description_template = TRUE,
                              copyright_holder = "Province of British Columbia") {
  
  if (path != ".") dir.create(path, recursive = TRUE)
  
  npath <- normalizePath(path, winslash = "/", mustWork = TRUE)
  
  if (is.character(git_clone)) {
    clone_git(git_clone, npath)
    git_init = FALSE
  }
  
  if (description_template ) {
    add_description()
  }
  
  ## Add in package setup files
  devtools::setup(rstudio = FALSE) 

  ## Add the necessary R files and directories
  #message("Creating new package in ", npath)
  add_contributing(npath)
  if (CoC) add_code_of_conduct(npath, package = FALSE)
  add_readme(npath, package = FALSE)
  
  #if (apache) {
  #  add_license(npath)
  #  lapply(Rfiles, add_license_header, year = substr(Sys.Date(), 1, 4), 
  #         copyright_holder = copyright_holder)
  #}
  

  
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
    write_gitignore(".Rproj.user", ".Rhistory", ".RData", "out/", 
                    "internal.R", path = npath)
  }
  setwd(npath)
  message("Setting working directory to ", npath)
  invisible(npath)
}

