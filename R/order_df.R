# Copyright 2016 Province of British Columbia
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

#' Create an ordered factor in a data.frame and sort the data.frame by that column
#' 
#' Can use the summary of another column (\code{target_col}), or specify the order manually (\code{factor_order})
#'
#' @param df the data frame to sort
#' @param target_col the column (character or factor) to convert to ordered factor
#' @param value_col the column to use to sort \code{target_col}
#' @param fun function to use to summarize \code{value_col}
#' @param ... other options passed on to \code{fun} (eg. \code{na.rm = TRUE})
#' @param desc should \code{target_col} be sorted according to \code{value_col} in a descending order (default \code{FALSE})
#' @param factor_order a character vector of the unique values in \code{target_col} in the desired order.
#'
#' @return data frame
#' @export
#'
#' @examples
#' set.seed(42)
#' df <- data.frame(Col1 = rep(letters[1:3], 3), 
#'                  Col2 = rnorm(9), 
#'                  Col3 = 1:9, 
#'                  stringsAsFactors = FALSE)
#' 
#' order_df(df, target_col = "Col1", value_col = "Col2", fun = mean)
#' order_df(df, target_col = "Col1", factor_order = c("b", "a", "c"))
order_df <- function(df, target_col, value_col = NULL, fun = NULL, ..., desc = FALSE, factor_order = NULL) {
  if (!target_col %in% names(df)) stop("specified target_col is not a column in df")
  if (!is.null(value_col)) {
    if (!value_col %in% names(df)) stop("specified value_col is not a column in df")
    if (is.null(fun)) stop("You have specified a value_col without specifying fun")
    if (!is.function(fun)) stop("fun is not a valid function")
    if (!is.null(factor_order)) warning(("both value_col and factor_order were specified. Using value_col..."))
    ord <- dplyr::group_by_(df, target_col)
    ## Grab the ... to add to combine with value_col in an unevaluated call containing a list of arguments
    arg_list <- list(as.name(value_col), ...)
    arg_list_quoted <- do.call("call", c("list", arg_list), quote = TRUE)
    
    ## Use do.call to call fun in summarize_, as with the ... we don't know how many and which arguments will be specified
    ord <- dplyr::summarize_(ord, ord_col = lazyeval::interp(~do.call(x, y), 
                                                             .values = list(x = fun, y = arg_list_quoted)))
    
    ## Sort the summarized data frame based on the ordered column
    ord <- dplyr::arrange_(ord, "ord_col")
    
    ## Get the target column (now in order), and reverse it if desc = TRUE
    lvls <- ord[[target_col]]
    
  } else if (!is.null(factor_order)) {
    if (!setequal(factor_order, unique(df[[target_col]]))) {
      stop("specified values in factor_order are not the same as those in target_col")
    }
    
    lvls <- factor_order
    
  } else {
    stop("You must specificy either value_col or factor_order")
  }
  
  if (desc) lvls <- rev(lvls)
  
  ## Make target_col an ordered factor with order based on lvls
  df[[target_col]] <- factor(df[[target_col]], levels = lvls, ordered = TRUE)
  
  ## Arrange the data frame based on the new factor levels in target_col
  dplyr::arrange_(df, target_col)
  
}
