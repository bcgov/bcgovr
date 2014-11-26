#' Provides a wrapping function to pass to \code{labeller} argument in \code{ggplot2}'s 
#' \code{facet_grid}
#' 
#' @param  width  The width at which to wrap (in number of characters)
#' @export
#' @details Usage in ggplot2 with facet_grid: \code{ggplot(foo...) + facet_grid(facet_var ~ facet_var2, labeller = facet_label_wrap(25))}
#' @keywords ggplot2 facet_grid labeller wrap
#' @seealso \code{\link[ggplot2]{facet_grid}}
#' @return None
#' @examples \dontrun{
#' 
#'}
facet_label_wrap <- function(width = 25) {
  # https://github.com/hadley/ggplot2/wiki/labeller
  function(variable, value) {
    lapply(strwrap(as.character(value), width=width, simplify=FALSE), 
           paste, collapse="\n")
  }
}
