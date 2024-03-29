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

#' Add bcgov GitHub requirements to your project directory
#' 
#' Add a LICENCE file, a README, a CODE OF CONDUCT and a CONTRIBUTING file
#' 
#' @inheritParams use_bcgov_code_of_conduct
#' @inheritParams use_bcgov_licence
#' @param rmarkdown Should an Rmarkdown file be added to the repository
#'   with its corresponding markdown file? Default \code{FALSE}.
#' 
#' 
#' @export
use_bcgov_req <- function(rmarkdown = FALSE, 
                          coc_email = get_coc_email(), 
                          licence = "apache2"){
  
  # create_proj(".")
  
  if (rmarkdown) {
    use_bcgov_readme_rmd(licence = licence)
  } else {
    use_bcgov_readme(licence = licence)
  }
  
  use_bcgov_contributing()
  use_bcgov_code_of_conduct(coc_email = coc_email)
  use_bcgov_licence(licence = licence)
  use_bcgov_gitattributes()

  invisible(TRUE)
  
}

#' Add a README.md file to the project directory
#' 
#' @param project Name of the project. Defaults to the name of the RStudio project/working directory
#' @inheritParams use_bcgov_licence
#'
#' @export
#' @seealso [use_bcgov_contributing()], [use_bcgov_licence()], [use_bcgov_code_of_conduct()]
#' @return NULL
use_bcgov_readme <- function(project = NULL, licence = c("apache2", "cc-by")) {
  add_readme(project = project, licence = licence, extension = ".md")
}


#' Add a README.Rmd file to the project directory
#' 
#' @inherit use_bcgov_readme
#' @export
use_bcgov_readme_rmd <- function(project = NULL, licence = c("apache2", "cc-by")) {
  add_readme(project = project, licence = licence, extension = ".Rmd")
}

