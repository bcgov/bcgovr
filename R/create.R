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

#' Create a bcgov R project directory structure 
#' 
#' Create a project directory structure for a new bcgov R project in your current working directory.
#' 
#' @inheritParams use_bcgov_req 
#'  
#' @param path Path to the directory in which to initialize the project. 
#'   Default `"."` - your current working directory.
#' @param dir_struct Alternative project directory structure. This should be specified as
#' a character vector of directory (i.e. folders) and file paths, relative to the root of the project. 
#' Directories should be identified by having a trailing forward-slash (e.g., \code{"dir/"}).
#' 
#' The default is: \code{c("R/", "data/", "out/", "01_load.R", "02_clean.R", "03_analysis.R", "04_output.R", "run_all.R")}.
#' 
#' This can also be set as an option \code{bcgovr.dir.struct}. You may want to set this in your 
#' .Rprofile file so that every time you start a new project, your custom project structure is set up.
#' The line in your \code{.Rprofile} file would look something like this: 
#' \code{options("bcgovr.dir.struct" = c("doc/", "data/", "results/", "src/01_load.R", "src/02_clean.R", "src/03_analysis.r", "src/04_output.R", "src/run_all.R"))}
#'
#' @param open If TRUE and in RStudio, the new project is opened in a new instance, 
#' if possible, or is switched to, otherwise.
#' 
#' @export
#' 
#' @examples \donttest{
#'  bcgovr::create_bcgov_project()
#' }
create_bcgov_project <- function(path = ".", rmarkdown = TRUE, 
                                 licence = "apache2",
                                 coc_email = get_coc_email(),
                                 dir_struct = getOption("bcgovr.dir.struct", default = NULL), 
                                 open = TRUE) {
  
  # If calling this from a current project, reset it on exit
  old_proj <- get_proj()
  if (!is.null(old_proj)) {
    on.exit(usethis::proj_set(old_proj), add = TRUE)
  }
  
  congrats("Setting up the ", basename(normalizePath(path, mustWork = FALSE)), " project")
  
  create_proj(path = path)
  
  ## Add in bcgov repo requirements
  use_bcgov_req(licence = licence, rmarkdown = rmarkdown, coc_email = coc_email)
  
  ## Need to check for analysis structure
  if (is.null(dir_struct)) {
    dir_struct <- file.path(normalizePath(path), 
                            c("out/", "data/", "01_load.R", "02_clean.R", 
                              "03_analysis.R", "04_output.R", "run_all.R"))
    default_str <- TRUE
  } else {
    default_str <- FALSE
  }
  dirs <- file.path(dir_struct[grepl("/$", dir_struct)])
  files <- setdiff(file.path(dir_struct), dirs)
  filedirs <- dirname(files)
  
  if (any(file.exists(files, dirs))) { ## file.exists is case-insensitive
    stop("It looks as though you already have a project set up here!
         If you want to add the required GitHub files, call use_bcgov_req()", 
         call. = FALSE)
  }
  
  ## Add the necessary R files and directories
  usethis:::done("Creating new project")
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
        file = file.path(normalizePath(path), "run_all.R"))
  }
  
  if (open) open_project(path)
}


#' Create a bcgov R package directory structure 
#' 
#' Create a package directory structure for a new bcgov R package in your current working directory.
#'  
#' @inheritParams create_bcgov_project
#' @param rmarkdown Should an Rmarkdown file be added to the repository
#'   with its corresponding markdown file? Default \code{TRUE}.
#' 
#' @inherit create_bcgov_project details
#'
#' @export
#' 
#' @examples \donttest{
#'  bcgovr::create_bcgov_package()
#' }
create_bcgov_package <- function(path = ".", rmarkdown = TRUE, 
                                 coc_email = get_coc_email(),
                                 open = TRUE) {
  
  package_name <- sub('.*\\/', '', basename(normalizePath(path, mustWork = FALSE)))
  
  # If calling this from a current project, reset it on exit
  old_proj <- get_proj()
  if (!is.null(old_proj)) {
    on.exit(usethis::proj_set(old_proj), add = TRUE)
  }
  
  congrats("Setting up the ", package_name, " package")

  bcgovr_desc <- list("Package" = package_name,
                     "License" = "Apache License (== 2.0) | file LICENSE",
                     "Authors@R" = paste0('c(person("First", "Last", email = "first.last@example.com", role = c("aut", "cre")), 
                                          person("Province of British Columbia", role = "cph"))')
  )
  
  ## Add in package setup files
  usethis::create_package(path = path, fields = bcgovr_desc, rstudio = TRUE, 
                          open = FALSE)
  
  ## Add individual elements via usethis
  usethis::use_news_md(open = FALSE)
  usethis::use_roxygen_md()
  usethis::use_vignette(name = package_name)
  
  ## Add in bcgov repo requirements
  ## A package will only ever need apache2 licence
  use_bcgov_req(licence = "apache2", rmarkdown = rmarkdown, coc_email = coc_email)

  if (open) open_project(path)
}

