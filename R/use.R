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

#' Add BC Government requirements to your project directory
#' 
#' Adds a LICENSE file, a README, a CODE OF CONDUCT and a CONTRIBUTING file
#' 
#' @inheritParams use_bcgov_code_of_conduct
#' @inheritParams use_bcgov_licence
#' @param rmarkdown Should an rmarkdown file be added to the repository
#'   with its corresponding markdown file? Default \code{FALSE}.
#' 
#' 
#' @export

use_bcgov_req <- function(rmarkdown = TRUE, 
                          coc_email = getOption("bcgovr.coc.email", default = NULL), 
                          licence = "apache2"){
  
  if(!(usethis:::is_package() | usethis:::is_proj())){
    usethis::create_project(path = ".")
  }
  
  if (rmarkdown) {
    use_bcgov_readme_rmd(licence = licence)
  } else {
    use_bcgov_readme(licence = licence)
  }
  
  use_bcgov_contributing()
  use_bcgov_code_of_conduct(coc_email = coc_email)
  use_bcgov_licence(licence = licence)
  
  invisible(TRUE)
  
}

#' Add a README.md file to the project directory
#' 
#' @param path Directory path (default `"."`)
#' @param project Name of the project. Defaults to the name of the Rstudio project/working directory
#'
#' @export
#' @seealso [use_bcgov_contributing()], [use_bcgov_licence()], [use_bcgov_code_of_conduct()]
#' @return NULL
use_bcgov_readme <- function(project = NULL, licence = c("apache2", "cc-by")) {
  add_readme(project = project, licence = licence, extension = ".md")
}

#' @inherit use_bcgov_readme
#' @export
use_bcgov_readme_rmd <- function(project = NULL, licence = c("apache2", "cc-by")) {
  add_readme(project = project, licence = licence, extension = ".Rmd")
}

add_readme <- function(project, licence = c("apache2", "cc-by"), extension) {
  licence <- match.arg(licence)
  if (is.null(project)) {
    project = basename(usethis::proj_get())
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
  usethis::use_template(template = paste0(fbase, extension), 
                        save_as = paste0("README", extension),
                        data = list(project_name = project,
                                    cc_link = cc_link,
                                    licence_text = paste0(make_licence_header_text(year, licence), 
                                                          collapse = "\n")), 
                        ignore = package && extension == ".Rmd",
                        package = "bcgovr")
}

#' Add a CONTRIBUTING.md file to the project directory
#' 
#' @export
#' @seealso [use_bcgov_readme()], [use_bcgov_licence()], [use_bcgov_code_of_conduct()]
#' @return `TRUE` (invisibly)
use_bcgov_contributing <- function() {
  usethis::use_template(template = "CONTRIBUTING.md", 
                        ignore = usethis:::is_package(), 
                        package = "bcgovr")
}

#' Add a CODE_OF_CONDUCT.md file to the project directory
#' 
#' @param coc_email Contact email address(es) for the Code of Conduct.
#' @export
#' @seealso [use_bcgov_readme()], [use_bcgov_licence()], [use_bcgov_contributing()]
#' @return `TRUE` (invisibly)
use_bcgov_code_of_conduct <- function(coc_email = getOption("bcgovr.coc.email", default = NULL)) {
  usethis::use_template(template = "CoC.md", 
                        save_as = "CODE_OF_CONDUCT.md",
                        ignore = usethis:::is_package(), 
                        data = list(COC_CONTACT_EMAIL = coc_email),
                        package = "bcgovr")
  
  if (is.null(coc_email)) {
    message("No contact email has been added to your CODE_OF_CONDUCT.md.", 
            "Please do so manually")
  }
}

#' Add a LICENSE file (Apache 2.0 or CB-BY) to the project directory
#' 
#' @param licence Which license to apply? Default is Apache 2.0 (`"apache2"`). 
#' Use `"cc-by"` [Creative Commons Attribution 4.0](https://creativecommons.org/licenses/by/4.0/)
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
  
  usethis::use_template(template = template,
                        save_as = "LICENSE",
                        package = "bcgovr")
  # TODO
  #if (package_desc) {
  #  desc <- readLines(file.path(path, "DESCRIPTION"))
  #  desc[grep("License:", desc)] <- "License: Apache License (== 2.0) | file LICENSE"
  #  writeLines(desc, "DESCRIPTION")
  #}
  invisible(TRUE)
}

