.onLoad <- function(libname, pkgname) {
  if (!set_ghostscript()) {
    packageStartupMessage("You do not appear to have ghostscript installed. ",
                          "Without it you will not be able to embed fonts in pdfs. ", 
                          "If you require this, please install ghostscript from ", 
                          "'http://ghostscript.com/download/gsdnld.html' and ",
                          "run envreportutils:::set_ghostscript('path_to_executable')")
  }
}

#' Set the environment variable for the path to the ghostscript executable.
#' @param gsfile path to the ghostscript executable
#' @keywords internal
#' @return logical dependent on whether or not the file exists
set_ghostscript <- function(gsfile = "C:/Program Files/gs/gs9.15/bin/gswin64c.exe") {
  ret <- FALSE
  if (file.exists(gsfile)) {
    Sys.setenv(R_GSCMD=gsfile)
    ret <- TRUE
  }
  ret
}
