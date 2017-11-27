#' Add html for BC DevExchange project state badge
#'
#' @param project_state one of:'inspiration', 'exploration', 'dormant', 'delivery' or 'retired'
#' @param cat use cat to print the result (\code{TRUE}; default) or return a character vector (\code{FALSE})?
#'
#' @return html
#' @export
devex_badge <- function(project_state, cat = TRUE) {
  project_state <- tolower(project_state)
  if (!project_state %in% c("inspiration", "exploration", "dormant", "delivery", "retired") || 
      length(project_state) != 1L) {
    stop("project_state should be one of 'inspiration', 'exploration', 'dormant', 'delivery' or 'retired'")
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
                  delivery = "In production, but maybe in Alpha or Beta. Intended to persist and be supported.",
                  dormant = "Not currently being worked on, but with plans to come back to the work in the future.",
                  retired = "No longer being used or supported, recommend not using an alternative option.")[state]
  paste0('<a id="devex-badge" rel="', title, 
         '" href="https://github.com/BCDevExchange/assets/blob/master/README.md"><img alt="', state_desc, 
         '" style="border-width:0" src="https://assets.bcdevexchange.org/images/badges/', state, 
         '.svg" title="', state_desc, '" /></a>')
}
