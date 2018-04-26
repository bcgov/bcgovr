if (!usethis:::is_proj()) {
  file.create(".here")
  tmp_here <- TRUE
} else {
  tmp_here <- FALSE
}

original_proj <- usethis::proj_get()

make_test_proj <- function(rstudio = FALSE) {
  dir <- tempfile(pattern = "foo")
  
  usethis::create_project(dir, rstudio = rstudio, open = FALSE)
  invisible(dir)
}

proj_file <- function(file) {
  proj <- usethis::proj_get()
  file.path(proj, file)
}
