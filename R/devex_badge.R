#' Add html for BC DevExchange project state badge
#'
#' @param project_state one of:'inspiration', 'exploration', or 'delivery'
#' @param cat use cat to print the result (\code{TRUE}; default) or return a character vector (\code{FALSE})?
#'
#' @return html
#' @export
devex_badge <- function(project_state, cat = TRUE) {
  project_state <- tolower(project_state)
  if (project_state == "inspiration") {
    html <- '<a rel="Inspiration" href="https://github.com/BCDevExchange/docs/blob/master/discussion/projectstates.md"><img alt="An idea being explored and shaped. Open for discussion, but may never go anywhere." style="border-width:0" src="http://bcdevexchange.org/badge/1.svg" title="An idea being explored and shaped. Open for discussion, but may never go anywhere." /></a>'
  } else if (project_state == "exploration") {
    html <- '<a rel="Exploration" href="https://github.com/BCDevExchange/docs/blob/master/discussion/projectstates.md"><img alt="Being designed and built, but in the lab. May change, disappear, or be buggy." style="border-width:0" src="http://bcdevexchange.org/badge/2.svg" title="Being designed and built, but in the lab. May change, disappear, or be buggy." /></a>'
  } else if (project_state == "delivery") {
    html <- '<a rel="Delivery" href="https://github.com/BCDevExchange/docs/blob/master/discussion/projectstates.md"><img alt="In production, but maybe in Alpha or Beta. Intended to persist and be supported." style="border-width:0" src="http://bcdevexchange.org/badge/3.svg" title="In production, but maybe in Alpha or Beta. Intended to persist and be supported." /></a>'
  } else {
    stop("project_state should be one of 'inspiration', 'exploration', or 'delivery'")
  }
  html <- paste0('<div id="devex-badge">', html, '</div>')
  if (!cat) {
    return(html)
  } else {
    cat(html)
    invisible(NULL)
  }
}
