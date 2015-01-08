.onLoad <- function(libname, pkgname) {
  set_ghostscript()
}

set_ghostscript <- function(gsfile = "C:/Program Files/gs/gs9.15/bin/gswin64c.exe") {
  if (file.exists(gsfile)) {
    Sys.setenv(R_GSCMD=gsfile)
  } else {
    packageStartupMessage("You do not appear to have ghostscript installed. ",
                          "Without it you will not be able to embed fonts in pdfs. ", 
                          "Please install it from ", 
                          "'http://ghostscript.com/download/gsdnld.html' and ",
                          "run envreportutils:::set_ghostscript('path_to_executable')")
  }
}
