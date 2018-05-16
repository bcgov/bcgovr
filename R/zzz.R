.onAttach <- function(libname, pkgname) {
  good_lib <- win_rlib_is_good()
  if (!good_lib$good)
    packageStartupMessage(
"It looks like your R library location is set to somewhere other than your C:/ drive.

  Output of .libPaths():\n    ", 
      paste(good_lib$libs, collapse = "\n    "), "\n\n",
"This can cause problems; it is better to have it on your C:/ drive.
See https://github.com/bcgov/bcgov-data-science-resources/wiki/Installing-R-&-RStudio."
    )
}

win_rlib_is_good <- function() {
  if (.Platform$OS.type != "windows") return(list(good = TRUE))
  list(good = grepl("^[Cc]", .libPaths()[1]),
       libs = .libPaths())
}
