# Copyright 2018 Province of British Columbia
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

#' Add html for inserting a bcgov GitHub lifecycle project state badge
#' 
#' @param project_state One of: 'experimental', 'maturing', 'dormant', 'stable' or 'retired'
#' @param cat Use cat to print the result (\code{TRUE}; default) or return a character vector (\code{FALSE})?
#'
#' @return html
#' @export
insert_bcgov_lifecycle_badge <- function(project_state, cat = TRUE) {
  project_state <- tolower(project_state)
  if (!project_state %in% c("experimental", "maturing", "dormant", "stable", "retired") || 
      length(project_state) != 1L) {
    stop("project_state should be one of 'experimental', 'maturing', 'dormant', 'stable' or 'retired'")
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
  state_colour <- c(experimental = "339999", 
                  maturing = "007EC6",
                  stable = "97ca00",
                  dormant = "%23ff7f2a",
                  retired = "d45500")[state]
  paste0('[![img](https://img.shields.io/badge/Lifecycle-', title, '-', state_colour,
         ')](https://github.com/bcgov/repomountie/blob/8b2ebdc9756819625a56f7a426c29f99b777ab1d/doc/state-badges.md)')
}



#' This function is deprecated, use the `insert_bcgov_lifecycle_badge` function.
#'
#' Add html for inserting a BC DevExchange project state badge
#'
#' @param project_state One of: 'inspiration', 'exploration', 'dormant', 'delivery' or 'retired'
#' @param cat Use cat to print the result (\code{TRUE}; default) or return a character vector (\code{FALSE})?
#'
#' @return html
#' @export
insert_bcgov_devex_badge <- function(project_state, cat = TRUE) {
  .Deprecated("insert_lifecycle_badge")
  insert_bcgov_lifecycle_badge(project_state = project_state, cat = cat)
}






# insert_bcgov_devex_badge <- function(project_state, cat = TRUE) {
#   project_state <- tolower(project_state)
#   if (!project_state %in% c("inspiration", "exploration", "dormant", "delivery", "retired") || 
#       length(project_state) != 1L) {
#     stop("project_state should be one of 'inspiration', 'exploration', 'dormant', 'delivery' or 'retired'")
#   }
#   html <- make_badge(state = project_state)
#   if (!cat) {
#     return(html)
#   } else {
#     cat(html)
#     invisible(NULL)
#   }
# }
# 
# 
# make_badge <- function(state) {
#   title <- tools::toTitleCase(state)
#   state_desc <- c(inspiration = "An idea being explored and shaped. Open for discussion, but may never go anywhere.", 
#                   exploration = "Being designed and built, but in the lab. May change, disappear, or be buggy.", 
#                   delivery = "In production, but maybe in Alpha or Beta. Intended to persist and be supported.",
#                   dormant = "Not currently being worked on, but with plans to come back to the work in the future.",
#                   retired = "No longer being used or supported, recommend not using an alternative option.")[state]
#   paste0('<a id="devex-badge" rel="', title, 
#          '" href="https://github.com/BCDevExchange/assets/blob/master/README.md"><img alt="', state_desc, 
#          '" style="border-width:0" src="https://assets.bcdevexchange.org/images/badges/', state, 
#          '.svg" title="', state_desc, '" /></a>')
# }


#' This function is deprecated, use the `insert_bcgov_devex_badge` function.
#'
#' @param project_state One of: 'inspiration', 'exploration', 'dormant', 'delivery' or 'retired'
#' @param cat Use cat to print the result (\code{TRUE}; default) or return a character vector (\code{FALSE})?
#'
#' @return html
#' @export
devex_badge <- function(project_state, cat = TRUE) {
  .Deprecated("insert_bcgov_devex_badge")
  insert_bcgov_devex_badge(project_state = project_state, cat = cat)
}