#' @export
use_bcgov_license <- use_bcgov_licence

#' Add the boilerplate Apache header to the top of a source code file
#' 
#' @param file Path to the file
#' @param year The year the license should apply (Default current year)
#' @export
#' @seealso [use_bcgov_licence()] [insert_bcgov_cc_header()]
#' @return NULL
insert_bcgov_apache_header <- function(file, year = format(Sys.Date(), "%Y")) {
  
  licence_text <- make_licence_header_text(year, "apache")
  
  write_licence_header(licence_text, file)
  usethis:::done("Adding Apache boilerplate header to the top of ", usethis:::value(file))
  
  invisible(TRUE)
}

#' Add the boilerplate Creative Commons Attribution 4.0 (CC-BY) header to the 
#' top of a source code file
#' 
#' @inheritParams insert_bcgov_apache_header
#' @export
#' @seealso [use_bcgov_licence()] [insert_bcgov_cc_header()]
#' @return NULL
insert_bcgov_cc_header <- function(file, year = format(Sys.Date(), "%Y")) {
  
  licence_text <- make_licence_header_text(year, "cc-by")
  
  write_licence_header(licence_text, file)
  usethis:::done("Adding CC-BY 4.0 boilerplate header to the top of ", usethis:::value(file))
  
  invisible(TRUE)
}

make_licence_header_text <- function(year = NULL, licence = c("apache2", "cc-by")) {
  licence <- match.arg(licence)
  licence_txt <- switch(licence, 
                        "apache2" = c('Copyright {YYYY} Province of British Columbia',
                                      '',
                                      'Licensed under the Apache License, Version 2.0 (the "License");',
                                      'you may not use this file except in compliance with the License.',
                                      'You may obtain a copy of the License at',
                                      '',
                                      'http://www.apache.org/licenses/LICENSE-2.0',
                                      '',
                                      'Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,',
                                      'WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.',
                                      'See the License for the specific language governing permissions and limitations under the License.'),
                        "cc-by" = c('Copyright {YYYY} Province of British Columbia',
                                    '',
                                    'This work is licensed under the Creative Commons Attribution 4.0 International License.', 
                                    'To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/.'
                        ))
  
  if (!is.null(year)) {
    licence_txt <- gsub("{YYYY}", year, licence_txt, fixed = TRUE)
  }
  
  licence_txt
}

write_licence_header <- function(licence_text, file, rstudio = FALSE) {
  
  if (rstudio) {
    file_context <- rstudioapi::getSourceEditorContext()
    in_text <- file_context$contents
    fileext <- tolower(tools::file_ext(basename(file_context$path)))
  } else {
    conn <- file(file)
    on.exit(close(conn))
    in_text <- readLines(conn)
    fileext <- tolower(tools::file_ext(file))
  }
  
  # if html/rmd/md, find yaml and insert <!-- comments -->
  licence_text <- if (fileext %in% c("html", "rmd", "md")) {
    c("<!--", licence_text, "-->")
  } else {
    # Not a html, rmd, or md: use #-style comments
    paste("#", licence_text)
  }
  
  # Check if there is a yaml header, if so, write after the yaml header
  yaml_end <- grep("^---", in_text)[2]
  has_yaml <- if (length(yaml_end) == 1 && !is.na(yaml_end)[1]) TRUE else FALSE
  
  if (!rstudio) {
    out_text <- if (has_yaml) {
      header <- in_text[1:yaml_end]
      
      # Catch the case where there is only a yaml header but no text
      n_lines <- length(in_text)
      rest_of_text <- if (n_lines > yaml_end) in_text[(yaml_end + 1):n_lines] else ''
      
      c(header, 
        '',
        licence_text, 
        '',
        rest_of_text
      )
      
    } else {
      # otherwise just put it at the top
      c(licence_text, 
        '', 
        in_text)
    }
    writeLines(out_text, conn)
    invisible(TRUE)
  } else {
    loc <- if (has_yaml) yaml_end + 1 else 1
    rstudioapi::insertText(paste0(c(licence_text, "\n"), collapse = "\n"), location = c(loc, 1))
  }
  
}
