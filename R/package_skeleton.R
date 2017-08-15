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
#'  bcgovr::package_skeleton(path = "c:/_dev/tarballs")
#' }
package_skeleton <- function(path = ".", git_init = TRUE, git_clone = NULL, apache = TRUE,
                             rstudio = TRUE, CoC = TRUE, rmarkdown = TRUE, 
                             coc_email = getOption("bcgovr.coc_email"),
                             copyright_holder = "Province of British Columbia") {
  
  ## Create directory is path is not current working directory
  ## Suppress warning if directory is already there. 
  if (path != ".") dir.create(path, recursive = TRUE, showWarnings = FALSE)
  
  npath <- normalizePath(path, winslash = "/", mustWork = TRUE)
  
  if (is.character(git_clone)) {
    clone_git(git_clone, npath)
    git_init = FALSE
  }
  

  bcgovr_desc = list("Package" = sub('.*\\/', '', npath),
                     "License" = "Apache License (== 2.0) | file LICENSE",
                     "Authors@R" = paste0('c(person("First", "Last", email = "first.last@example.com", role = c("aut", "cre")), 
                                   person("Province of British Columbia", role = "cph"))')
  )
  
  
  ## Add in package setup files
  devtools::setup(npath, rstudio = rstudio, description = bcgovr_desc, quiet = TRUE) 
  
  ##Add in a news file
  #devtools::use_news_md()
  
  ## Add all bcgov files into RBuildignore
  add_to_rbuildignore(path = npath, text = "^CONTRIBUTING.md$")
  add_to_rbuildignore(path = npath, text = "^README.md$")
  add_to_rbuildignore(path = npath, text = "^CODE_OF_CONDUCT.md$")

  ## Add the necessary R files and directories
  #message("Creating new package in ", npath)
  add_contributing(npath)
  if (CoC) add_code_of_conduct(npath, package = FALSE, coc_email = coc_email)
  
  
  add_readme(npath, package = TRUE, rmd = rmarkdown)
  
  
  if (apache) {
    add_license(npath)
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
  
  
  invisible(npath)
}

