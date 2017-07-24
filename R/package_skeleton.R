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
#' @inheritParams analysis_skeleton
#' 
#' @inherit analysis_skeleton details
#'
#' @export
#' 
#' @examples \donttest{
#'  package_skeleton(path = "c:/_dev/tarballs", rstudio = TRUE)
#' }
package_skeleton <- function(path = ".", git_init = TRUE, git_clone = NULL, 
                             rstudio = TRUE, CoC = TRUE, coc_email = getOption("bcgovr.coc_email"),
                             copyright_holder = "Province of British Columbia") {
  
  ## Create directory is path is not current working directory
  ## Suppress warning if directory is already there. 
  if (path != ".") dir.create(path, recursive = TRUE, showWarnings = FALSE)
  
  npath <- normalizePath(path, winslash = "/", mustWork = TRUE)
  
  if (is.character(git_clone)) {
    clone_git(git_clone, npath)
    git_init = FALSE
  }
  

  bcgovr_desc = list("Package" = sub('.*\\/', '', npath))
  
  ## Add in package setup files
  if(rstudio == TRUE){
  devtools::setup(npath, rstudio = TRUE, description = bcgovr_desc) 
  } else {
    devtools::setup(npath, rstudio = FALSE, description = bcgovr_desc)
  }
  
  ## Add all bcgov files into RBuildignore
  add_to_rbuildignore(path = npath, text = "^CONTRIBUTING.md$")
  add_to_rbuildignore(path = npath, text = "^README.md$")
  add_to_rbuildignore(path = npath, text = "^CODE_OF_CONDUCT.md$")

  ## Add the necessary R files and directories
  #message("Creating new package in ", npath)
  add_contributing(npath)
  if (CoC) add_code_of_conduct(npath, package = FALSE, coc_email = coc_email)
  add_readme(npath, package = FALSE)
  
  
  #if (apache) {
  #  add_license(npath)
  #  lapply(Rfiles, add_license_header, year = substr(Sys.Date(), 1, 4), 
  #         copyright_holder = copyright_holder)
  #}
  
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
  
  
  invisible(npath)
}

