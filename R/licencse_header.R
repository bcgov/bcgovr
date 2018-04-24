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
