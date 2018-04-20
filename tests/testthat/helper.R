name_incrementer <- function(name) {
  i <- 0
  function() {
    i <<- i + 1
    paste0(name, i)
  }
}