#' Create a local repository from a bcgov GitHub repository
#' 
#' Creates a new local Git repository cloned from a bcgov GitHub repository 
#' 
#' @param repo bcgov GitHub repo name specified like this: \code{bcgov/reponame}
#' @param destdir The destination directory where the cloned project will be stored locally
#' @inheritParams use_bcgov_github
#' @param ... Other arguments passed on to [usethis::create_from_github()]
#' 
#' @examples
#' \donttest{
#' create_from_bcgov_github("bcgov/bcgovr")
#' }
#' 
#' @export
create_from_bcgov_github <- function(repo,
                                     destdir = ".",
                                     protocol = "https",
                                     ...){
  
  ##TODO: Have a check that repo is two string separated by a /
  
  ## Only allow bcgov repos
  if(!grepl("bcgov|bcgov-c",repo)){
    stop("Not a bcgov repo")
  }
  
  base_reponame <- gsub("bcgov/|bcgov-c/", "", repo)
  local_repo_path <- file.path(destdir, base_reponame)
  
  if(!dir.exists(file.path(destdir))) dir.create(file.path(destdir))

  
  ## First try using git2r via usethis::create_from_github
  ## If that fails with two specific errors then check if Git is installed and use it directly
  ## via a system call
  tryCatch(usethis::create_from_github(repo = repo, destdir = destdir, protocol = protocol),
           error = function(e){
             ## Check if the repo even exists
             if (grepl("404 Not Found", e$message)){
               ## Clean up files if repo wasn't found
               unlink(base_reponame, recursive = TRUE)
               
               stop(paste0(repo, " doesn't exist on GitHub. Consider using use_bcgov_github to create one"), call. = FALSE)
             }
             
             if (grepl("unknown certificate check failure|failed to start SSH session: Unable to exchange encryption keys", e$message)){
               
               is_git_installed()
               repo_clone_cmd <- paste0("git clone -q https://github.com/",repo, " ", local_repo_path)
               usethis:::done("Using system call to git")
               system(repo_clone_cmd)
               usethis::proj_set(local_repo_path, force = TRUE)
             } else {
               stop(e)
             }
           })
  
  use_bcgov_req()
  

}

#' Get the path to the current project if it exists, otherwise return NULL
#' @noRd
get_proj <- function() {
  if (usethis:::is_package() | usethis:::is_proj()) {
    return(usethis::proj_get())
  } 
  NULL
}

#' Create a project if one doesn't exist
#' @noRd

create_proj <- function(path = ".") {
  if (!(usethis:::is_package(path) | usethis:::is_proj(path))) {
    usethis::create_project(path = path, open = FALSE)
  } else {
    usethis::proj_set(path, force = TRUE)
  }
  invisible(TRUE)
}

#' Open a project if in RStudio
#' @noRd
open_project <- function(path) {
  if (rstudioapi::isAvailable() && interactive()) {
    rstudioapi::openProject(path, newSession = TRUE)
  } else if (normalizePath(path) != getwd()) {
    congrats("Your new project is created in ", path)
  }
  invisible(TRUE)
}

# Function to be executed on error, to clean up files that were created
# error_cleanup <- function(t) {
#   info <- file.info(list.files(all.files = TRUE, include.dirs = TRUE, no.. = TRUE))
#   del_files <- rownames(info[t < info$ctime, ])
#   cat("Deleting generatedfiles:", del_files)
#   unlink(del_files, recursive = TRUE, force = TRUE)
# }
