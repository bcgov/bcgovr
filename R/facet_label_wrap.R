# Copyright 2015 Province of British Columbia
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
    value <- gsub("(\\b[/:-]\\b)", "\\1 ", value) # Add a space after "-", ":" or "/" if not one there
    lapply(strwrap(as.character(value), width=width, simplify=FALSE), 
           paste, collapse="\n")
  }
}
