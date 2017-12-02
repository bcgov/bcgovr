not_done <- function(...) {
  usethis:::bullet(paste0(...), bullet = crayon::red(clisymbols::symbol$cross))
}

congrats <- function(...) {
  usethis:::bullet(paste0(...), bullet = crayon::yellow(clisymbols::symbol$star))
}