add_readme <- function(project, licence = c("apache2", "cc-by"), extension) {
  licence <- match.arg(licence)
  if (is.null(project)) {
    project <- basename(usethis::proj_get())
  }
  
  cc_link <- if (licence == "cc-by") {
    '
[![Creative Commons License](https://i.creativecommons.org/l/by/4.0/88x31.png)](http://creativecommons.org/licenses/by/4.0/)
'
  } else {
    NULL
  }
  package <- usethis:::is_package()
  fbase <- ifelse(package, "pkg-README", "README")
  
  year <- format(Sys.Date(), "%Y")
  use_bcgov_template(template = paste0(fbase, extension), 
                        save_as = paste0("README", extension),
                        data = list(project_name = project,
                                    cc_link = cc_link,
                                    licence_text = paste0(make_licence_header_text(year, licence), 
                                                          collapse = "\n")), 
                        ignore = package && extension == ".Rmd")
}

#' Add a CONTRIBUTING.md file to the project directory
#' 
#' @export
#' @seealso [use_bcgov_readme()], [use_bcgov_licence()], [use_bcgov_code_of_conduct()]
#' @return `TRUE` (invisibly)
use_bcgov_contributing <- function() {
  use_bcgov_template(template = "CONTRIBUTING.md", 
                        ignore = usethis:::is_package())
}

#' Add a CODE_OF_CONDUCT.md file to the project directory
#' 
#' @param coc_email Contact email address(es) for the Code of Conduct. It is 
#'     recommended that you save this setting by adding a line like: 
#'     `options("bcgovr.coc.email" = "your.email@gov.bc.ca")` to your `.Rprofile`.
#'     Use \code{\link[usethis:edit]{usethis::edit_r_profile()}} for an easy way to find and edit this file.
#' @export
#' @seealso [use_bcgov_readme()], [use_bcgov_licence()], [use_bcgov_contributing()]
#' @return `TRUE` (invisibly)
use_bcgov_code_of_conduct <- function(coc_email = get_coc_email()) {
  use_bcgov_template(template = "CoC.md", 
                        save_as = "CODE_OF_CONDUCT.md",
                        ignore = usethis:::is_package(), 
                        data = list(COC_CONTACT_EMAIL = coc_email))
  
  if (is.null(coc_email)) {
    congrats(coc_email, " has been set as the contact email in your CODE_OF_CONDUCT.md.")
  }
}

#' Add a LICENCE file (Apache 2.0 or CC-BY) to the project directory
#' 
#' @param licence Which licence to apply? Default is Apache 2.0 (`"apache2"`). 
#' Use `"cc-by"` for [Creative Commons Attribution 4.0](https://creativecommons.org/licenses/by/4.0/)
#'
#' @export
#' @seealso [use_bcgov_readme()], [use_bcgov_contributing()], [use_bcgov_code_of_conduct()]
#' [insert_bcgov_apache_header()], [insert_bcgov_cc_header()]
#' @return NULL
use_bcgov_licence <- function(licence = c("apache2", "cc-by")) {
  licence <- match.arg(licence)
  template <- switch(licence, 
                     "apache2" = "LICENSE-Apache", 
                     "cc-by" = "LICENSE-CC-BY")
  
  use_bcgov_template(template = template,
                        save_as = "LICENSE")
  # TODO
  #if (package_desc) {
  #  desc <- readLines(file.path(path, "DESCRIPTION"))
  #  desc[grep("License:", desc)] <- "License: Apache License (== 2.0) | file LICENSE"
  #  writeLines(desc, "DESCRIPTION")
  #}
  invisible(TRUE)
}

#' @rdname use_bcgov_licence
#' 
#' @export
#' 
use_bcgov_license <- use_bcgov_licence

#' Add an R-flavoured .gitattributes file
#' 
#' Adds a .gitattributes file that will identify the repository as an R-based code project
#' even if many lines of another language are present. 
#' 
#' @return NULL
#' 
#' @export
#' 
use_bcgov_gitattributes <- function(){
  
  use_bcgov_template(template = "gitattributes",
                        save_as = ".gitattributes")
}
  
  

#' Add your project to bcgov GitHub
#' 
#' This function requires that your project already be a Git repository. Use 
#' [use_bcgov_git()] to initialise a repository if necessary.
#'
#' @param organisation GitHub organisation where the repo will be hosted. 
#'     One of `'bcgov'` (default), `'bcgov-c'`, or `NULL` to set up in your 
#'     personal GitHub account
#' @inheritParams use_bcgov_req
#' @param protocol Transfer protocol. One of `'https'` (default) or `'ssh'`.
#' @param ... Other arguments passed on to [usethis::use_github()]
#'
#' @export
use_bcgov_github <- function(organisation = "bcgov", rmarkdown = TRUE, 
                             licence = "apache2", 
                             coc_email = get_coc_email(), 
                             protocol = "https",
                             ...) {
  
  if (is.null(git2r::discover_repository(usethis::proj_get()))) {
    stop("This doesn't appear to be a Git repository.\nPlease run use_bcgov_git() to initialize.", call. = FALSE)
  }
  if (!is.null(organisation) && !organisation %in% c("bcgov", "bcgov-c")) {
    stop("organisation must be one of 'bcgov', 'bcgov-c', or NULL", call. = FALSE)
  }

  use_bcgov_req(rmarkdown = rmarkdown, coc_email = coc_email, 
                licence = licence)
  check_git_committer_address()
  use_bcgov_gitattributes()
  
  private <- if (!is.null(organisation) && organisation == "bcgov-c") TRUE else FALSE
  tryCatch(usethis::use_github(organisation = organisation, protocol = protocol, 
                      private = private, ...), 
           error = function(e) {
             if (grepl("(unable to find an inherited method)|(error authenticating)", e$message)) {
               is_git_installed()
               repo_clone_cmd <- paste0("git push -u origin master")
               done("Using system call to git")
               system(repo_clone_cmd)
               done("Navigate to https://github.com/",organisation, "/", basename(usethis::proj_get()), " to view your repo")
             } else {
             stop(e)
             }
           })
}

#' Initialise a Git repository, with bcgov GitHub requirements
#'
#' @inheritParams use_bcgov_req
#' @param message git commit message
#'
#' @export
use_bcgov_git <- function(rmarkdown = TRUE, 
                          licence = "apache2", 
                          coc_email = get_coc_email(), 
                          message = "Initial commit") {
  use_bcgov_req(rmarkdown = rmarkdown, coc_email = coc_email, 
                licence = licence)
  check_git_committer_address(action = if (interactive()) "ask" else "warning")
  usethis::use_git(message)
}

check_git_committer_address <- function(action = c("warning", "stop", "ask")) {
  action <- match.arg(action)
  repo <- if (!is.null(git2r::discover_repository(usethis::proj_get()))) {
    git2r::repository(usethis::proj_get())
  } else {
    NULL
  }
  
  config <- git2r::config(repo = repo)
  local_email <- config$local$user.email 
  global_email <- config$global$user.email
  gov_pattern <- "gov\\.bc\\.ca$"
  
  if (isTRUE(grepl(gov_pattern, local_email)) || # First check for gov local email
      # then check for gov global email IIF local is not set
      (is.null(local_email) && isTRUE(grepl(gov_pattern, global_email)))) {
    return(invisible(TRUE))
  }
  
  msg <- "You have a non-bcgov email address set as your user.email for this repository."
  
  if (action == "ask") {
    ans <- utils::askYesNo(
      paste0(msg, "\nWould you like to continue with your non-gov email address?")
      )
    if (!isTRUE(ans)) {
      stop("Please change your git email address and try again.", call. = FALSE)
    }
    message("Proceeding with non-bcgov email address")
  } else {
    do.call(action, list(msg, call. = FALSE))
  }
  invisible(FALSE)
}

get_coc_email <- function() {
  getOption(
    "bcgovr.coc.email", 
    default = stop("You must set a contact email address for your code of conduct in the
coc_email argument. See ?use_bcgov_code_of_conduct", call. = FALSE))
}

use_bcgov_template <- function(template, save_as = template, data = list(), 
                               ignore = FALSE, open = FALSE) {
    usethis::use_template(template = template, save_as = save_as, data = data, 
                          ignore = ignore, open = open, package = "bcgovr")
}
