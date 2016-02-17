#' Get colour codes for B.C. Biogeoclimatic (BGC) Zones
#'
#' @param which Optionally specify the codes for the BGC zones you want. 
#' If \code{NULL} (the default), will return colours for all zones
#'
#' @return A named character vector of hexadecimal colour codes, where the names are BGC Zone codes
#' @export
#'
#' @examples
#' bgc_colours()
#' bgc_colours(c("BAFA", "CWH"))
bgc_colours <- function(which = NULL) {
  cols <- c(BAFA = "#E5D8B1",
            SWB  = "#A3D1AB",
            BWBS = "#ABE7FF",
            ESSF = "#9E33D3",
            CMA  = "#E5C7C7",
            SBS  = "#2D8CBD",
            MH   = "#A599FF",
            CWH  = "#208500",
            ICH  = "#85A303",
            IMA  = "#B2B2B2",
            SBPS = "#36DEFC",
            MS   = "#FF46A3",
            IDF  = "#FFCF00",
            BG   = "#FF0000",
            PP   = "#DE7D00",
            CDF  = "#FFFF00")
  
  if (is.null(which)) {
    return(cols)
  } else {
    if (!all(which %in% names(cols))) stop("Unknown Biogeoclimatic Zone code(s) specified", call. = FALSE)
    return(cols[which])
  }
}
