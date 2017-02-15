#' Add html for BC DevExchange project state badge
#'
#' @param project_state one of:'inspiration', 'exploration', or 'delivery'
#' @param cat use cat to print the result (\code{TRUE}; default) or return a character vector (\code{FALSE})?
#'
#' @return html
#' @export
devex_badge <- function(project_state, cat = TRUE) {
  project_state <- tolower(project_state)
  if (!project_state %in% c("inspiration", "exploration", "delivery") || 
      length(project_state) != 1L) {
    stop("project_state should be one of 'inspiration', 'exploration', or 'delivery'")
  }
  html <- make_badge(state = project_state)
  if (!cat) {
    return(html)
  } else {
    cat(html)
    invisible(NULL)
  }
}

make_badge <- function(state) {
  title <- tools::toTitleCase(state)
  state_desc <- c(inspiration = "An idea being explored and shaped. Open for discussion, but may never go anywhere.", 
                  exploration = "Being designed and built, but in the lab. May change, disappear, or be buggy.", 
                  delivery = "In production, but maybe in Alpha or Beta. Intended to persist and be supported.")[state]
  paste0('<div id="devex-badge"><a rel="', title, 
         '" href="https://github.com/BCDevExchange/docs/blob/master/discussion/projectstates.md"><img alt="', state_desc, 
         '" style="border-width:0" src="https://assets.bcdevexchange.org/images/badges/', state, 
         '.svg" title="', state_desc, '" /></a></div>')
}
