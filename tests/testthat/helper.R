if (!usethis:::is_proj()) {
  file.create(".here")
  tmp_here <- TRUE
} else {
  tmp_here <- FALSE
}

original_proj <- usethis::proj_get()
original_wd <- getwd()

make_test_proj <- function(rstudio = FALSE) {
  dir <- tempfile(pattern = "foo")
  
  capture.output(usethis::create_project(dir, rstudio = rstudio, open = FALSE))
  invisible(dir)
}

make_test_pkg <- function(rstudio = FALSE) {
  dir <- tempfile(pattern = "foo")
  
  capture.output(usethis::create_package(dir, rstudio = rstudio, open = FALSE))
  invisible(dir)
}

proj_file <- function(file) {
  proj <- usethis::proj_get()
  file.path(proj, file)
}

check_file_contents <- function(text, file){
  any(grepl(text, readLines(proj_file(file)), 
            ignore.case = TRUE))
}

# Save options and set dummy options:
coc_email <- getOption("bcgovr.coc.email")
options("bcgovr.coc.email" = NULL)

