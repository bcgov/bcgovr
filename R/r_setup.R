#' Set up R for use on a standard B.C. government Windows computer
#'
#' @seealso set_home set_cran_repo
#' @export
#' 
setup_r <- function() {
  set_home()
  set_cran_repo()
}

#' Set HOME environment variable on Windows
#'
#' On many Windows computers in an enterprise environment, the
#' `HOME` environment variable is either unset, or set to a location
#' on a network drive. R doesn't work well with this setup, so this
#' function checks what it is set to, and if it's not on the
#' `C:/` drive, it sets it to the value of `%USERPROFILE%`, usually
#' `C:/Users/[username]`.
#'
#' If you have a `.Rprofile` or `.Renviron` file in your existing `HOME`
#' directory these will be copied to the new location of `HOME`.
#'
#' This also ensures that the user's personal package library is at
#' `C:/Users/[your_username]/R/win-library/[R-version]/` if you
#' haven't already set it via the `R_LIBS` environment variable. It also moves
#' all of your packages from your old library location to the new one.
#' 
#' @seealso set_cran_repo
#'
#' @return the path to `HOME`, invisibly
#' @export
set_home <- function() {
  # Get existing HOME
  home_dir <- Sys.getenv("HOME")
  if (win_env_is_good("HOME")) {
    usethis:::done("HOME env variable already set appropriately")
    return(invisible(home_dir))
  }
  
  # Look for special files in existing HOME
  renviron_file <- file.path(home_dir, ".Renviron")
  rprofile_file <- file.path(home_dir, ".Rprofile")
  
  # Permanently set HOME globally (but doesn't set for current session)
  result <- system('setx HOME "%USERPROFILE%"')
  
  # Set HOME for current session
  user_profile_dir <- Sys.getenv("USERPROFILE")
  Sys.setenv("HOME" = user_profile_dir)
  
  # Check and make sure it worked
  home_dir <- Sys.getenv("HOME")
  if (result > 0L || home_dir != user_profile_dir) stop("HOME not set")
  usethis:::done("HOME env variable set to ", usethis:::value(home_dir))
  
  # Copy any existing .Renviron or .Rprofile files over to new HOME
  if (file.exists(renviron_file)) {
    file.copy(renviron_file, home_dir)
    usethis:::done("Copied existing .Renviron to new HOME directory")
  }
  
  if (file.exists(rprofile_file)) {
    file.copy(rprofile_file, home_dir)
    usethis:::done("Copied existing .Rprofile to new HOME directory")
  }
  
  # If there isn't a library set already, set .libPaths in
  # this session to the path that R will set in future
  # sessions now that HOME has been set
  if (!nzchar(Sys.getenv("R_LIBS"))) {
      set_session_lib_path()
      copy_packages()
  } 
  
  if (!win_env_is_good("R_LIBS")) {
      warning("You have your R_LIBS environment variable set to a location not on your C drive. Consider changing it in your .Renviron file.")
  }
  
  invisible(home_dir)
}

#' Set the default CRAN repository from which to download packages
#'
#' This is achieved by setting the `repos["CRAN"]` option to
#' https://cran.rstudio.com in your `.Rprofile` file
#' 
#' @seealso set_home
#'
#' @return TRUE (invisibly)
#' @export
set_cran_repo <- function() {
  
  if (!win_env_is_good("HOME")) {
    msg <- "It looks like you have your HOME set to a location not on your C drive. See ?set_home"
    warning(paste(strwrap(msg), collapse = "\n"))
  }
  
  rprofile_file <- file.path(Sys.getenv("HOME"), ".Rprofile", fsep = "/")
  
  # Code to set the default CRAN repo to "https://cran.rstudio.com
  set_repo_text <- "r <- getOption(\"repos\")
      r[\"CRAN\"] <- \"https://cran.rstudio.com\"
      options(repos = r)"
  
  # Write it to the .Rprofile file, but this doesn't take effect this session
  cat("local({\n", set_repo_text, "\n})\n",
      file = rprofile_file, append = TRUE)
  
  # Set CRAN repo in current session too so user doesn't have to restart
  eval(parse(text = set_repo_text))
  
  usethis:::done("Setting default CRAN repository to \"https://cran.rstudio.com\" in ", usethis:::value(rprofile_file))
  invisible(TRUE)
}

#' @noRd
win_env_is_good <- function(env_var = "HOME") {
  if (.Platform$OS.type != "windows") return(TRUE)
  grepl("^[Cc]", Sys.getenv(env_var))
}

#' @noRd
set_session_lib_path <- function() {
  path <- make_new_libpath()
  .libPaths(new = path)
  usethis:::done("Setting library location to ", usethis:::value(path))
}

#' @noRd
copy_packages <- function() {
  # find where bcgovr was installed to
  oldpath <- gsub("/bcgovr$", "", find.package("bcgovr"))
  newpath <-  make_new_libpath()
  packages <- list.dirs(oldpath, full.names = TRUE, recursive = FALSE)
  usethis:::done("Copying installed packages to new library location at ", usethis:::value(newpath))
  file.copy(packages, newpath, recursive = TRUE)
}

make_new_libpath <- function() {
  rver <- getRversion()
  path <- file.path(Sys.getenv("HOME"), "R", "win-library",
                    paste0(rver$major, ".", rver$minor))
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  path
}
